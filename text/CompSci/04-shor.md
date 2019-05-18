\newpage

# Shor's algorithm

In this section we describe one of the main applications of QFT on quantum computing: Shor's algorithm, which shows that factoring is feasible quantumly.

As usual, we encode natural numbers by their binary representation, so that the length of the input $N \in \NN$ is $\lceil \log N\rceil \in O(\log N)$.

The decision problem we will solve is the one associated with the language:

:::{.definition}
$$\operatorname{FACTORING} = \{(n,k) \;:\; n,k \in \NN, \; n \text{ has a non-trivial divisor smaller than } k \}.$$
:::

In order to solve it we will solve the associated function problem: we will give an algorithm that gets a non-trivial factor of a number if there is one. The two are equivalent due to the closure properties of $\mathsf{BQP}$ and the well-known classical reductions between the problems.


## Quantum phase estimation

Firstly, we will present an algorithm that computes an $n$-bit approximation of the eigenvalue of an operator.

:::{.problem name="Phase estimation" #prob:phase}
Approximate an eigenvalue of the eigenvector $\ket{u}$ a unitary operator $U$.

- **Input**: For each $j$, 
  an oracle that computes the controlled unitary operation $C-U^{2^j}$ and a vector $\ket{u}$
- **Promise**: $\ket{u}$ is an eigenvector of $U$.
- **Output**: An $n$-bit approximation of $\varphi_u$ such that $$\exp(2\pi i \varphi_u)$$ 
  is the eigenvalue of $U$ associated with $U$.
:::

Since $U$ is unitary its eigenvalues will have modulus one and thus they can all be expressed as $\exp(2\pi i \varphi)$ for some $\varphi \in [0,1[$.
Hence, if we approximate $\varphi \approx 0.x_1 \dots x_n$, we can output $\ket{x_1 \cdots x_n}$ as an answer.

Next, we present a quantum algorithm that solves this problem in polynomial time in the number of bits of the approximation.

:::{.algorithm name="Quantum phase estimation" #algo:qpe}
[@NielsenQuantumComputationQuantum2010; TODO]

**Solves:** the phase estimation problem, [@prob:phase].

Let $t = n + 2$.

1. Initialize $\ket{0}^{\otimes t}\ket{u}$. Call the first $t$ qubits the *top qubits* and the rest the *bottom qubits*.
2. Obtain an uniform superposition on the top qubits by applying Hadamard gates.
3. For each $j = 1 \dots t$, apply the $U^{2^j}$ operation on the bottom qubits controlled on the $j$th top qubit.
4. Apply the inverse quantum fourier transform on the top qubits.
5. Discard the bottom qubits and measure the top qubits.
:::

:::{.lemma name="Correctness of phase estimation algorith" #lemma:phase}
Let $U$ be a unitary operator with an eigenvalue $\exp(2\pi i \varphi)$.
An $n$-bit approximation of $\varphi$ is polynomial-time computable in the quantum black box model ($O(n^2)$)
:::
:::{.proof}
TODO
:::

As a direct application of [@lemma:phase] we prove that the order of an element in $U(\mathbb{Z}_N)$ can be calculated in polynomial quantum time.

:::{.lemma}
Let $N \in \NN$. Then $\operatorname{ord}: U(\ZZ_N) \to \NN$ is polynomial quantum time computable.
:::
:::{.proof}
Let us consider the unique unitary map $U$ that maps, for $j,k \in {0, \dots, N-1}$ (and therefore expressable in $n$ qubits each),
$$\ket{j}\ket{k} \mapsto \ket{j}\ket{x^jk \mod N}.$$
This map is efficiently computable for powers $2^j$ via binary exponentiation.

Let $r = \operatorname{ord}_{\ZZ_N}(x)$ and $s \in \{0,\dots,r-1\}$.
Let $$\ket{u_s} = \frac{1}{\sqrt{r}} \sum_{k=0}^{r-1} \exp\left(-2\pi i k \frac{s}{r}\right)\ket{x^k \mod N}.$$

One can easily verify that for all $s \in \{0,\dots,r-1\}$, $\ket{u_s}$ is an eigenvector of $U$ with eigenvalue $$\exp\left(2\pi i \frac{s}{r}\right).$$

<!--TODO:Hacer-->

Furthermore, consider that
\begin{align*}
\frac{1}{\sqrt{r}} \sum_{s=0}^{r-1}\ket{u_s} = \ket{1 \dots 1}
\end{align*}

Consider applying [@algo:qpe] with unitary map $U$ and $\ket{1 \dots 1}$ as an eigenvector.
Clearly, the output will be an approximation of the phase of one of the eigenvalues of some $\ket{u_s}$.

Hence, the output will be an approximation of $$\frac{s}{r}.$$
If the approximation is accurate enough, the period $r$ can be recovered from the decimal expression of this fraction by using *continued fractions*.

<!--TODO: Justificar fracciones continuadas y precisión de la estimación-->

:::

## Classical part

:::{.algorithm name="Shor's algorithm"}
:::


:::{.theorem name="Shor's algorithm" #thm:shor}
There exists a $O(n^3)$ algorithm that factors a given natural number.

Consequently:

1. TODO find all factors
2. $$\operatorname{FACTORING} \in \mathsf{BQP}$$
:::

Using more efficient multiplication algorithms, such as those based on the FFT, can bring down the asymptotic complexity of Shor's algorithm to TODO.

## Quipper implementation


## The hidden subgroup problem
