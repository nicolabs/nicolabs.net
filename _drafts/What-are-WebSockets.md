---
date: 2012-11-28 14:48:21 +0100
layout: post
tags:
  - HTML5
---

Why the need for WebSockets ?

We already have sockets (C programmers know them well), XMLHttpRequest (core of AJAX techniques), Long polling (like comet, ...). So why the need for WebSocket ?

Here is an exerpt from the WebSocket RFC's abstract :

The goal of this technology is to provide a mechanism for browser-based applications that need two-way communication with servers that does not rely on opening multiple HTTP connections (e.g., using XMLHttpRequest or <iframe>s and long polling).

- sockets : you need to listen to a port on the machine : web browsers can't do that

- XMLHttpRequest and Long polling : you need to poll and reopen connections regularly, there is a visible overhead on applications with a lot of clients

Difference # sockets : you need to connect to an end side (you don't just open and wait). This still makes sense as it is hosted in the browser, so the expected usage is to register to a server to make this endpoint known.

However, we could imagine running a server directly from the browser, the only constraint would still be to register to some valid address on the Internet (so the connection does not fail). ???
A tutorial

In this video, XXX demonstrates how much WebSockets can be useful when it's about scalability.

VVV

He also covers passing through proxies and other aspects of WebSockets' ecosystem, which make this presentation a good overview of the topic.

The record's quality is not so good (the sound drops sometimes, the sildes don't stay long enough on screen), so you might as well find another source, maybe of the same author...
Links

    RFC 6455 "The WebSocket Protocol" - http://tools.ietf.org/html/rfc6455
    WebSockets on Wikipedia - http://en.wikipedia.org/wiki/WebSocket
