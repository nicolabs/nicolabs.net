---
layout: post
date: 2015-03-28 17:18:57 +0100
modified: 2019-04-26
title: Sass is a CSS compiler
tags:
  - css
  - graphism
  - media queries
  - sass
  - web design
---
![Sass logo](/assets/blog/sass-color-1c4aab2b.png)

A year ago I was very excited to get my hands at _Sass_.

I thought it could fill the gaps in coding with CSS : preventing variables duplications, automatic generation of multiple static stylesheets depending on the rendering device (vs using media queries which are not always supported and require downloading all versions of the code)...

But it could not.

## What really is Saas

[Sass-lang.com](http://sass-lang.com/) states it is a "CSS extension language", but don't take it literaly or you will head straight for failure.

That would imply that Sass adds instructions to the CSS language ; however it's not right because web browsers today only understand CSS, not Sass.

Sass is nothing but dynamic : it's a pre-processor that may only really be used to offline-produce different versions of a CSS with different sizes, colors and layouts, but it's not able to make your CSS dynamic. It's just several static versions of CSS that you must still dynamically/selectively load using an external mechanism (like static media queries or Javascript).

I fell into this trap as I tried to organize stylesheets with inheritance like in **o**bject **o**riented languages (_OO_) : this structure would always failed at a given point.

For instance : as variables only live in the Sass context, and disappear in the compiled CSS, if you want to make two versions of a stylesheet with different values of the same variable, you only have one option : build a CSS block or stylesheet for each value. There is no added value using Sass variables in media queries because they will just be replaced with their static, final value.

## Conclusion

Make no mistake : Sass is a very helpful evolution for CSS, **use it**, but **know its limits** !

## References

- [designshack.net/articles/css/sass-and-media-queries-what-you-can-and-cant-do](http://designshack.net/articles/css/sass-and-media-queries-what-you-can-and-cant-do/)
- [thesassway.com/intermediate/responsive-web-design-part-2](http://www.thesassway.com/intermediate/responsive-web-design-part-2)
