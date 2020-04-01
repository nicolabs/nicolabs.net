---
title: How to organise XML resources
date: 2011-12-16 20:24:21 +0100
permalink: articles/how-organise-xml-resources
layout: post
tags:
    - android
    - XML
maturity: stable
---

> This is a technical article aimed at **Android** developers.
It does not require a lot of background on Android XML resources, but if you don't understand something just check out [the official docs](http://developer.android.com/guide/topics/resources/index.html).

The first time I read Android developer docs, there was something that was unclear to me : **what resource to put in which XML file**.

In this article, I will focus on resources in `res/values/` and give some hints about how to name your XML resource files and what kind of resource to put inside.


## How do XML resources work

With the Android SDK, the resource class `R` is automatically generated as a hierarchy of constants that reflect resources declared by the developer in XML files.

Each constant matches an available resource and can be passed to the API in many places.



Here is what the Android's developers guide says about resources in `res/values/` :

>XML files that contain simple values, such as strings, integers, and colors.
>
>Whereas XML resource files in other `res/` subdirectories define a single resource based on the XML filename, files in the `values/` directory describe multiple resources. For a file in this directory, each child of the `<resources>` element defines a single resource. >For example, a `<string>` element creates an R.string resource and a `<color>` element creates an `R.color` resource.
>
>Because each resource is defined with its own XML element, you can name the file whatever you want and place different resource types in one file. However, for clarity, you might want to place unique resource types in different files. For example, here are some filename conventions for resources you can create in this directory:
>
>- arrays.xml for resource arrays ([typed arrays](http://developer.android.com/guide/topics/resources/more-resources.html#TypedArray)).
>- colors.xml for [color values](http://developer.android.com/guide/topics/resources/more-resources.html#Color)
>- dimens.xml for [dimension values](http://developer.android.com/guide/topics/resources/more-resources.html#Dimension).
>- strings.xml for [string values](http://developer.android.com/guide/topics/resources/string-resource.html).
>- styles.xml for [styles](http://developer.android.com/guide/topics/resources/style-resource.html).
>
>See [String Resources](http://developer.android.com/guide/topics/resources/string-resource.html), [Style Resource](http://developer.android.com/guide/topics/resources/style-resource.html), and [More Resource Types](http://developer.android.com/guide/topics/resources/more-resources.html).



What is important to understand is that a resource accessed through i.e. `R.string.myValue` does **not** have to be declared in a file named `strings.xml`. As stated above, you can name the files in `res/values/` as it fits you.

Any *string*-typed resource named '**myValue**' declared in any XML file under `res/values/` will be found as `R`*`.string`***`.myValue`**.



For example, a value to be accessed as `R.string.app_name` in Java and as `@string/app_name` in XML layouts may be declared in `res/values/static.xml` as :

```xml
<resources>
    <string name="app_name">SwitchDataSwitch</string>
    ...
</resources>
```

## Clearing the way

Not really knowing where I was going, I started out with a single `res/values/strings.xml`, as it is used in many code samples. It put all strings in it.

Things became tricky when I found that I needed both plain strings and arrays of strings to be translated, and also static strings that should not be translated but still present as XML resources.


### Some problems

In my case I had only one or two arrays of strings so it was overwhelming and more confusion to put them in a separate file just because they were of a different type.

Another problem was accessing constant values from both XML layout and Java code. They are constant strings for internal use only, but in order to avoid duplicate declarations I decided to make them available as XML resources. I wanted those resources to be clearly separated from other, 'user visible', resources like GUI labels.

Another thing adding to the fog was the fact that, in derivate files (e.g. `strings-fr.xml` is derivated from `strings.xml`), you only want to find values relevant for the given file.
For instance, if you put all values of type 'string' in the same file but only a part of them should be internationalized, you would have a gap between the original and derivated files not only by the translated values but also by the list of values they declare. When coming back to the project after a long time, you might have a hard time remembering why there is this gap.


### A solution ?

So should I put any type of resources in the same file since they must be translated together ?

Should I leave static strings together with dynamic ones since they have same type (string) ?



After some time developing, I found out that the best solution was to separate the resources by destination (= usage), not by type.

In my case I ended up with the following files :

- `res/values/strings.xml` : contains all text to be translated, whatever the type (having both strings and arrays of strings sounds rational)
- `res/values/strings-[ln].xml` : contains text translated in *[ln]* ; same content as `strings.xml` (although translated)
- `res/values/static.xml` : contains all static constants for internal use that are accessed both from XML layouts and Java code

In the end, this almost matches what's recommended in the developers' guide, apart from the arrays.xml file, which should not exist from the point of view explained here.


### A concrete example

[`ListPreferences`](http://developer.android.com/reference/android/preference/ListPreference.html) is a GUI component that displays a list of values for the user to choose.
As an XML resource, it makes use of two strings arrays : one for the strings to display for each item and the other for their internal values.
Obviously the internal values must not be internationalized, whether the strings displayed to the user have to.

So the definition of the strings would go to `res/values/strings.xml` :

```xml
<string-array name="pref_switchmode_entries">
    <item >Use internal method</item>
    <item >Use DataSwitch application</item>
</string-array>
```

And the definition of the internal values would go to `res/values/static.xml` :

```xml
<string-array name="pref_switchmode_values">
    <item>internal</item>
    <item>dataswitch</item>
</string-array>
```


## References

- [Application Resources @ Android developers](http://developer.android.com/guide/topics/resources/index.html)
