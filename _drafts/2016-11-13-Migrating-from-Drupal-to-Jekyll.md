---
layout: post
title: Migrating from Drupal to Jekyll
tags:
  - blogging
  - drupal
  - github
  - jekyll
  - web design
last_modified_at: 2019-09-02
---

TO ADD TO EXISTING ARTICLE

- the 'drafts' feature of Jekyll is not appropriate : using a branch in git is just simpler and better, as I can maintain a "released" version of an article while elaborating the next one in a "unpublished" branch
- It could be another engine than Jekyll (e.g. Hugo), the important thing is to keep it "static" (no hosting of dynamic services) because it allows for the maximum portability : almost all hosting services on earth support static files. It also enables a great evolutivity since I don't depend on a host to build my site. Currently I use github's automatic build system but I could build the site on my machine and just upload the result. It's quite enough for a personal blog. If any dynamic service would be required however, an existing service should be used if possible, else the most portable way would be to use another dedicated host to run my own services. In all cases, using dynamic services should be used sparsingly (I'm still only talking in the case of a blog) and thought as switchable.
