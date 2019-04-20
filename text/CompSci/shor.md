# Shor's algorithm

In this section we describe one of the main applications of QFT on quantum computing: Shor's algorithm, which shows that factoring is feasible quantumly.

As usual, we encode natural numbers by their binary representation, so that the length of the input $N \in \NN$ is $\lceil \log N\rceil \in O(\log N)$.

The decision problem we will solve is the one associated with the language:

:::{.definition}
$$\operatorname{FACTORING} = \{(n,k) \;:\; n,k \in \NN, \; n \text{ has a non-trivial divisor smaller than } k \}.$$
:::

In order to solve it we will solve the associated "search" problem: we will give an algorithm that gets a non-trivial factor of a number if there is one. The two are equivalent due to the closure properties of $\mathsf{BQP}$ and the well-known classical reductions between the problems.


## Quantum phase estimation

::::{.comment}
:::{.algorithm name="Quantum phase estimation"}
:::
:::::

:::{.lemma name="Correctness of phase estimation algorith" #lemma:phase}
Let $U$ be a unitary operator with an eigenvalue $\exp(2\pi i \varphi)$.
An $n$-bit approximation of $\varphi$ is polynomial-time computable in the quantum black box model ($O(n^2)$)
:::
:::{.proof}
TODO
:::

As a direct application of [@lemma:phase] we prove that the order of an element TODO

:::{.lemma}
Let $N \in \NN$. Then $\operatorname{ord}: U(\ZZ_N) \to \NN$ is polynomial quantum time computable.
:::
:::{.proof}
TODO
:::

## Classical part

::::{.comment}
:::{.algorithm name="Shor's algorithm"}
:::
::::


:::{.theorem name="Shor's algorithm" #thm:shor}
There exists a $O(n^3)$ algorithm that factors a given natural number.

Consequently:

1. TODO find all factors
2. $$\operatorname{FACTORING} \in \mathsf{BQP}$$
:::

Using more efficient multiplication algorithms, such as those based on the FFT, can bring down the asymptotic complexity of Shor's algorithm to TODO.

## Quipper implementation
