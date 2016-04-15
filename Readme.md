Port Royal
==========

First a disclaimer.  I stink at frontend programming, if you think what I'm doing is wrong, submit a pull request
with how to make it better.  I'm a backend developer by trade, this is the first real web app that I'm writing,
and I haven't used these technologies for anything substantial before. I'm doing this at least 50% to learn.

Overview
--------

So what is this?  Glad you asked!

Port Roayl is intended to solve a, possibly unique, problem I have with my media library.  I have a server that I pay a
hosting provider for that runs [Plex Media Server](https://plex.tv) and I use that to serve all of my media.  It has
limited storage (about 2 TB) and when that runs out, I need to either delete media or move it somewhere else manually.
My goal is to create a fleet of "cold storage" servers (basically Raspberry PIs hooked up to banks of hard dries) and
then use Port Royal as a kind of distributed media manager.

Current Project Status
----------------------

Still very much in the "playing around" phase, but in case this is even remotely useful to anyone else I thought I would
throw it up on GitHub as I continue to work on it.  Expect development to be slow and come in fits and starts, this is
not my full time job.

Technologies
------------

Scala + Coffeescript

Here's a laundry list of thing's I've been playing with:

* [React](http://facebook.github.io/react/) for the UI
* [Gulp](http://gulpjs.com/) and [Browserify](http://browserify.org/) to build the web frontend
* [Play](https://playframework.com/) for the backend/API

