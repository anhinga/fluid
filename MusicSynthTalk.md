Notes for Mishka's lightning talk on music synthesis in Clojure
===============================================================

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

## Steven Yi (kunstmusik on github)

https://github.com/kunstmusik

Repositories you want in connection with this are

  * pink - the synthesis library itself
  * score - library for generating music scores
  * music-examples - using these two libraries
  
Actively maintained: https://github.com/kunstmusik/pink/releases

Used by the author on the regular basis to make music.

Clojure/conj talk in 2014: https://www.youtube.com/watch?v=wDcN7yoZ6tQ

Useful materials on architecture of Pink, on unit generators, etc:
http://kunstmusik.github.io/pink/

**Useful examples:**

https://github.com/kunstmusik/music-examples/tree/master/src/music_examples

The one I demonstrated:

https://github.com/kunstmusik/music-examples/blob/master/src/music_examples/track1.clj

One needs to execute some commented out lines at the end of it to make it work;
I uncommented `(start-engine)` and `(play-from 0)`.

If one wants to stop the sound (because it plays too long or indefinitely),
one needs to evaluate `(stop-engine)`. (Don't just kill your Clojure program,
this would only result in losing handle needed to conveniently stop the sound.)

Some other examples might need updating to run with the current version of **pink**.

For example, if one wants to use a midi keyboard and wants to try

https://github.com/kunstmusik/music-examples/blob/master/src/music_examples/example2_basic.clj

it looks like `(create-midi-manager)` is gone, you would probably want to use something
like `(create-manager)` from this file (I have not tried it myself):

https://github.com/kunstmusik/pink/blob/master/src/main/pink/io/midi.clj

## Composition of unit generators for music synthesis and for other purposes

The resource I mentioned during the talk is one of the design notes in our
**Dataflow matrix machines** project. This design note is written in Sep-Oct 2017
and contains references to the original 1963 paper by Max Matthews,
"The digital computer as a musical instrument", and to a very nice tutorial
on music synthesis, "Sonifying Processing: The Beads Tutorial" by Evan Merz
(free PDFs):

https://github.com/jsa-aerial/DMM/blob/master/design-notes/Late-2017/following-audio-synthesis.md

This design note also mentions that the compositions of unit generators
are essentially neural nets, especially if one connects them via "gain units"
(that is, via weights).

Of course, there is a variety of ways to express composition of unit generators
syntactically. People do it in all kinds of ways, including functional programming,
object-oriented programming, and more, and even languages which allow to visually
edit the dataflow graphs, such as Max/MSP and Pure Data, e.g.
https://en.wikipedia.org/wiki/Pure_Data#Code_examples

Old fashioned visual synthesis with analog video synthesizers and oscilloscopes
should also be viewed as synthesis via a composition of unit generators. Our recent
exercise in that direction was to take a frequency modulation audio synthesis example 
from the "Sonifying Processing" tutorial and extend it into a visual domain, so that
frequency modulation is in sync both visually and in sound:

https://github.com/anhinga/fluid/tree/master/beads-library

This is in Processing, but I hope that this is easily convertable to Clojure.

## Remarks

It was surprisingly difficult to find the Pink library. I was trying to find
something like that by asking a number of people and by various Google searches
for a few months, and I just found it accidently a week ago via this search:

https://www.google.com/search?q=clojure+graphics+signal+processing

(What I was looking for at that moment was the

https://clojure2d.github.io/clojure2d/docs/articles/signalprocessing.html

essay.)

**Update on dataflow matrix machines since our July 2017 lightning talk**

Neural networks process streams of numbers. One can use the same formalism
to process streams of images, streams of vectors, streams of probabilistic
samples, and any kind of streams for which an operation of taking
a linear combination of several streams is well-defined.

It is particularly convenient to use streams of vector-like values based
on nested dictionaries (**V-values**). The resulting generalization of
neural network is sufficiently powerful to write programs in it. At the
same time these programs can be deformed in a continuous manner, 
just like one can deform neural nets by gradually changing connectivity
weights.

We call the resulting formalism **dataflow matrix machines**.

Dataflow matrix machines (**DMMs**) are self-referential: one can dedicate a neuron
(usually called `Self`) to accumulate the matrix expressing network connectivity
and weights, and to take additive updates to this matrix from other neurons in
the network.

Dataflow matrix machines were presented during our lightning talk in July 2017:

https://www.meetup.com/Boston-Clojure-Group/events/240535773/

Since then the following modest progress was achieved:

A simple DMM accumulating the list of mouse clicks was built in order to demonstrate
that simple programming tasks which tend to be quite difficult to implement in
conventional neural networks are often easy to implement in this formalism
(July 13, 2017 experiment here:
https://github.com/jsa-aerial/DMM/tree/master/examples/dmm/quil-controlled
)

A full-size reference paper, *Dataflow Matrix Machines and V-values: 
a Bridge between Programs and Neural Nets*, was published (Dec 2017):
https://arxiv.org/abs/1712.07447

A 15-min talk with the same title was made available (Dec 2017):
https://youtu.be/X6GCohQ-LHM

More recently **we used the self-referential capabilities of the network
to edit the running network on the fly**: one sends a request for update
to one of the update neurons which produces an additive update for
`Self` to absorb (January 25, 2018 experiment here:
https://github.com/jsa-aerial/DMM/tree/master/examples/dmm/quil-controlled/interactive
)

We need to do more to start unlocking the potential of this
formalism for innovative schemas of computation and learning.

I think that, first of all, we need to build a more powerful and convenient
interface and primitives for updating the running network on the fly
in the spirit of our January 25, 2018 experiment in order to enable **comfortable livecoding**.

This would allow us to reduce the cost of doing various experiments
in this formalism.

I hope more people will join us in experimenting with this framework
(either in collaboration with us, or on their own)...
