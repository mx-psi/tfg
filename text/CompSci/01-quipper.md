\newpage

# Programming quantum algorithms: Quipper

In this and the following sections we will present several key quantum algorithms that provide some speedup in comparison with the best known classical (or randomized) algorithm that solves the same problem.

This first section presents the general setup; both in terms of what will be said about algorithms and how they have been implemented using the programming language Quipper.

## The query complexity model

The focus of the previous sections on computation models was on time complexity.
These are the most meaningful practical measures of complexity; however, they are notoriously difficult to analyse, as the wide range of existing open problems in the field shows (@AaronsonmathoplimitsNP2016).

In the analysis of the algorithms that will be presented we will sometimes focus on an alternative complexity measure: *query complexity*, also known in the classical case as *decision tree complexity* (@AmbainisUnderstandingQuantumAlgorithms2017, sec. 2).

In the quantum case, we are given an *oracle* that gives us information about a certain binary string $x \in \BB^N$ (@Kayeintroductionquantumcomputing2007, sec 9.2).
Similar to the approached mentioned in [Simulating classical operations], we can have a unitary operation that maps $$\ket{j}\ket{y} \mapsto \ket{j}\ket{y \oplus x_j}.$$

We would then like to compute some property about the oracle; the question then becomes: 
how many *queries* have to be made to the oracle in order to compute such property with bounded error?

That is we say that a quantum algorithm $\{C_N\}_{}$ (with respect to any set of gates that includes the quantum oracle) that computes a certain function $f: \BB^\ast \to \BB^\ast$ (with bounded error) has query complexity $O(T(N))$ if the function that for each $N$ counts the number of oracle gates in $C_N$ is $O(T(N))$.

An alternative way of presenting query complexity is to talk about a function $f:\BB^n \to \BB$ that outputs $f(j) = x_j$ (where $j$ is passed as a binary string). We note that $N = 2^n$, and thus in this approach the query complexity would be $O(T(2^n))$.

Query complexity then gives a lower bound estimate of the actual time complexity; since we would have to add in the non-query gates as well as the amount of gates needed to simulate the oracle.

## Quipper

Quipper is an embedded functional programming language based on Haskell that provides tools for quantum simulation and expressing circuit families.

### Relevant functions
We can think of the following functions has having this type

1. `qinit :: Struct Bool -> Circ (Struct Qubit)`
2. `hadamard, qnot gate_X, gate_Y, gate_Y :: Qubit -> Circ Qubit`
3. `controlled :: ControlSource c => Circ a -> c -> Circ a` (creates a controlled gate)

TODO


# The Deutsch-Jozsa algorithm

## Deutsch algorithm
