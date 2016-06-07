Supplementary materials for the talk at @party
==============================================

A talk by Mishka, "Make your own dataflow",
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






