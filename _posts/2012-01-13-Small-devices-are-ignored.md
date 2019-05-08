---
title: Small devices are ignored
date: 2012-01-13 13:01:58 +0100
layout: post
permalink: articles/small-devices-are-ignored
tags:
  - android
---

This has been annoying me since the beginning : small screen devices are not taken into account by the vast majority of apps editors.

Worse : despite Google's pleading about size-caring (see [developer.android.com/design](http://developer.android.com/design)), they recommend patterns that actually don't fit the real small screens for which size-caring IS important.
Example : the "[action bar](http://developer.android.com/design/patterns/actionbar.html)" and other icon bars : there is no place for such bars on small screens...

Of course the developer is able to adapt the GUI depending on the size of the screen, but if Google does not make it clear then I fear the battle is already lost...



Here are screenshots of Android Market and Google Reader on an [Xperia Mini](http://www.gsmarena.com/sony_ericsson_xperia_mini-3947.php) (HVGA 320x480, 88mm long) :

![Android Market on Xperia Mini](/assets/blog/device-2012-01-13-112203.png)

On this screenshot : buttons zones are not clearly defined and the zoom button is too small, making it difficult to finger-tap them on small screen. Furthermore, one can only see 2 applications from the list (there was a screenful of it in the previous version)...

![Google Reader on Xperia Mini](/assets/blog/device-2012-01-13-112359.png)

On this screenshot : the user is swiping by mistake to the next article because the content is too large for the screen... Ooops too late ! If you swipe back to the previous article you'll have to scroll down again to where you were (this happens to me all the time...).

>

Another damage of device fragmentation...


## Related links

- [Android Dev Guide : "Supporting Multiple Screens"](http://developer.android.com/guide/practices/screens_support.html)
- [Android design site (many informations about size in different places of this site)](http://developer.android.com/design)
- [Screen Sizes and Densities](http://developer.android.com/resources/dashboard/screens.html)
