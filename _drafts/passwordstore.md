Alternative to the well known keepass.

Surprisingly has been there for quite a time and has many integrations.
For Dev/ops : ansible, GitHub, ...

Works very well across several different devices.
Still git to check with iOS.

Very clean, portable, fast.

Command line yet experience is at the top (which keepass does not permit).

Firefox extension works (other browser extensions not tested), although :
- it requires installing a host application / an agent on the local machine (can be a problem on computers where you're not an admin, even though it might not be a use case for people really concerned about privacy). It does not work on Firefox for Android for instance.
- matching URLs logic is not self explanatory (must read the docs) and even seems too permissive (might input password in wrong sites ?). Checking the 'Index URL fields on startup' box saved me.
- fields names are not the same as the ones advertised in pass docs so you may not get login fields filled up before reading carefully passff docs. It's mainly a concern with pass great flexibility, which gives no standard not convention for fields names.

As seen with ff, extensions and plugins don't have a standard or common conventions for fields names. Or are there conventions (check with each plugins) ?

Android application works well for native apps but not for Firefox ! Only with chrome (although I couldn't make it work either).
It still works by copy/pasting and, in the end, is not worse than keepass xc popping up a special keyboard 3-4 times because it must be unlocked and switched on/off almost every time.
If the directory is not a git repository, triggers errors on each entry modification, but still works (check this point).

OTP feature : to test

From the following articles, bitwarden seems to be a good Challenger :
- https://shivering-isles.com/password-safes-lastpass-vs-bitwarden-vs-keepass-vs-pass
- https://medium.com/@QuantopianCyber/head-to-head-evaluation-of-five-password-managers-8faa4851c767

However :
- it stores passwords in the cloud (do you trust bitwarden to install exactly from the sources they publish ? Do you trust all network & middlewares involved besides the open source components?)
- the server side can be installed (open source) but again it requires maintainance (what if your server goes offline or if it is attacked : would you be able to fix it better and quicker than bitwarden ?)
- it uses "only" AES (symmetric encryption)
