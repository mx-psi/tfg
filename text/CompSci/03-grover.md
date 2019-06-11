# Grover's algorithm

In this section we present *Grover's algorithm*, a quantum algorithm that can be used to solve search and minimization problems, providing polynomial speedup in the query complexity setting with respect to the best possible classical algorithm.

The chapter is organized as follows: first we present the general problem Grover's algorithm attempts to solve and why it can be potentially useful.

Then, we describe the classical algorithm  and the quantum Grover's algorithm and prove that it is asymptotically optimal in the query complexity setting.

Lastly, we show how to implement this algorithm in the programming language Quipper.

## Search problems

The general problem Grover's algorithm attempts to solve is a *search problem*.
It is a very general problem with many potential applications.

:::{.problem name="Search"}

Search a string that has a certain property.

- **Input:**  A function $f:\BB^n \to \BB$.
- **Output:** A string $x$ such that $f(x) = 1$.
:::

As a possible application, consider a language $L \in \mathsf{NP}$, and fix a word $x \in \BB^n$ (if we allow randomness, we can consider $L \in \mathsf{MA}$ and proceed similarly).

Recalling [@prop:npverifier] consider as $f : \BB^{p(n)} \to \BB$ the function associated with the verifier $V$.
Then, if we have an algorithm to solve the search problem we can decide whether $x \in L$ or not.
Given the wide variety of problems of practical usefulness in $\mathsf{NP}$ (@AroraComputationalComplexityModern2009, chap. 2), this is an important and useful application of such problem.

As a more practical application, one can consider a search on a database.
In this case the function would indicate whether there has been a match or not for each item in the database.

Notice that we allow for potentially more than one matching string.
A simple restriction is to allow for exactly one possible string.

