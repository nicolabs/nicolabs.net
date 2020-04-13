---
layout: post
title: Bypassing GitHub's Jekyll limitations
tags:
  - blogging
  - jekyll
  - github
maturity: good
---

As I feared when I [migrated to GitHub's hosting]({% post_url 2016-11-13-Migrating-from-Drupal-to-Jekyll %}), it has become too complicated to overcome GitHub's limitations on Jekyll plugins and features.

I just needed to create a [*collection*](https://jekyllrb.com/docs/collections/) to put my ["live drafts"]({% post_url 2016-11-13-Migrating-from-Drupal-to-Jekyll %}) into it, but the deprecated *jekyll-paginate* plugin provided with GitHub pages didn't support collections.

I therefore switched to offline-building my site and pushing the generated static files to GitHub, which now serves them without Jekyll processing. I still use Jekyll to generate the final static files, which is perfectly ok.

[GitHub's documentation about this](https://help.github.com/en/github/working-with-github-pages/about-github-pages#static-site-generators) is not very clear on the way one can still use *an autonomous* Jekyll installation to build offline, without them building the site with **their** locked-down Jekyll pipeline.
I assumed that I had to consider the procedure that applied to other tools. I had to :

- create a `.nojekyll` file in the root of the repo
- change [Jekyll's output directory](https://jekyllrb.com/docs/configuration/options/) from `_site` to `docs`
- use the standard Jekyll dependencies in my *Gemfile* and specify the full [list of plugins previously overwritten by github-pages](https://github.com/github/pages-gem/blob/master/lib/github-pages/plugins.rb) in `Gemfile` & `_config.yml`
- import and commit the code for the submodule *mastodon-timeline-widget* inside this repo, not only leaving the `.gitmodules` file (static Javascript files that are used in the site, which were pulled automatically during GitHub's processing)
- make sure a `docs/CNAME` text file containing the domain to serve is present after each build (I discovered [it is created when the custom domain is enabled on GitHub](https://github.com/mkdocs/mkdocs/pull/1497/commits) ; unfortunately it is in the output `docs/` directory, which may legitimately be deleted with a simple `jekyll clean`)
- I also had to change the name of the repo from *nicolabs.github.io* to *nicolabs.net* so it is not recognized as a user/organization repo, which was preventing me to put the code in a `docs` subdirectory (I already had an `index.html` which had to be processed by Jekyll in the repo's root, and therefore the website's root could not be placed here)

Overall it was very easy and quick to migrate !
