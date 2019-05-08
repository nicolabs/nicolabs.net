---
date: 2012-01-05 12:45:56 +0100
tags:
    - android
---

> The purpose of this article is how to reuse the existing Preferences classes to build an enhanced Preferences view.



Reuse Preference and add header and footer without the new API (so it can run on 1.5) :

simply add the elements to the layout and put a @id/android:list somewhere in the layout



Problem : it does not work if the view is bigger than the screen because it does not scroll.

If put inside a ScrollView, it does not work either because it is not possible to put a ListView inside a ScrollView (link).



1st attempt : use a LinearLayout and directlry put new ChecBoxPreference.getView() and ListPreference.getView() inside.

Problem : displayed ok, scrolls ok but no reaction to clicks.



There IS a (dirty) solution :

`<ListView android:id="@id/android:list" android:layout_marginTop="10dp" android:visibility="visible" android:layout_width="fill_parent" `**`android:layout_height="200px"`**` />`

[www.kaloer.com/android-preferences](http://www.kaloer.com/android-preferences)
