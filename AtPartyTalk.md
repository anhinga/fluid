Supplementary materials for the talk at @party
==============================================

A talk by Mishka, <strong>"Make your own dataflow"</strong>,
Jun 4, 2016, http://atparty.untergrund.net/

Based on joint work of the Project Fluid community.

---

Dataflow program: a graph. Streams of data propagate
along the edges of the graph and are transformed
at the nodes of the graph.

---

A natural architecture for digital signal processing,
such as audio streams and streams of images (animations).

Neural nets are dataflow.

---

A lot of dataflow programming frameworks out there.

People are saying good things about TouchDesigner,
which is a proprietary system:

https://en.wikipedia.org/wiki/Houdini_%28software%29#TouchDesigner

http://www.derivative.ca/

--

Pure Data (open source rewrite of Max, cf. Max/MSP)


https://en.wikipedia.org/wiki/Pure_Data


http://puredata.info/


This book is based on Pure Data:
https://mitpress.mit.edu/books/designing-sound


But the code in this directory was 70000 lines the last time I checked:
https://sourceforge.net/p/pure-data/pure-data/ci/master/tree/src/ 


---

We have implemented 3 very different dataflow architectures in
Project Fluid. In each case, it only took hundreds of lines
of rather vanilla object-oriented code. (We used Processing,
but almost any language would do equally well.)

May 2015 experiments: bipartite graph of data nodes and transform nodes.
Also controllers associated with transform nodes.

Working with streams of images (that is, with animations), 
and with built-in 
transforms of the streams of images: 
a "wave transform" (reflection of an animation
in moving "synthetic water waves"), a "negation transform" (color inversion
of an animation),
and a convex linear combination of two animations.

Jun 2015 experiments: the dataflow program changing in an almost
continuous fashion while it is running; reflection facilities,
allowing to depict program as it is changing; linear splicing:

slides 39, 40 of http://www.cs.brandeis.edu/~bukatin/LinearModelsNeplsNov2015.pdf
(linked from http://www.cs.brandeis.edu/~bukatin/partial_inconsistency.html )


A common preprint for May and Jun 2015 experiments, to serve as documentation: http://arxiv.org/abs/1601.00713

--

August 2015 experiments: bipartite graphs again, but this time of
linear transformations (associated with "neuron inputs") and
non-linear transformations (built-in transformations associated with "neurons").

Countable connectivity matrices with finite number of non-zero
elements, strings as indices instead of numbers (for readability),

Under this approach, after you fix the types of available neurons,
the programs are defined by their matrices; so one can continuously
transform a program while it is running, and one can synthesize
a program by synthesizing its matrix.

We implemented some continuous cellular automata in this architecture
and observed some nice visual effects with emerging Turing structures.
We used the "slightly noisy propagators" as neurons. They simply 
copy the input to the output most of the time, 
but occasionally output zero instead.

These are August 2015 experiments and this preprint can
serve as documentation to these experiments: http://arxiv.org/abs/1601.01050

---

Then we started to pay attention to the fact that our August 2015 dataflow
architecture is a generalization of recurrent neural networks (RNNs),
and in particular, the continuous cellular automata of our August 2015
are just RNNs with slightly unusual neurons.

<strong>RNNs are awesome</strong>

I especially recommend this post by Andrej Karpathy,
"The Unreasonable Effectiveness of Recurrent Neural Networks":

http://karpathy.github.io/2015/05/21/rnn-effectiveness/

(See in particular generated "math texts", and generated
"Linux kernel code snippets".)

This is also a good example of how the discrete data, in this
case, sequences of characters, can be represented in
a continuous framework. In this particular case, one takes
an alphabet, and takes as many dimensions as there are letters
in the alphabet, and a character is represented by a vector
having 1 in the coordinate corresponding to this character,
and zeros in other coordinates, and then general vectors
in this space have an interpretation as distributions over characters.

In general, one can convert any discrete set to the continuous
framework by considering the space of probability distributions
over that discrete set, and then by considering streams of samples
from those distributions (see section 1.2 of http://arxiv.org/abs/1605.05296 ).

---

<strong>Dataflow matrix machines</strong>

Preprint: http://arxiv.org/abs/1605.05296

RNNs are awesome, and they are Turing-complete, but they are
not a good general-purpose programming language. Instead, they
belong to the class of esoteric programming languages and
Turing tarpits:

https://en.wikipedia.org/wiki/Esoteric_programming_language

https://en.wikipedia.org/wiki/Turing_tarpit


Many other useful and elegant systems (e.g. Game of Life,
LaTeX, the language of C++ templates) nevertheless belong to
this class of esoteric programming languages and Turing tarpits
when one starts thinking about their qualities
as potential general-purpose languages.

But if one considers a sufficiently strong generalization of
RNNs, then one gets a system which can likely be used as a 
convenient general-purpose programming language, while
retaining the key property of RNNs:
parametrization of large classes of programs by matrices.

Dataflow matrix machines generalize RNNs in three different ways.

1) Allow us to have not just streams of real numbers, 
but arbitrary "linear streams" 
(streams for which a notion of linear combination
of several streams is reasonably well defined).

2) Allow us to have 
neurons accumulating not just one linear combination at the input, 
but several different linear combinations, possibly
of different types of "linear streams", 
and allow freedom to equip the neurons with interesting 
built-in transformations of
linear streams. 
(It is also convenient to allow a neuron to have multiple output streams as well.)

