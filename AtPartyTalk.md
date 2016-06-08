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
of rather vanilla object-oriented code.

May 2015 experiments: bipartite graph of data nodes and transform nodes.
Also controllers associated with transform nodes.

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
We used the "slightly noisy propagators"i as neurons. They simply 
copy the input to the output most of the time, 
but occasionally output zero instead.

These are August 2015 experiments and this preprint can
serve as documentation to these exprements: http://arxiv.org/abs/1601.01050

---

Then we started to pay attention to the fact that our August 2015 dataflow
architecture is a generalization of recurrent neural networks (RNNs),
and in particular, the continuous cellular automata of our August 2015
are just RNNs with slightly unusual neurons.

<strong>RNNs are awesome</strong>

I especially recomment this post by Andrej Karpathy,
"The Unreasonable Effectiveness of Recurrent Neural Networks":

http://karpathy.github.io/2015/05/21/rnn-effectiveness/

(See in particular generated "math texts", and generated
"Linux kernel code snippets".)

This is also a good example of how the discrete data, in this
case, sequences of characters, can be represented in
a continuous framework. In this particular case, one takes
an alphabet, and takes as many dimensions as there are letters
in the alphabet, and a character is represented by a vector
having 1 in the coordinate correponding to this character,
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


Many other useful and elegant systems nevertheless belong to
this class when one starts thinking about their qualities
as a general-purpose language.

But if one considers a suffiently strong generalization of
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

People are not really using this, mostly because of this "Turing tarpit"
property (in particular, very awkward encodings leading to high sensitivity
of behavior to
small changes of parameters). But we hope that the construction in
the sections 1.4 and 3.3 of the preprint will make it usable.

<strong>to be continued: adding materials to this page</strong>

---
---
---

Back to the topic of the talk.

<strong>It is easy to do your own dataflow experiments!</strong>

It tends to be just a few hundred lines of code in any conventional
software framework of your choice, as long as it is expressive enough
to program cellular automata. (Shadertoy, alas, is not expressive
enough to conveniently program cellular automata, so not Shadertoy :-) )

You'll have full control and you will be able to try your own
dataflow ideas this way!

