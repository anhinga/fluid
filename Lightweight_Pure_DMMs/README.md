Experiments in lightweight pure dataflow matrix machines
========================================================

Dataflow matrix machines (DMMs) are described in recent
preprints linked from the main page.

They are similar to recurrent neural networks but they
work with arbitrary linear streams, and not just
streams of numbers.

In particular, streams of matrices defining DMMs are
a particularly important kind of linear streams
which allows for self-referential facilities and
self-modification of the network.

Pure DMMs are the DMMs where the only kind of
streams which is allowed are the streams of
matrices defining the DMMs. Everything else
should be encoded via those matrices.

Pure DMMs play the role of untyped lambda-calculus
in this context.

The theory prescribes using countable-sized sparse
matrices with finite number of non-zero elements,
with rows and columns indexed by strings.

To simplify the experiments we introduce the notion
of Lightweight Pure DMMs, where we fix a network
of finite size, the matrices defining the network
are finite and plain (non-sparse), and the rows and
columns are indexed by numbers, rather than by strings.

This directory is for small experiments with
Lightweight Pure DMMs.

