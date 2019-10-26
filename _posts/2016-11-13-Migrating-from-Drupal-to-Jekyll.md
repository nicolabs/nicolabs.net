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
last_modified_at: 2019-10-26
---

![Previous blog's banner background](/assets/blog/nicobo-landscape.png)

## New blog concept ?

I have to admit that I don’t have time to write full articles.

Therefore this blog is going to show more unfinished (and shorter) articles !

I will maybe include some banner saying something like "This article is under perpetual rewriting, take it carefully as it may have changed tomorrow".

I will also have to find some way to show the freshness of the article to indicate if it’s likely to change or not.

That bothers me a bit because I like to refer to a given article or content with a fixed URL. If the content behind this URL changes it may totally break referring sources. But this is the only way I can think of to prevent some articles from staying unknown in draft state forever...

Also, since the source is versionned on GitHub, there's still a way to find or link to an original content.

I currently use the [drafts feature of Jekyll](https://jekyllrb.com/docs/drafts/) until I put a solution in place.

The good news is that some articles that were still in draft state and therefore hidden are going to be live !

## Migrating paths

Beside changing the concept, I'm also changing the platform, moving from self-hosted Drupal to Jekyll on GitHub Pages.

During this migration I've tried to keep the old URLs still valid by keeping a way to make it through *HTTP redirects*. For fun.

- Assets (images) are moved to `/assets/blog/...` and specified as is in the markdown sources. I could have used Jekyll's features to insert some variable but I did not want to add non-markdown code in the articles' source. If the assets were to move again, it should be quite easy to replace all `/assets/blog/...` strings with the correct path.
- I've used Jekyll's `permalink` option to keep the short URL of the articles so I just have to add an *HTTP redirect* to serve the new blog under the old URLs.

There is a screenshot of what the previous blog at [nicobo.net](http://nicobo.net) was looking like : [screenshot](/assets/blog/nicobo.net-screenshot-2019-10-26%2020-00-21.png).

## What's lost

From rich HTML to Markdown, I've lost some of the visual/semantic styles I was using.
I had to merge or get rid of some of them and actually I have to say that this does not really look like a bad thing : they were not *critical* to the meaning of the text and it's easier to concentrate on the content itself.

- Lack of underlining in Markdown : I've used *normal* (\*) or **strong** (\*\*) emphasis
- `file names` and `commands` used to have separate styles : although I miss this one a bit, I am now enclosing both of them in backticks (\`) and saving some seconds thinking about which style to use here.
- I used to have 2 types of block quotes : *notes* and *warnings*. I am now using markdown quotes (>) for both, emphasizing important words for *warnings* types
- Pictures and text layout is now only a vertical flow : I don't really care as it's always been for pure visual left/right/center alignment and I used to spend a significant time on it.
- Most of the visual helps I used to render with CSS are now back as indications in the text. E.g. I could emphasize portions of code to make the reader focus on them ; now I just describe them right before/after the code.
- I was using a *main tag* as a category : android, java, ... I'm now only using tags of the same level.
- No excerpt and picture to advertise an article in the front page.
- No integrated internationalization (*i18n*) but I have only few articles in french, all others are in english, and I feel it's not going a lot of work to add this feature

## What I like

- Simplicity : the default theme, the generation mechanism, the Markdown language, everything is turned towards simplicity without losing style, allowing to concentrate on content.
- This is really close to the ideal blogging platform I was looking for my 'work in progress' blog concept (i.e. even drafts are published and articles are always evolving)
- Integrates very well with Atom and its *git* & *markdown preview* plugins
- Last but not least, it is a very portable platform, since it's just offline generation of HTML files and upload. GitHub automates the build so I don't really upload generated files but to go over some limitations they put on *GitHub Pages* I may simply change hosting and then really push offline-generated content. That's [KISS](https://en.wikipedia.org/wiki/KISS_principle). Also it's not limited to Jekyll, [there are other very promising engines](https://blog.jim-nielsen.com/2018/choosing-a-static-site-generator/), even distributed ones...

## What I don't like

- On GitHub Pages there is *only one* theme, *only one* markdown engine : I understand Github also needs simplicity but I hope it will not lead to dead ends and migration to another host...
- No *autolink* feature for `kramdown`, the only supported markdown engine on GitHub Pages, which would have saved me from rewritting all links that had just their own URL as text. By the way I therefore rewrote the links' text without "http://" or "www" what makes the text more readable. For the record, I was able to do this with this single *regular expression* : `s/(https?:\/\/)(www\.)?([^\s$]+)/[$3]($1$2$3)/g`
