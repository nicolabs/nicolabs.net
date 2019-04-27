---
layout: post
title: "How to cook an egg with a Gimp"
date: 2013-06-15 12:44:22 +0100
permalink: articles/how-cook-egg-gimp
tags:
  - absync
  - gimp
  - graphism
---
![The egg evolves !](/assets/blog/egg-evolution_0.png)

Here is a tutorial to draw an egg with [Gimp](http://www.gimp.org/).

With the following techniques, you will be able to build a realistic egg for a serious business **(!)** as well as a cartoonish one typically for a gamification usage **;-)**

You will find the full Gimp source attached to this article, which I invite you to reuse at will.

> Being a casual user of Gimp, there might be better approaches to get it done.
> For instance, if you're looking for a way to quickly build a textured egg, have a look at this tutorial : [gimptalk.com/index.php?/topic/1659-making-empty-broken-egg-shell-in-gimp](http://www.gimptalk.com/index.php?/topic/1659-making-empty-broken-egg-shell-in-gimp/)

## The shape

The first step is to draw the shape of our egg.

You can do it in different ways :

- Reuse an existing template (this is what I've done for this tutorial : [elledemai.blogspot.fr/2009/03/tutoriel-uf-et-cu-happy-eggs.html](http://elledemai.blogspot.fr/2009/03/tutoriel-uf-et-cu-happy-eggs.html))
- Use a dedicated plug-in (e.g. [gimpchat.com/viewtopic.php?f=9&t=7038](http://www.gimpchat.com/viewtopic.php?f=9&t=7038))
- Use the Ellipse tool in combination with others (not tested)
- Directly use the Sphere designer tool (not tested)
- ...

As all subsequent steps depend on this one, make sur you get the exact shape you want before going on the next chapter. Especially check that the image resolution is high enough.

If you need a high resolution I would suggest you to build your own image from scratch, as the attached Gimp source is quite low-res. You could use the aforementioned plugin for instance.
As an example, for Android application icons, [a 864x864 resolution is recommended](https://developer.android.com/guide/practices/ui_guidelines/icon_design.html#design-tips).

![The egg is taking shape...](/assets/blog/shape.png)

## The volume

The main idea to simulate a volume is to apply a shading (yes : in drawing, everything is impression !).

> This part of the tutorial probably deserves some enhancement because it has the undesired side effect to blacken colors instead of darkening them. The "Sphere designer" tool might be of a great help to solve this issue (see link at the end).

### The edges

To create this volume effect we are first going to select the drawn shapeand apply the _"Light and Shadow > Drop Shadow"_ filter with a null offset (x=0, y=0).
This will make the edges visibly come out of the sheet.

![The egg is MORE that an surface...](/assets/blog/pictures/edges.png)

### The surface

In order to suggest the plumper shape of the egg, we are going to add a new shading, this time made with another technique : we will create a light effect that we will transform into a darkening effect.

In order to do this, select the _"Light and Shadow > Lighting Effects"_ filter and tune the parameters to get the desired effect. The integrated preview of this plug-in is very useful..

For this tutorial I've put the light source right at the center of the egg and tuned the parameters so that the light quickly disappear on its edges.

Once the effect applied, choose menu _"Color > Color to Alpha"_ and select the color of the light (white, usually) : the picture becomes then an alpha layer that will make the volume appear.

![The egg is round...](/assets/blog/pictures/lighting-shadow.png)

## The lighting

In order to give a realistic appearence, we will add a diffuse light with the _"Light and Shadow > Lighting Effects"_ tool.
It is possible to apply several light sources depending on the final scene where the egg will be put. If the egg is white, chose another lighting color.

As a way to suggest a shiny and bright aspect to the shell, we can add a reflect, simply made of a semi-transparent white ellipse.

![The egg is in the place...](/assets/blog/pictures/lighting.png)

## The cartoon effect

Usually we can give a 'cartoon' effect by adding more importance to the lines.

In our case the first thing to do is to increase the width of the edges : that is easilly done with the _"Select > Border"_ tool.

It's also possible to enhance the shadings by tuning the transparency level and increasing colors intensity.

![The egg is drawn...](/assets/blog/pictures/cartoon.png)

When sizing down the picture, don't use antialiasing so you get pixel-perfect edges on a transparent background.

## The texture

One of the reasons why I've built this egg was to be able to build a series of eggs decorated in different ways for different events.

A method to place a texture on the shell is to use the _"Filters > [G'MIC](http://gmic.sourceforge.net/) > Deformations > Fish-eye"_ plug-in.

One can easily get the expected result by applying this filter to the layer where the texture is.
Although it does not distort the picture exactly as an egg, the difference is not noticeable.

![The egg is dressed up...](/assets/blog/pictures/texture.png)

## Reusing

It's over for those tips ; I allow (and encourage) whoever to reuse this picture and to modify it for a personnal or commercial usage.

Take profit of the attached Gimp source and don't hesitate to give me feedback if you're using it : I would be very happy to hear about it !

![The egg is free...](/assets/blog/pictures/egg-real.png) ![The egg is free...](/assets/blog/pictures/egg-cartoon.png)

_Download the source : [egg.xcf](/assets/blog/egg.xcf)_

## References

- Gimp - [gimp.org](http://www.gimp.org/)
- Egg shape plug-in - [gimpchat.com/viewtopic.php?f=9&t=7038](http://www.gimpchat.com/viewtopic.php?f=9&t=7038)
- G'MIC plug-in - [gmic.sourceforge.net](http://gmic.sourceforge.net/)
- Android Icon Design Guidelines - [developer.android.com/guide/practices/ui_guidelines/icon_design.html](https://developer.android.com/guide/practices/ui_guidelines/icon_design.html)
- French tutorials and shape template - [elledemai.blogspot.fr/2009/03/tutoriel-uf-et-cu-happy-eggs.html](http://elledemai.blogspot.fr/2009/03/tutoriel-uf-et-cu-happy-eggs.html)
- Eggs icons - [softicons.com/search?search=egg](http://www.softicons.com/search?search=egg)
- Video tutorial - [youtube.com/watch?v=0c-hMz2XpP8](https://www.youtube.com/watch?v=0c-hMz2XpP8)
- Great tutorial to texturing an egg - [gimptalk.com/index.php?/topic/1659-making-empty-broken-egg-shell-in-gimp](http://www.gimptalk.com/index.php?/topic/1659-making-empty-broken-egg-shell-in-gimp/)
