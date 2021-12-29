---
title: Speed up your automated Docker builds with GitHub Actions
layout: post
date: 2021-03-23
tags:
  - docker
  - github
  - github actions
  - ci
maturity: draft
---

![Docker & cats illustration by bloglaurel - https://www.deviantart.com/bloglaurel/art/Happy-International-Cat-Day-697676638](/assets/blog/3rdparty/pictures/happy_international_cat_day___by_bloglaurel_dbjdmqm.jpg){:width="100%"}
<figcaption>Docker & cats illustration by bloglaurel - https://www.deviantart.com/bloglaurel/art/Happy-International-Cat-Day-697676638</figcaption>

## Introduction

The [universally](https://docs.docker.com/ci-cd/github-actions/) [advertized](https://www.docker.com/blog/docker-github-actions/) [way](https://docs.github.com/en/actions/guides/publishing-docker-images) of building Docker images with GitHub is to set up a [**GitHub Actions**](https://docs.github.com/en/actions) workflow.

*Github Actions* (GA) is actually very easy to use but nonetheless still [under heavy development](https://github.com/actions/cache/graphs/code-frequency).

Unfortunately, almost all tutorials out there are based on (the same) very simplistic use cases. I just couldn't get it right by simply following them : I've literally spent hours to test and understand how to *leverage the cache action for Docker multi-stage builds*.

I hope this post will be useful to anyone with a similar use case.

<!--more-->

This article will *not* describe how to make your first GA workflow.
We will look at *traps to avoid* when **building multiple and multi-stage Docker images with GA**, essentially covering caching, and more specifically using *actions/cache@v2*.


## Use parallelism

The first thing to take care of when building multiple images is to run tasks in parallel, whenever possible :

- Docker's *buildx* command already takes care of [multi-platform parallel building](https://docs.docker.com/buildx/working-with-buildx/#build-multi-platform-images) so **using [docker/build-push-action@v2](https://github.com/docker/build-push-action) in your workflow is the way to go**.

- You will also need to figure out how you can **split your build in several *workflows* or *jobs***.
[In GA, workflows run in parallel, as well as jobs inside a workflow](https://docs.github.com/en/actions/learn-github-actions/introduction-to-github-actions), by default.

Let's consider my use case. I have 3 images : *alpine*, *debian* and *signal-debian*, from which the first one : *alpine*, has no dependency on the 2 others.

Building them sequentially (as subsequent *steps* in a *job*) resulted in 1h50 runs... By simply building the *alpine* image in its own job **I saved 40 min** (the duration of the *alpine* build) !

```yaml
jobs:

  build-publish-alpine:
    name: Build, Publish alpine
    environment: prod
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2

  ...

  # This job will run in parallel of build-push-alpine
  build-publish-debian:
    name: Build, Publish debian
    environment: prod
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2
```


I leave it up to you to look at [the documentation](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobs) :
- ordering with [jobs.\<job_id\>.needs](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idneeds)
- can mutualize variables, steps, outputs, ...


## Use caching

Building Docker images on your local machine uses cache by default. If your Dockerfile is correctly crafted this DRASTICALLY enhances build time. In my case, building from scratch takes up hours. My first concern was therefore to ensure my Dockerfiles were always [cache-optimized](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#leverage-build-cache).

When building with GitHub Actions however, caching is not straightforward.

Let's start with a conceptual difference between :

1. **sharing cache during the build** (e.g. image1 you just built which is also the base image of image2 in the *same* workflow) - doing this reduces build duration when using the same layers multiple times during the build (multi-arch builds probably do)

2. **reusing cache from previous builds** - when you push a small modification in your code and the images have to be rebuilt, you would probably be grateful to get back the cache from the previous push, which was from *a past* workflow

There are two ways to cache data with GitHub actions : [upload-artifact and download-artifacts](https://docs.github.com/en/actions/guides/storing-workflow-data-as-artifacts) actions and [actions/cache](https://github.com/actions/cache) action.

Although *actions/upload-artifact* and *actions/download-artifact* might be able to cover both points above, it is not meant to cache docker layers. [The major recommended approach I've seen](https://docs.github.com/en/actions/guides/caching-dependencies-to-speed-up-workflows#comparing-artifacts-and-dependency-caching) is to use **actions/cache@v2**, which also covers the two concepts.

> **NOTE** In theory, the 'artifact' approach should also work, but is not advertized for this kind of usage. This is maybe the premises of a future update to this article.


### Set mode=max

Common snippets found on the web for the *docker/build-push-action* **will only cache final Docker images** :

```yaml
- name: Build and push
  id: docker_build
  uses: docker/build-push-action@v2
  with:
    context: ./
    file: ./Dockerfile
    builder: ${{ steps.buildx.outputs.name }}
    push: true
    tags:  ushamandya/simplewhale:latest
    cache-from: type=local,src=/tmp/.buildx-cache
    cache-to: type=local,dest=/tmp/.buildx-cache
```

If you deal with multi-stage Dockerfiles, you SHOULD absolutely [set `mode=max` attribute on the `cache-to` entry to enable caching of layers from all stages](https://github.com/docker/buildx#--cache-tonametypetypekeyvalue) :

```yaml
    cache-to: type=local,dest=/tmp/.buildx-cache,mode=max
```

For me, this reduced the build time of individual jobs using the cache **from ~45 minutes to 5-10 minutes !**


### There is an overhead

With this technique, subsequent runs of the same job will still vary (this is why I've stated a 5-10 min. variation above).
It is due to *actions/cache*, which saves and retrieves the cache from a remote storage (S3 or alike). **The more the cache grows, the longer it takes to get and save it.**

I've observed varying overheads from 1 min. for a 2GB cache, up to 7 min. for a 4GB+ cache (including both download and upload). Repeat this for every job...

The exact pattern depends on what you put in the cache but this is something you should definitely keep in mind, as caching may not be worth it, for instance if your build is fast and uses a large cache.


### There is a size limit

GitHub offers 5GB of storage : when this limit is reached or a week has passed, old caches will be deleted (based on their key).

This can be problematic if you build generates a large cache, because the closer your build reaches this limit on each run, the less you will benefit from it, as recent data will be deleted before they can be used.

The worst case happened to me : I was building 3 images using multi-stage builds and including large base image : the build typically exceeded the 5GB limit on each run and at least one of the 3 caches was deleted everytime, meaning that only 1 or 2 images could reuse the cache from the previous run.

In the worst case, if your build always exceeds the cache limit, the cache will be discarded everytime and you will only be able to get some benefit from within a job, not between two subsequent runs.

Your best bet to overcome this limit would probably be to use self-hosted runners or external storage (e.g. AWS), however if you feel up to it here are some tips :

- you may observe `No space left on device` errors when you reach the max. cache size. It is very annoying but you may be able to bypass this by moving the cache to another mount point with more space (make a step `run: sudo df -h` to check ; I've observed `/` with 22 GB free on my setup)
- you may try to split into more jobs (so smaller caches) to prevent the filesystem to fill up and crash, as it seems that eviction is not done while the runner is alive.
- `mode=max` can highly increase the cache's size and cause errors or early evictions : you may find the default mode a good compromise for your usage
- insert [a custom variable in the cache's key](https://github.community/t/how-to-clear-cache-in-github-actions/129038/5) so that you can reset it if your build is stuck because of a corrupted cache
- maybe you should use multiple GitHub projects rather than a single one (e.g. one Dockerfile per project, if it's not overkill)


#### Sample workflow that could be split into several jobs

In the example below, 2 steps share the same cache. If the 1st step 'docker_build_debian' fills up the cache with 5GB of docker layers, the 2nd step 'docker_build_alpine' will likely not be able to add more content to the cache and will either crash or be discarded by GitHub prior to the next run, forcing it to start again from an empty cache.

```yaml
- name: Cache Docker layers
  uses: actions/cache@v2
  with:
      path: /tmp/.buildx-cache
      key: ${{ runner.os }}-buildx-debian-${{ github.sha }}
      restore-keys: |
        ${{ runner.os }}-buildx-debian-
        ${{ runner.os }}-buildx-

- name: Build and push debian
  id: docker_build_debian
  uses: docker/build-push-action@v2
  with:
      context: ./
      file: ./debian.Dockerfile
      builder: ${{ steps.buildx.outputs.name }}
      push: true
      cache-from: type=local,src=/tmp/.buildx-cache
      cache-to: type=local,dest=/tmp/.buildx-cache,mode=max

- name: Build and push alpine
  id: docker_build_alpine
  uses: docker/build-push-action@v2
  with:
      context: ./
      file: ./alpine.Dockerfile
      builder: ${{ steps.buildx.outputs.name }}
      push: true
      cache-from: type=local,src=/tmp/.buildx-cache
      cache-to: type=local,dest=/tmp/.buildx-cache,mode=max
```


### The key to cache matching

The *actions/cache* matching algorithm is based on the cache's *key*, which could be thought as a branch in a tree : from the trunk to the leafs, the latter representing the most specific cache. If your build does not match or evict the cache as expected, I encourage you to [read the docs thoroughly](https://docs.github.com/en/actions/guides/caching-dependencies-to-speed-up-workflows#matching-a-cache-key), including the examples, as it may reveal the root cause.

You will not want, for instance, to share the same prefix between 2 jobs that have no Docker layer in common (e.g. a *FROM alpine* and a *FROM debian* may not), otherwise each one might match the cache of the other one, increasing its size by adding its own layers but without finding any layer to reuse.

In the following execution trace of the *Cache Docker layers* step, we see that although we are in the section that builds the *debian* image (`key: Linux-buildx-debian-9176c5bd644818205d94a68221a7ebf27005b30e`), it hits the previous cache from the *alpine* image (`Cache restored from key: Linux-buildx-alpine-75bd3133c854ab90910b7ceb92445fafbe256260`), which has little chance to provide the layers it needs :

```
Run actions/cache@v2
  with:
    path: /tmp/.buildx-cache
    key: Linux-buildx-debian-9176c5bd644818205d94a68221a7ebf27005b30e
    restore-keys: Linux-buildx-debian-
  Linux-buildx-

  env:
    pythonLocation: /opt/hostedtoolcache/Python/3.9.1/x64
    LD_LIBRARY_PATH: /opt/hostedtoolcache/Python/3.9.1/x64/lib
    DEBIAN_TAGS: ***/nicobot:dev-debian
    SIGNAL_DEBIAN_TAGS: ***/nicobot:dev-signal-debian
    ALPINE_TAGS: ***/nicobot:dev-alpine
    NICOBOT_VERSION: 0.1.dev1
Received 67108864 of 4381819546 (1.5%), 63.8 MBs/sec
Received 218103808 of 4381819546 (5.0%), 103.8 MBs/sec
[...]
Cache Size: ~4179 MB (4381819546 B)
/bin/tar --use-compress-program zstd -d -xf /home/runner/work/_temp/3eafeb81-b970-4b87-9515-d659390d4387/cache.tzst -P -C /home/runner/work/nicobot/nicobot
Cache restored from key: Linux-buildx-alpine-75bd3133c854ab90910b7ceb92445fafbe256260
```

A more efficient use of GA cache here would be to make sure they target separate caches so they can be evicted separately.
This can be done by limiting the `restore-keys` to non-overlapping values :

```yaml
- name: Cache Docker layers
  uses: actions/cache@v2
  with:
      path: /tmp/.buildx-cache
      key: ${{ runner.os }}-buildx-debian-${{ github.sha }}
      restore-keys: |
        ${{ runner.os }}-buildx-debian-

...

- name: Cache Docker layers
  uses: actions/cache@v2
  with:
      path: /tmp/.buildx-cache
      key: ${{ runner.os }}-buildx-alpine-${{ github.sha }}
      restore-keys: |
        ${{ runner.os }}-buildx-alpine-
```


## Conclusion

Out of the box, *GitHub Actions* allows to quickly set up continuous integration workflows for very basic requirements.

First make sure to design your workflows so that they **take advantage of parallel building**. Think about the dependencies between your steps.

Caching is another key factor to faster builds : the **actions/cache@v2** action can greatly improve the speed of the builds (x5 to x9 !).
However, to use it right, this action requires a deep understanding of its internal workflow and the current limit to 5GB may compel you to spin custom runners or add your own storage, if your build regularly exceeds this limit.
You may also not need to use such a cache if your build only takes a few minutes to complete, as downloading & saving the cache adds an overhead to the total execution time.

This article showed some tips and workarounds to get the maximum of *actions/cache* : by combining some of those practices **I was able to speed up repeated builds of 3 complex images from 1h50 to 10 minutes...**

My final word would be to **build & test a maximum on your workstation** so you won't need to spend time on the tricky parts of this article. Once your build has become stable you will not bother waiting from time to time for it to end, as you will be confident that it will succeed in one attempt. For a lot of Docker build scenarios parallelization and basic caching alone will be sufficient.


## References

- [actions/cache](https://github.com/actions/cache)
- [whoan/docker-build-with-cache-action](https://github.com/whoan/docker-build-with-cache-action)
- [Awesome Actions](https://github.com/sdras/awesome-actions)
- [Storing & retrieving *github artifacts*](https://docs.github.com/en/actions/guides/storing-workflow-data-as-artifacts)
