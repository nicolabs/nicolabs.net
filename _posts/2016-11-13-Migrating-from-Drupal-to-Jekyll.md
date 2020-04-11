---
layout: post
title: Migrating from Drupal to Jekyll
tags:
  - blogging
  - drupal
  - github
  - jekyll
  - web design
date: 2016-11-13
last_modified_at: 2020-03-31
maturity: stable
---

![Previous blog's banner background](/assets/blog/nicobo-landscape.png)

## New blog concept ?

I write articles about things that required enough amount of work for them to be considered worth sharing.
Writing, in turn, also require a fair amount of work to be comprehensive and accurate enough.

I have to admit however that I don’t have time to write advanced articles as much as I would like to.
Many of them just stay unfinished in a draft state, never published...

Therefore this blog is going to show shorter (and some unfinished) articles !
The good news is that some content that was hidden, in draft state, is going to be live !

A first approach was to simply use a *git* branch to put drafts (usually named 'develop'), then merge them into the 'master' branch ; but that would imply either to publish two blogs : 'draft' and 'release' or to create a mechanism to merge the two branches into the same blog.

I finally opted for a label in each article indicating its *maturity level* :

- <span class="post-header"><span class="post-meta"><span class="maturity-label maturity-draft">draft</span></span></span> A *draft* label means something like "This article is in the process of being written, take it carefully as it may be wrong or change tomorrow". **I don't endorse** the content of such articles even if published, however one may find its content useful in some way...
- <span class="post-header"><span class="post-meta"><span class="maturity-label maturity-good">good</span></span></span> An article with a *good* maturity is one that I consider ready for publication, even if it has some minor flaws or missing parts.
- <span class="post-header"><span class="post-meta"><span class="maturity-label maturity-stable">stable</span></span></span> *Stable* articles are the ones that have been published for a long time or that I consider rock-solid.
- <span class="post-header"><span class="post-meta"><span class="maturity-label maturity-deprecated">deprecated</span></span></span> Some articles may explicitly be labeled as *deprecated* in order to emphasize the fact that they have deprecated content and should only be considered by people living in the past. Deprecation might not be a concept that suits perfectly within a maturity life cycle like previous labels, but for now I prefer keeping things simple and not using another tagging system.

Please note that some articles may show a *stable* maturity while talking about *deprecated* things. This is because an article may still be relevant even when talking about supplanted technologies, and also because I'm not going to constantly review old articles to check if they're still at the cutting edge... [Scaffolding the Web 2.0](/articles/scaffolding-web-20) is a very good example of that case.

In order to get an idea of the freshness of an article, I therefore print both its *creation* and *last update* times, allowing people to judge by themselves if it's likely to be up-to-date or not.

The paradigm I was fond of is therefore changing : a permanent URL on this blog still leads to the same article, but its content can definitely change (and break referring sources). In order to reference a content at a given fixed time, one can link to the original content on GitHub : there is a link to the full history of each article over their creation and update times labels (try with this one).

Lastly, I still use the [drafts feature of Jekyll](https://jekyllrb.com/docs/drafts/) to prevent publishing of *very* early notes that are just ideas or not even readable... Those can still be viewed in GitHub sources, but are not publicly rendered (I have a special <span class="post-header"><span class="post-meta"><span class="maturity-label maturity-unpublished">unpublished</span></span></span> label for myself).


## Migrating paths

Beside changing the concept, I'm also changing the platform, moving from self-hosted Drupal to Jekyll on GitHub Pages.

During this migration I've tried to keep the old URLs still valid by keeping a way to make it through *HTTP redirects*. Mostly for fun.

- Assets (images) are moved to `/assets/blog/...` and specified as is in the markdown sources. I could have used Jekyll's features to insert some variable but I did not want to add too much non-markdown (and framework-specific) code in the articles' source. If the assets were to move again, it should be quite easy to replace all `/assets/blog/...` strings with the correct path.
- I've used Jekyll's `permalink` option to keep the short URL of the articles so I just have to add an *HTTP redirect* to serve the new blog under the old URLs.

There is a screenshot of what the previous blog at [nicobo.net](http://nicobo.net) was looking like : [screenshot](/assets/blog/screenshots/nicobo.net-screenshot-2019-10-26%2020-00-21.png).

## What's lost

From rich HTML to Markdown, I've lost some of the visual/semantic styles I was using : I had to merge or get rid of some of them.

Actually I must say that this does not really look like a bad thing : they were not *critical* to the meaning of the text and it's easier to concentrate on the content itself.

- Lack of underlining in Markdown : I've used *normal* (\*) or **strong** (\*\*) emphasis
- `file names` and `commands` used to have separate styles : although I miss this one a bit, I am now enclosing both of them in back ticks (\`) and saving some seconds thinking about which style to use here.
- I used to have 2 types of block quotes : *notes* and *warnings*. I am now using markdown quotes (>) for both, emphasizing important words for *warnings* types
- Pictures and text layout is now only a vertical flow : I don't really care as it's always been for pure visual left/right/center alignment and I used to spend a significant time building it.
- Most of the visual helps I used to render with CSS are now back as indications in the text. E.g. I could emphasize portions of code to make the reader focus on them ; now I just describe them right before/after the code
- I was using a *main tag* as a category : android, java, ... Although [jekyll supports categories](https://jekyllrb.com/docs/posts/#categories-and-tags), I'm now using only one level of tags for the better : all tags are equals !
- No custom excerpt and picture to advertise an article in the front page (lately I've noticed [Jekyll has this kind of feature](https://jekyllrb.com/docs/posts/#post-excerpts) but for now there is a short excerpt automatically extracted from the first paragraph)
- No integrated internationalization (*i18n*) but I have only few articles in french, all others are in English, and I feel it's not going to be a lot of work to add this feature

## What I like

- Simplicity : the default theme, the generation mechanism, the Markdown language, everything is turned towards simplicity, allowing to concentrate on content.
- This is really close to the ideal blogging platform I was looking for my 'work in progress' blog concept (i.e. even drafts are published and articles are always evolving)
- Integrates very well with Atom and its *git* & *markdown preview* plugins
- Last but not least, it is a very portable platform, since it's just offline generation of HTML files and upload. GitHub automates the build so I don't really upload generated files but to go over some limitations they put on *GitHub Pages* I may simply change hosting and then really push offline-generated content. That's [KISS](https://en.wikipedia.org/wiki/KISS_principle). Also static site generation not limited to Jekyll, [there are other](https://blog.jim-nielsen.com/2018/choosing-a-static-site-generator/) [very promising](https://github.com/myles/awesome-static-generators#photography) engines, even distributed ones...

## What I don't like

- On GitHub Pages there is *only one* theme, *only one* markdown engine : GitHub surely needs to rationalize services it provides but on my side I hope it will not lead to dead ends and migration to another host...
- No *autolink* feature for `kramdown`, the only supported markdown engine on GitHub Pages, which would have saved me from rewriting all links that had just their own URL as text. By the way I therefore rewrote the links' text trimming the redundant "http://" or "www" parts, making the text more readable. For the record, I was able to do this with this single *regular expression* : `s/(https?:\/\/)(www\.)?([^\s$]+)/[$3]($1$2$3)/g`
