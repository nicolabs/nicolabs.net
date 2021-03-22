---
title: Speed up your automated Docker builds with GitHub Actions
layout: post
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

If you deal with multi-stage Dockerfiles, you MUST absolutely [set `mode=max` attribute on the `cache-to` entry to enable caching of layers from all stages](https://github.com/docker/buildx#--cache-tonametypetypekeyvalue) :

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

, if it is present or absent/has been deleted as per the GH retention policy (in which case it's fast because it's initialized).

Don't be too greedy on cache reuse because if may lead a lot of steps to use the same cache, and therefore it will never be released.

For instance in this example, if the step *docker_build_debian* fills the cache with 5GB, it will be the only cache as it uses all the allowed space. The *docker_build_alpine* will likely not be able to add more content to the cache or it will be the whole cache will be discarded later by github, forcing the next build to start from scratch.

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

If the 2 steps *docker_build_debian* and *docker_build_alpine* don't need to share the same cache (here they have different base images and intermediate layers), a more efficient use of GA cache here would be to make sure they generate separate caches so they can be evicted separately.
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

In the worst case, if your build always exceeds the cache limit, the cache will be discarded everytime and you will only be able to get some benefit from within a job, not between two subsequent runs.

In other cases (after a week a cache has not been used or if you have several caches which don't exceed the limit individually but overall do), you will observe longer builds from time to time because some caches have been evicted.



## Storage size limitations

On GH : 5GB for cache, 22 GB as observed for the Docker /var/lib (actually /).

> **NOTE** : You may be able to overcome this limit with self-hosted runners, external storage (e.g. AWS), multiple GH projects (as the limits are per project), ...

In order to get full benefits of GH services it is possible to do some optimizations.

Split in jobs when possible, to allow the cache to be released (it appears that cache eviction is not done while the runner is alive).

Splitting in smaller jobs also reduce the chances that the filesystem grows to much during a monolothic step.


## Keep up with the flow

It's probably a good idea to include some sanity checks / actions in your jobs to be more future proof regarding new or recurring bugs.

Example for Ubuntu :

```yaml
- name: Sanity actions
  run: |
    # Will print the filesystem mounts and available storage
    sudo df -h
    # May free up some place
    sudo apt clean
```

## Conclusion

Out of the box, GA allows to quickly set up continuous integration workflows for very basic requirements.

First make sure to design your workflows so that they **take advantage of parallel building**.

Caching is another key factor to faster builds : the **actions/cache@v2** action can greatly improves the speed of the builds (x5 to x9).
However, to use it right, this action requires a deep understanding of its internal workflow and is limited to 5GB in size, such that it loses most its interest if your build regularly exceeds this limit.
You may also not need to use such a cache if your build only takes a few minutes to complete, as downloading & saving the cache adds an overhead to the total execution time.

This article showed some tips and workaround to get the maximum of it, but while the current **cache is limited to 5GB**, alternatives - like self-hosted runners, external storage, splitting in multiple github repositories or re-thinking about which cases should trigger a build at first - may be more suited for storage-demanding use cases like multi-images Docker builds.

By combining all practices described here, **I was able to speed up repeated builds of 3 complex images from 1h50 to 10 minutes**.


## References

- [actions/cache](https://github.com/actions/cache)

https://github.com/whoan/docker-build-with-cache-action
https://github.com/sdras/awesome-actions
Storing & retrieving *github artifacts*](https://docs.github.com/en/actions/guides/storing-workflow-data-as-artifacts)
