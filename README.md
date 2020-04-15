Source code for https://www.nicolabs.net

## Assets/blog folder

The [assets/blog](assets/blog) folder gathers asset files used in articles.

It keeps the same layout as the previous wesite located from http://www.nicobo.net/sites/default/files in order to ease migration of URLs, but the `pictures` subfolder may not be used for new assets.

The new layout is :

    3rdparty/       # local copy of remote pictures, some modified (e.g. resized)
        \_ logos/   # icons & logos of third party products
        \_ images/  # photos & pictures taken from external sources
    screenshots/    # screen captures or alike used to illustrate some articles


## Previewing locally

Run `bundle exec jekyll serve --livereload -H '*' --drafts` to start a local server with automatic reload and drafts preview.


### Drafts

**Jekyll drafts** (articles in `_drafts/`) are *absolutely not ready* for publication. Some of them are *still* old documents I've never finished...
On the other hand, **articles tagged with _draft_** (in `_posts/`) are published with a special mention so that they hopefully can be useful to anybody : old drafts are slowly being published with this *draft* mention.
There are other mentions (*unpublished*, *draft*, *good*, *stable*, *deprecated*) to indicate articles' maturity.

See [Migrating from Drupal to Jekyll](_posts/Migrating-from-Drupal-to-Jekyll.md) for the explanation.
Most of the code lies in `_includes/maturity.html` and `_sass/nicolabs/*.scss` in order to :
- display the maturity label in each article's header
- advertise unstable articles in indexes (`index.html`, `tags.html`)
- remove drafts from the default feed


## Publishing

1. Update Ruby gems & build the final site without drafts :

    sudo bundle update
    bundle exec jekyll build

2. Add, commit & push files [into the *master* git branch](https://help.github.com/en/github/working-with-github-pages/about-github-pages#publishing-sources-for-github-pages-sites), including the `docs` directory (same as Jekyll's `_site` directory, but renamed for github pages)

See [Bypassing GitHub's Jekyll limitations](_posts/2020-04-13-Bypassing-GitHub-Jekyll-limitations.md) for more informations.
