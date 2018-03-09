Materials for Mishka's lightning talk on music synthesis in Clojure
===================================================================

I recently found a system for music synthesis **Pink**
written in Clojure by Steven Yi. This is the set of notes for
my March 8, 2018 lightning talk at Boston Clojure meetup.

Almost all music synthesis systems are based on the notion
of **unit generator** invented by Max Matthews in 1957.
A monophonic sound is described by real function *x(t)*,
which is a dependency of the value of air pressure from time.
It is enough to sample with sufficiently high frequency
(44,100 samples per second is what is typically used), so
we are talking about a stream of real numbers. (With stereo
or multiple speakers we are talking about several streams 
of numbers or a stream of tuples.)

Unit generator is a transformer of such streams, it takes
zero, one, or several such streams as inputs and produces
one (or more) such streams as outputs.

Example: *sin(a * x + b)* takes streams *a(t)*, *b(t)*,
and *x(t)* as inputs and produces a stream
*y(t) = sin(a(t) * x(t) + b(t)* as the output.

One does music synthesis by composing unit generators
(usually one builds directed acyclic graphs from them,
although recurrencies can be considered).

The most popular system for music synthesis in Clojure
is Overtone, which wraps a famous Supercollider engine
written in C++. However, there are some pragmatic and
fundamental problems with this setup. Pragmatically,
it can difficult to make Overtone work (depending on your
operating system). Fundamentally, composing transformations
of streams of numbers is one of the quintessential examples
of functional programming; so it feels quite wrong when
an engine doing this is hidden inside C++ code and not
exposed to us in Clojure where it would be easy to understand
and modify if desired.

Hence, an engine written purely in a functional language like
Clojure is attractive. These notes are structured in 3 parts:

  * materials, directly related to Steven Yi's system for
    music synthesis;
  * general materals related to unit generators and their
    composition;
  * remarks.
