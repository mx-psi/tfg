# Programming quantum algorithms: Quipper

In this and the following sections we will present several key quantum algorithms that provide some speedup in comparison with the best known classical (or randomized) algorithm that solves the same problem.

This first section presents the general setup; both in terms of what will be said about algorithms and how they have been implemented using the programming language Quipper.

## The query complexity model

The focus of the previous sections on computation models was on time complexity.
These are the most meaningful practical measures of complexity; however, they are notoriously difficult to analyse, as the wide range of existing open problems in the field shows (@AaronsonmathoplimitsNP2016).

In the analysis of the algorithms that will be presented we will sometimes focus on an alternative complexity measure: *query complexity*, also known in the classical case as *decision tree complexity* (@AmbainisUnderstandingQuantumAlgorithms2017, sec. 2).

In the quantum case, we are given an *oracle* that gives us information about a certain binary string $x \in \BB^N$ (@Kayeintroductionquantumcomputing2007, sec 9.2).
Similar to the approached for [simulating classical operations](#simulating-classical-operations), we can have a unitary operation that maps $$\ket{j}\ket{y} \mapsto \ket{j}\ket{y \oplus x_j}.$$

We would then like to compute some property about the oracle; the question then becomes: 
how many *queries* have to be made to the oracle in order to compute such property with bounded error?

That is we say that a quantum algorithm $\{C_N\}_{}$ (with respect to any set of gates that includes the quantum oracle) that computes a certain function $f: \BB^\ast \to \BB^\ast$ (with bounded error) has query complexity $O(T(N))$ if the function that for each $N$ counts the number of oracle gates in $C_N$ is $O(T(N))$.

An alternative way of presenting query complexity is to talk about a function $f:\BB^n \to \BB$ that outputs $f(j) = x_j$ (where $j$ is passed as a binary string). We note that $N = 2^n$, and thus in this approach the query complexity would be $O(T(2^n))$.

Query complexity then gives a lower bound estimate of the actual time complexity; since we would have to add in the non-query gates as well as the amount of gates needed to simulate the oracle.

## Quipper

### stack and Haskell setup 

### Testing

### Quipper as an embedded language

Quipper is an embedded functional programming language based on Haskell that provides tools for quantum simulation and expressing circuit families.

### Relevant functions
We can think of the following functions has having this type

1. `qinit :: Struct Bool -> Circ (Struct Qubit)`
2. `hadamard, qnot gate_X, gate_Y, gate_Y :: Qubit -> Circ Qubit`
3. `controlled :: ControlSource c => Circ a -> c -> Circ a` (creates a controlled gate)

TODO


# The Deutsch-Jozsa algorithm

The Deutsch-Jozsa algorithm is one of the first quantum algorithms that provide some quantum speedup in the query complexity model.
It was first proposed in 1992 as a generalization of a previous algorithm that solves a special case [@CleveQuantumAlgorithmsRevisited1998].
It will serve as a first approximation to a concrete algorithm.

The problem it solves is as follows

:::{.problem name="Deutsch's Problem" #prob:deutsch}
Find out whether a function is balanced or constant.

- **Input:** A function $f:\BB^n \to \BB$
- **Promise:** The function is either constant or it is *balanced*, i.e., $|f^{-1}(0)| = |f^{-1}(1)|$.
- **Output:** A bit $b$ where $b = 0$ if the function is constant or $b = 1$ if it is balanced.
:::

As we work in the query complexity model, we assume $f$ is given as a reversible oracle that maps 
$$\ket{x}\ket{y} \mapsto \ket{x}\ket{y \oplus f(x)}.$$

In the classical case, at worst we have to check $2^{n-1} + 1$ inputs to distinguish between the two classes.
In the quantum case in contrast, it can be checked with exactly one query.

First, consider the following simple lemma,

:::{.lemma #lemma:hadamard}
(@NielsenQuantumComputationQuantum2010, eq. 1.50)

Let $n \in \NN, N = 2^n$ and $x \in \BB^n$. Then $$H^{\otimes n}\ket{x} = \frac{1}{\sqrt{2^n}}\sum_{y \in \BB^n} (-1)^{x \odot y}\ket{y},$$
where, if $x = x_1 \dots x_n$ and $y = y_1 \dots y_n$, then $$x \odot y = \sum_{j=1}^n x_jy_j \mod 2,$$
is its "bitwise inner product" in $\ZZ_2$.
:::
:::{.proof}

Let $n=1$. We have 
$$H\ket{x} = \frac{1}{\sqrt{2}}(\ket{0} + (-1)^{x}\ket{1}) = \sum_{y = 0}^1 (-1)^{xy}\ket{y} = \sum_{y \in \BB} (-1)^{x \odot y}\ket{y}.$$

Let $n > 1$. Then
\begin{align*}
H^{\otimes n}\ket{x} & = \bigotimes_{k = 1}^n \sum_{y_k = 0}^1 (-1)^{x_ky_k}\ket{y_k} \\
& = \sum_{y \in \BB^n} \bigotimes_{k = 1}^n (-1)^{x_ky_k}\ket{y_k} \\
& = \sum_{y \in \BB^n} (-1)^{\sum x_ky_k}\ket{y} \\
& = \sum_{y \in \BB^n} (-1)^{x \odot y}\ket{y}.
\end{align*}
:::

In particular, we can obtain an uniform superposition of all posible $n$ bit strings by using [@lemma:hadamard],
$$H^{\otimes n}\ket{0}^{\otimes n} = \frac{1}{\sqrt{2^n}}\sum_{y \in \BB^n} (-1)^{0 \odot y}\ket{y} = \frac{1}{\sqrt{2^n}}\sum_{y \in \BB^n} \ket{y}.$$

Next, consider the following algorithm:

:::{.algorithm name="Deutsch-Jozsa algorithm"}
(@NielsenQuantumComputationQuantum2010, sec. 1.4.4)

**Solves:** [@prob:deutsch].

1. Initialize $n$ qubits to $\ket{0}$ and an extra qubit to $\ket{1}$.
2. Apply Hadamard gates to each qubit.
3. Apply the oracle for $f$ to the whole state.
4. Apply Hadamard transform to the first $n$ qubits.
5. Discard the last qubit and measure the first $n$ qubits.
6. Output the logical OR of the measured bits.
:::


