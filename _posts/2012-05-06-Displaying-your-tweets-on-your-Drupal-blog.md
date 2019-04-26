---
layout: post
date: 2012-05-06 17:22:47 +0100
title: Displaying your tweets on your Drupal blog
permalink: articles/displaying-your-tweets-your-drupal-blog
tags:
  - drupal
  - oauth
  - twitter
---
## Twitter module for Drupal

If you want to display your latest tweets on your Drupal blog, you will probably want to use the dedicated [Twitter module](http://drupal.org/project/twitter). Among other features, this module provides a new block type that lists a selection of tweets from an account. Tweets are retrieved via a cron job and stored in your website's database, making them available even through corporate firewalls that banish twitter.com. Just-what-you-need !

There are a few catches however : it will likely not work if you are on a shared host because [Twitter puts rate limits](https://dev.twitter.com/docs/rate-limiting) to the usage of their API, and there is a bug in the block view that can be circumvented.

Here are the important steps to configure the module for our needs :

1. Install **Twitter** module and some dependencies : **OAuth**, **Autoload**, **Views**
2. Activate the modules *Twitter*, *OAuth*, *Autoload*, *Views* and *Views UI* (the other Twitter modules '*actions*', '*post*' and '*signin*' are not required for our purpose)
3. Setup the Twitter module as described [in the documentation](http://drupal.org/node/1226204) : you will need to register your application and fill in OAuth consumer secret and key
4. Associate a Twitter account with your user (this is also described [in the documentation](http://drupal.org/node/1253026)). This creates a line in the `twitter_account` table and is mandatory for OAuth requests.
5. Start cron to retrieve your tweets. If this step gives you a "rate limit exceeded" message, welcome to the club : go ahead and read the next chapter.
6. Lastly, create the block view that you will include in your layout. You don't need to follow the documentation : simply clone the twitter view as you wish and [remove the user:uid filter to make it work](http://drupal.org/node/1253026#comment-5917528) (looks like a bug). Change the "Admin" field to help you distinguish it from the default twitter block.


### Use Twitter API on localhost

If you want to register your local site (from your local computer), you can use `http://127.0.0.1/twitter/oauth` as the callback URL in step 3.

And if your test site does not respond to `127.0.0.1` (but for instance to `mysite.localhost`), the callback will fail, but you will still get the URL with the right query parameters (e.g. `http://127.0.0.1/twitter/oauth?oauth_token=LbcMx...LcR3d&oauth_verifier=trdf5...aaOjQ`) in step 4 : you can then simply change the host in the URL and try it a second time !

## Patching for use on a shared host

In order to fetch twitter statuses (your tweets), the Twitter module makes unauthenticated calls to the API by default, and therefore is subject to a **[rate limit of 150 requests per hour](https://dev.twitter.com/docs/rate-limiting#rest) measured against the IP address** of the server making the request.

On shared hosts many sites use the same front IP address and thus the rate limit is reached every hour. In short, the sites trying to use this feature make it impossible to use for any host on the same shared host...!

Twitter's API allows for more requests if you use authenticated calls : up to 350 requests per hour **measured against a token that's unique to your Twitter account**. This is largely enough for our needs as it does not rely on the IP address.

### First option : set a field in the database

To choose whether or not using an authenticated call, the module will look at some point for the value of the field named "protected" attached to the user in Drupal's database (`twitter_account` table). If this field has value that converts to `TRUE` in PHP, tweets will be retrieved through authentified calls.

You can [set the field value to 1](http://drupal.org/node/1358308#comment-5644266) with your preferred database query tool.

However, setting this field to `TRUE` also allows other users to create tweets on behalf of this account. Furthermore, it may be set back to 0 by some parts of the module we don't control.

### Second option : patch a line of code

Looking at the code, it looked to me more adequate to patch the code of the module.

Simply look for the file named `twitter.inc` in the module's files, and replace the use of ``$account->protected` with `twitter_use_oauth()`` in the ``$twitter->user_timeline(...)`` call of the `twitter_fetch_user_timeline` function.

There is only one line to change :

```php
<?php
...
function twitter_fetch_user_timeline($id) {
...
//  $statuses = $twitter->user_timeline($account->id, $params, $account->protected);
  $statuses = $twitter->user_timeline($account->id, $params, _twitter_use_oauth());
...
?>
```

And here we go : a nice Twitter timeline fetched and displayed on a shared host !

![Sample site tweets block](/assets/blog/sites_tweets.png)


## References

- Twitter's API rate limiting rules : [dev.twitter.com/docs/rate-limiting](https://dev.twitter.com/docs/rate-limiting)
- Twitter module for Drupal : [drupal.org/project/twitter](http://drupal.org/project/twitter) (there is a link to full documentation on the side menu)
- Drupal : "Rate limit exceeded" : [drupal.org/node/456102](http://drupal.org/node/456102)
