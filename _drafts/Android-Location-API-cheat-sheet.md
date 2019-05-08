---
title: Android Location API - cheat sheet
date: 2012-08-12 23:57:14 +0100
layout: post
permalink: articles/android-location-api-cheat-sheet
tags:
  - android
---

This article quickly introduces the different mechanisms provided by the **Location API** in Android to be notified of location changes, and when to use them.

There are also many bigger articles on the web to go further with the Location API...


## PendingIntent or LocationListener ?

The main interest of the [Location API](http://developer.android.com/guide/topics/location/index.html) is to be aware of a geographical position and location changes.

To be notified of such changes, the class [`LocationManager`](http://developer.android.com/reference/android/location/LocationManager.html) allows to register to the different [`LocationProvider`](http://developer.android.com/reference/android/location/LocationProvider.html)s on the system, through several variants of the method [`requestLocationUpdates`](http://developer.android.com/reference/android/location/LocationManager.html#requestLocationUpdates%28long,%20float,%20android.location.Criteria,%20android.app.PendingIntent%29).

You will find that you can register two types of listeners :

- [`PendingIntent`](http://developer.android.com/reference/android/app/PendingIntent.html)s : the intent will be called whenever new location data arrives. Since the *Intent* targets a remote component that might not be running, this method will mostly be used if the receiving component is **stateless**. This way it could be terminated it after the work on the data has been done so that it does not remain in memory. An [`IntentService`](http://developer.android.com/reference/android/app/IntentService.html) can be used to implement the receiver since it is designed to terminate as soon as the job is done.
- [`LocationListener`](http://developer.android.com/reference/android/location/LocationListener.html)s : any objet can implement this interface, so this is the most flexible option. This implies that you are able to provide a direct reference to the receiver to the *LocationManager*, and therefore this solution will likely be used if this destination component is **stateful**. The most obvious way for this is to provide an anonymous instance of a `LocationListener`. In the case of a running service, it must not be killed by the system while it is listening to location updates : use [`START_STICKY`](http://developer.android.com/reference/android/app/Service.html#START_STICKY) and [start it in the foreground](http://developer.android.com/guide/components/services.html#Foreground).

Sample code with a PendingIntent

> PendingIntent are kind of globals, so there is no need to pass all options again to retreive an existing PendingIntent when you need to cancel it as a location listener (use NO_CREATE flag)


Sample code with a LocationListener


## A simple LocationListener

The developer docs include some recommandations on strategies to use to cleverly request the location providers.

The following code groups those recommandations into an abstract class that can be subclassed to build simple `LocationListener`s.


## References

- Introduction to the Location API - [developer.android.com/guide/topics/location/index.html](http://developer.android.com/guide/topics/location/index.html)
- A Deep Dive Into Location by Reto Meier - [android-developers.blogspot.fr/2011/06/deep-dive-into-location.html](http://android-developers.blogspot.fr/2011/06/deep-dive-into-location.html)

---

LocationListener or PendingIntent ?

stateless => use a PendingIntent so the service will only be run when a location is received, and terminated after treatment. An IntentService can be used.

Note PendingIntent are globals, so there is no need to pass all options again to retreive an existing PendingIntent (use NO_CREATE flag)

stateful => implement LocationListener.