3) In particular, allow linear streams which are streams of matrices parametrizing neural nets, and equip neural nets with reflection facilities
allowing the net to modify its own matrix 
(the matrix which controls the behavior of the net in question;
see sections 1.4 and 3.3 of the http://arxiv.org/abs/1605.05296 preprint).

Here the 3), that is the <strong>reflection facilities</strong>, is
the most crazy. The basic idea of that goes some decades back:

http://www.scholarpedia.org/article/Metalearning#Neural_metalearners_that_learn_learning_algorithms

People are not really using this ability of RNNs to modify their
own matrices for a number of reasons
(e.g. paper [J. Schmidhuber, <em>A `self-referential' weight matrix</em>, 1993]
seems to use very awkward encodings leading to high sensitivity
of behavior of the net in question to
small changes of parameters; 
see section 2.1 of the preprint for further discussion). 

But we hope that the construction in
sections 1.4 and 3.3 of the preprint would work better and will make this
self-modification facility usable in practice.

--

Jun 4, 2016 experiment. 

The preprint http://arxiv.org/abs/1605.05296 suggests several promising
programming techniques. One of these techniques is the use of multiplicative
masks (use of the neuron's inputs as a multiplicative coefficient
in the built-in transformation associated with this neuron).

Multiplicative masks are great for various orchestration needs and redirection
of flows of data in the network, because multiplication by zero is a great
way to encode turning a part of the network off. So one can use
multiplicative masks to implement conditionals. If one has a layered
structure, and one does not want the layers to fire all at once,
but one wants them to fire one after another instead, multiplicative
masks are a great way to achieve that.

The Jun 4 experiment is a light variation of Aug 2015 experiments which
introduces multiplicative masks, and which also introduces neurons
implementing trigonometric transforms for a rather spectacular series of
self-organizing visual effects...

--

Another construction suggested in the preprint http://arxiv.org/abs/1605.05296 
is nested patterns.

Basically, we know how to create a deep copy of a subgraph while
preserving its incoming (and, optionally, outgoing) external
connections. One can apply this construction repeatedly to
create a pattern. And one can apply this construction in a nested
way to create fairly intricate patterns. And one can allow the
network itself to control triggering such deep copy operations
and creating intricate patterns via this mechanism.

With some luck we might be able to release an experiment demonstrating
this facility sometime soon.


---
---
---

Back to the topic of the talk.

<strong>It is easy to do your own dataflow experiments!</strong>

It tends to be just a few hundred lines of code in any conventional
software framework of your choice, as long as it is expressive enough
to program cellular automata. (Shadertoy, alas, is not expressive
enough to conveniently program cellular automata, so not Shadertoy :-)
<strong>July 17 remark:</strong> Actually, with the new multipass
feature cellular automata (and recurrent neural nets) seem to
be possible in Shadertoy.)

You'll have full control and you will be able to try your own
dataflow ideas this way. (On the other hand, if you
use a specialized dataflow framework made by someone else instead,
then you will most likely not have full control, and it might be problematic
to try some of your own dataflow ideas).

