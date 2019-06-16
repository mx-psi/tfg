# Conclusions and further work

In this document I have developed an overview of quantum computation and quantum computing models,
giving both the complexity theoretical perspective as well as a more applied one, by describing and implementing several key quantum algorithms.

The study of quantum computers and their properties is relatively young as a mathematical and computer science subject, yet it has seen several important sucesses.
Quantum computers are a promising technology that has the potential to be a key tool in the resolution of several practical engineering problems.
Algorithms such as Shor's algorithm are a resounding success, since they provide a practical polynomial-time algorithm for a problem that lacks such an algorithm classically, even heuristically.

Its theoretical description can also be celebrated, as it provides a succint description of this model that easily generalizes the probabilistic model.

Nonetheless, the study of this technology remains mostly theoretical, due to the difficulty of its physical implementation and the limits of quantum simulation in classical computers.

Several relevant questions were not addressed in this document.
The optimality of Grover's algorithm in the query complexity model raises the need for the development of concrete algorithms for each problem. Projects such as (@JordanQuantumAlgorithmZoo2011) describe some of these algorithms, some of which could be implemented on Quipper and be further developed.

In the theoretical realm several questions remain.
Firstly, the circuit model can be feasibly generalized to other monoidal categories.
For example, if the unitary matrices are restricted to have real entries, this model can be proved to be equivalent to the general quantum model (@FaddeevLecturesquantummechanics2009).
What about other fields or division rings? Can a simpler description of quantum computation be found?

Secondly, the study of relativized models of quantum and classical computation was not addressed in this document, yet it provides for a wide array of theoretical results that hint at the separation and incomparability of quantum classes.
A recent celebrated result is the relativized separation of $\mathsf{BQP}$ and the polynomial hierarchy (@RazOracleSeparationBQP2018).

On the practical side, functional quantum programming languages could have stronger verification usage with the use of dependent types for reflecting the shape of inputs and outputs or linear types to model resource consumption and avoid the cloning of qubits.
The development of Linear Haskell, a linear types implementation on Haskell, could put this ideas into action on Quipper (@BernardyLinearHaskellPractical2017).

