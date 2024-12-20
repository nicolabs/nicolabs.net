Source code for https://www.nicolabs.net

## Setup

- Install **ruby** : `sudo apt install ruby`
- Install **bundler** : `gem install bundler`
- Install **jekyll** : `sudo gem install jekyll jekyll-feed jekyll-gist jekyll-paginate jekyll-sass-converter jekyll-coffeescript`
- [Install **plantuml** and a `plantuml` command in the PATH](https://github.com/yegor256/jekyll-plantuml#install-plantumljar) (requirement of *jekyll-plantuml*) (and probably **dot** : `sudo apt install graphviz` for Debian systems)
- Install **make** then run `make setup` (or look into `Makefile` for the underlying commands)


## Assets/blog folder

The [assets/blog](assets/blog) folder gathers asset files used in articles.

It keeps the same layout as the previous website located from http://www.nicobo.net/sites/default/files in order to ease migration of URLs, but the `pictures` subfolder may not be used for new assets.

The new layout is :

    3rdparty/       # local copy of remote pictures, some modified (e.g. resized)
        \_ logos/   # icons & logos of third party products
        \_ images/  # photos & pictures taken from external sources
    screenshots/    # screen captures or alike used to illustrate some articles


## Previewing locally

Run the following to update Ruby gems & and start a local server with automatic reload and drafts preview :

```shell
make serve
```


## Drafts

**Jekyll drafts** (articles in `_drafts/`) are *absolutely not ready* for publication. Some of them are *still* old documents I've never finished...
On the other hand, **articles tagged with _draft_** (in `_posts/`) are published with a special mention so that they hopefully can be useful to anybody : old drafts are slowly being published with this *draft* mention.
There are other mentions (*unpublished*, *draft*, *good*, *stable*, *deprecated*) to indicate articles' maturity.

See [Migrating from Drupal to Jekyll](_posts/Migrating-from-Drupal-to-Jekyll.md) for the explanation.
Most of the code lies in `_includes/maturity.html` and `_sass/nicolabs/*.scss` in order to :
- display the maturity label in each article's header
- advertise unstable articles in indexes (`index.html`, `tags.html`)
- remove drafts from the default feed

Drafts don't appear in the RSS feed, as this would trigger false updates until the article is ready for release (the publication date would change all the time).
The current workaround is to put those articles in a *preposts* collection until ready.


## Fullscreen pictures & PlantUML diagrams

I found it to be necessary to better display PlantUML diagrams.

This is implemented with :
- a [modified version](_plugins/jekyll-plantuml.rb) of [jekyll-plantuml](https://github.com/yegor256/jekyll-plantuml)
    - because it is the Jekyll integration advertized on plantuml.com
    - however it generates only `<svg>` inside `<object>`, which is not fullscreen-compatible OOTB => I replaced with `<img>` using the generated SVG as source
    - and it generated files in the root of the project
    - TODO anyway a replacement that uses Markdown standard `  \`\``plantuml` rather than Jekyll-specific `{% plantuml %}` syntax should be found
- assets/lib/[screenfull.js polyfill](https://github.com/sindresorhus/screenfull.js) (seen at *Modernizr*) and [a few lines of code](/_includes/head.html) to activate it
- [very few CSS](_sass/nicolabs/layout.css)

Based on :
- https://developer.mozilla.org/en-US/docs/Web/API/Fullscreen_API
- https://developer.mozilla.org/en-US/docs/Web/API/Fullscreen_API/Guide
- https://caniuse.com/#feat=fullscreen
- https://developer.mozilla.org/fr/docs/Apprendre/HTML/Comment/Ajouter_des_images_vectorielles_%C3%A0_une_page_web


## Publishing

1. Build the final site without drafts :

```shell
make build
```

2. Add, commit & push files [into the *master* git branch](https://help.github.com/en/github/working-with-github-pages/about-github-pages#publishing-sources-for-github-pages-sites), including the `docs` directory (same as Jekyll's `_site` directory, but renamed for github pages)

See [Bypassing GitHub's Jekyll limitations](_posts/2020-04-13-Bypassing-GitHub-Jekyll-limitations.md) for more informations.
