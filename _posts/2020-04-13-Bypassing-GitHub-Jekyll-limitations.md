---
layout: post
title: Bypassing GitHub's Jekyll limitations
tags:
  - blogging
  - jekyll
  - github
maturity: good
---

As I fear when I [migrated to GitHub's hosting]({% post_url 2016-11-13-Migrating-from-Drupal-to-Jekyll %}), it has become too complicated to overcome GitHub's limitations on Jekyll plugins and features.

I just needed to create a *collection* to put my "live drafts" into it, but the deprecated *jekyll-paginate* plugin provided with GitHub pages didn't support collections.

I therefore switched to offline-building my site and pushing the generated static files to GitHub, which now serves them without Jekyll processing. I still use Jekyll to generate the final static files, which is perfectly ok.

[GitHub's documentation about this](https://help.github.com/en/github/working-with-github-pages/about-github-pages#static-site-generators) is not very clear on the way one can still use Jekyll to build offline, but without them building the site with **their** locked-down Jekyll pipeline. I assumed that I had to consider the procedure that applied to other tools.

For the record, I had to :

- create a `.nojekyll` file in the root of the repo
- change Jekyll generation directory from `_site` to `docs`
- use the standard Jekyll dependencies in my *Gemfile* and specify the full [list of plugins previously overwritten by github-pages](https://github.com/github/pages-gem/blob/master/lib/github-pages/plugins.rb) in `Gemfile`, `_config.yml`
- import and commit the code for the submodule *mastodon-timeline-widget* inside this repo (static Javascript files that are used in the site, which were pulled automatically during GitHub's processing)
- I also had to change the name of the repo from *nicolabs.github.io* to *nicolabs.net* so it is not recognized as a user/organization repo, which was preventing me to put the code in a `docs` subdirectory (I already had an `index.html` which had to be processed by Jekyll in the repo's root)

In the end I'm very happy that it was so easy to migrate !
