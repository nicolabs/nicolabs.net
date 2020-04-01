---
layout: post
date: 2015-01-29 23:52:38 +0100
permalink: articles/scaffolding-web-20
title: Scaffolding the Web 2.0
tags:
  - ant
  - bower
  - grunt
  - gulp
  - h5bp
  - HTML5
  - initializr
  - java
  - maven
  - npm
  - sass
  - scaffolding
  - web design
  - yeoman
  - yo
maturity: stable
---

## Starting up with Web 2.0 development ?

Let's choose between three essentials tools to begin a new project !

![h5bp](/assets/blog/h5bp.png){:class="inline" height="120px" width="120px"} ![initializr](/assets/blog/html5-logo-165.png){:class="inline" height="120px" width="120px"} ![yeoman](/assets/blog/yeoman.png){:class="inline" height="120px" width="120px"}

## ![H5BP logo (star)](/assets/blog/h5bp-logo.png){:class="inline" style="vertical-align:middle;"} HTML5 Boilerplate

**HTML5 Boilerplate** (a.k.a. _H5BP_) is the original scaffolding tool by Paul Irish & Co (will have to search for the exact history...).

It allows you to build a clean website structure with standard features based on best practices like :

- responsive design-ready CSS
- standard javascript libraries : Modernizr, Respond.js, ...
- 404 page
- Google Analytics
- favicons for apple
- many more...

It does not support CSS preprocessing (SASS, ...) and requires you some effort to upgrade to the latest version later (by separating your work from the original files that will be upgraded)...

It's good for **small** sites.

Find it at [html5boilerplate.com](http://html5boilerplate.com)


## ![Initializr logo](/assets/blog/html5-logo-165.png){:class="inline" style="vertical-align:middle;" height="80px"} Initializr

While _H5BP_ is a static project template to download, **Initializr** allows you to customize it by selecting the features you want on your site and then downloading the generated files.

It has 3 ready-to-use configurations :

- Classic H5BP
- Responsive (using a custom framework by [@verekia](https://github.com/verekia))
- (Twitter) Bootstrap

The customization is made online and on-the-fly : you can see the generated files directly online while filtering the features ("What's inside" button).
It still does not support CSS preprocessing.

Since it's simply a "configurator" over H5BP I find it **more convenient** than H5BP alone **for small sites**.

Find it at [initializr.com](http://www.initializr.com)


## ![Yeoman logo](/assets/blog/yeoman-1.svg){:class="inline" style="vertical-align:middle;" height="80px"} Yeoman

To solve the "static template" issue, _H5BP_ first evolved into "[generator-mobile-boilerplate](https://github.com/h5bp/generator-mobile-boilerplate)", then into several specialized tools now known as "**Yeoman**".

Those tools bring the features you usually want on any project :

- **yo** scaffolds your project (like a _Maven archetype_)
- **Grunt** and **Gulp** build and execute it (like _Maven_ / _Ant_)
- **Bower** and **npm** handle dependencies (like _Maven_ / _Ivy_)

In short, Yeoman is the **standard**, complete tool suite for Web 2.0 developers like Maven is for Java developers.

Find it at [yeoman.io](http://yeoman.io)
