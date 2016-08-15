Remarks on linear and bilinear neurons in LSTM and gated recurrent units 
========================================================================

(Mishka, August 15, 2016)

The motive of usefulness of linear and bilinear neurons in
recurrent neural networks is rather old.

Neurons with linear activations functions allow to implement
memory among other things. For example, a neuron with the
identity activation function and with its output connected to
its own input with weight one works as an accumulator of all
other contributions from other neurons connected to its input.

Bilinear neurons are also useful for many purposes. 
For example, consider a neuron with two inputs, with each
of those inputs accumulating linear combinations of the
outputs of other neurons, and with activation function being
the product of those two inputs. One frequent use of this
neuron is to consider one of those inputs as the "main input"
and another one as the "modulating input" ("multiplicative mask",
"gate"). 

The presence of these contructions is very convenient and tends
to add to the expressive power of the networks in question.
For example, in 1987 Jordan Pollack found those constructions useful
when researching the neural networks as a computational platform:
http://www.demo.cs.brandeis.edu/papers/neuring.pdf

Recently we were researching dataflow matrix machines
(generalized neural networks) as a computational platform,
and those constructions naturally emerged in our research
as well: http://arxiv.org/abs/1606.09470

Various schemas of recurrent networks with gates and memory
were found to be useful in overcoming the problem of vanishing
gradients in the training of recurrent neural networks,
starting with LSTM in 1997 and now including a variety of other schemas.

For a nice compact overview of LSTM, gated recurrent units,
and related schemas see http://arxiv.org/abs/1603.09420
by a research group from Nanjing University
(an open access journal version is here:
http://link.springer.com/article/10.1007/s11633-016-1006-2 )

One would like to better understand the nature of those schemas,
and in particular, whether the presence of memory and gates
means that LSTM, GRU, and MGU are not pure recurrent neural networks,
but recurrent neural networks augmented with some other constructions.


Looking specifically at formulas in the Table 1 of
http://arxiv.org/abs/1603.09420
one can observe that all those schemas are obtainable via linear
and bilinear neurons. So LSTM, GRU, and MGU networks are
conventional recurrent neural networks using neurons with
linear and bilinear activation functions together with
more traditional types of neurons.