:::{.problem name="Search with one answer" #prob:searchwithone}

Search the only string that has a certain property.

- **Input:**  A function $f:\BB^n \to \BB$ such that $|f^{-1}(1)| = 1$.
- **Output:** The string $x$ such that $f(x) = 1$.
:::

We will first focus on this simpler version of the problem and later generalize the solution to allow for multiple answer.

## The classical case

In the query complexity setting we are not interested in the time it takes to compute $f$ but rather in the number of queries necessary to provide an answer. 

In the classical case, there is a trivial algorithm that provides an answer: simply check for every possible input until a match is found. The query complexity of this algorithm is $O(N) = O(2^n)$.

Even if $f$ takes unit time to compute, this algorithm is not efficient for solving the search problem associated with an $\mathsf{NP}$ language since it would take at least exponential time on the size of word being decided.

Furthermore, this algorithm is clearly optimal in the classical setting: in the worst case the last input checked is the matching one and thus $\Omega(N)$ queries are needed.

Randomness does not add an advantage. 
With a limited number $k$ of queries, the best possible random algorithm would be to randomly sample $k$ words without replacement from the set of possible inputs, in which we would have a probability of success of $k/N$. 
If bounded error is required, then we must do a linear amount of queries (e.g. $k =2N/3$) to answer, and thus asymptotically the query complexity is equal to the classical case (@Kayeintroductionquantumcomputing2007, sec 8.1).

As we shall see in the next section, Grover's algorithm builds on this idea and uses the features of quantum computing to *amplify* the probability of outputting a correct answer in order to provide 

## Grover's algorithm

Firstly, we need to define Grover's operator, an operator associated with a given oracle.

Consider the following operation.

:::{.definition name="Diffusion"}
Let $n \in \NN$.
The *diffusion* operator is the operator $$D_n : Q^{\otimes n} \to Q^{\otimes n}$$ given by the following procedure

1. Apply the Hadamard transform to each qubit,
2. Apply a phase shift such that 
   $$\ket{x} \mapsto \ket{x} \text{ if } x \neq 0, \quad \ket{0} \mapsto -\ket{0},$$
3. apply the Hadamard transform again to each qubit.
:::

It can be done with a linear number of gates; a circuit performing the diffusion operator for $n = 3$ qubits can be seen in [@fig:diffusion].

![Diffusion operator for $n =  3$ qubits.](TODO){#fig:diffusion}

Using the diffusion procedure, we now define *Grover's operator*, which is associated with a given oracle.
We omit dealing with the auxiliary qubits, since these are only altered by the oracle.
Recall that for a given function $f : \BB^n \to \BB$, its oracle $U_f: Q^{\otimes n +1} \to Q^{\otimes n+1}$ is the unique linear map that maps $$\ket{x}\ket{y} \mapsto \ket{x}\ket{y \oplus f(x)}.$$

:::{.definition name="Grover Operator"}
Given an oracle $U_f$, its *Grover's operator*, $$G_f : Q^{\otimes n +1} \to Q^{\otimes n+1}$$ is given by the following procedure

1. Apply the oracle $U_f$ to all qubits and
2. apply $D_n$ to all but the last qubit.
:::

This operator is crucial in the description of Grover's algorithm but also in the quantum counting and quantum existence algorithms.
When used by algorithms, we will always assume that the last qubit input, that is, qubit $\ket{y}$, is $H\ket{1}$, so that by [@lemma:signchange], we can see the oracle as performing in all but the last qubit the map
$$\ket{x} \mapsto (-1)^{f(x)}\ket{x}.$$

Grover's operator can be given a geometrical interpretation that we can see in the following lemma.

:::{.lemma}
Let $f : \BB^n \to \BB$ and $M = |f^{-1}(1)|$.

Let $\ket{\psi}$ be a uniform superposition, that is,
$$\ket{\psi} = H^{\otimes n}\ket{0}^{\otimes n} = \frac{1}{\sqrt{2^n}}\sum_{y \in \BB^n} \ket{y}$$
and $\ket{\beta}$ be the uniform superposition of solutions to the equation $f(x) = 1$, that is
$$\ket{\beta} = \frac{1}{\sqrt{M}} \sum_{x \in f^{-1}(1)} \ket{x}.$$

The restriction of Grover's operator to the subspace spanned by $\ket{\psi}$ and $\ket{\beta}$ is a rotation, whose angle $\theta$ verifies $$\cos \frac{\theta}{2} = \sqrt{\frac{N-M}{N}}.$$
:::
:::{.proof}
TODO
:::



:::{.algorithm name="Grover's algorithm"}
(@Kayeintroductionquantumcomputing2007, sec 8.1)

**Solves:** The search problem with one answer, [@prob:searchwithone].

1. Initialize an $n$ qubit register to $\ket{0 \dots 0}$.
2. Apply the $H$ gate to each qubit to obtain an uniform state, $$\frac{1}{\sqrt{N}}\sum_{k = 0}^{N-1} \ket{k}.$$
3. Apply $T$ times the following procedure
   i) 
:::

Lastly, we prove that Grover's algorithm outputs the correct answer with bounded error.

:::{.theorem name="Correctness of Grover's algorithm"}
TODO
:::


## Optimality

In the case of solving an $\mathsf{NP}$ problem, Grover's algorithm gives us at most a quadratic speedup replacing a query complexity of $O(2^n)$ to one of $O(\sqrt{2^n}) = O(2^{n/2})$.
This is an insufficient speedup from a practical point of view, since it still leaves us with an (at least) exponential run-time. Is there any possible improvement of this technique?

This section aims to prove that in the query complexity model Grover's algorithm is asymptotically optimal, meaning that any other algorithm that solves the search problem will have a run-time in $\Omega(\sqrt{N})$.
This does not prove of course that $\mathsf{NP} \not\subseteq \mathsf{BQP}$ or any other similar result.
It does however show that the general task of solving $\mathsf{NP}$ problems or other search problems with an exponential search space must be attacked by using the inner structure of the problem, since any algorithm that does not do so would have a running time in $\Omega(\sqrt{N})$.





## Applications and generalizations
