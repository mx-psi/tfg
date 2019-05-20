\newpage

# Shor's algorithm

In this section we describe one of the main applications of QFT on quantum computing: Shor's algorithm, which shows that factoring is feasible quantumly.

As usual, we encode natural numbers by their binary representation, so that the length of the input $N \in \NN$ is $\lceil \log N\rceil \in O(\log N)$.

The decision problem we will solve is the one associated with the language:

:::{.definition}
$$\operatorname{FACTORING} = \{(n,k) \;:\; n,k \in \NN, \; n \text{ has a non-trivial divisor smaller than } k \}.$$
:::

In order to solve it we will solve the associated function problem: we will give an algorithm that gets a non-trivial factor of a number. 

:::{.problem name="Factoring" #prob:factoring}
Find a factor of an integer $N$.

- **Input:** An integer $N$.
- **Promise:** $N$ is composite
- **Output:** A non trivial factor of $N$.
:::


The two are equivalent due to the closure properties of $\mathsf{BQP}$ and the well-known classical reductions between the problems.


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

As a direct application of [@lemma:phase] we prove that the order of an element in $U(\mathbb{Z}_N)$ can be calculated in polynomial quantum time, that is, we can solve the problem:

:::{.problem name="Order calculation" #prob:order}
Calculate the order of an element $x$ in the group of units $U(\ZZ_N)$.

- **Input:** Two integers $x$ and $N$.
- **Promise:** $x \in U(\ZZ_N)$, that is, $0 < x < N$ and $\operatorname{gcd}(x,N) = 1$.
- **Output:** The order of $x$ as an element of $U(\ZZ_N)$, that is, the least integer $r$ such that $x^r = 1$ in $U(\ZZ_N)$.
:::

We show how to solve it by constructing an appropiate pair of unitary map and eigenvector.

:::{.lemma #lemma:order}
[@prob:order] is solvable in quantum polynomial time.
:::
:::{.proof}
Let us consider the unique unitary map $U$ that maps, for $j,k \in {0, \dots, N-1}$ (and therefore expressable in $n$ qubits each),
$$\ket{j}\ket{k} \mapsto \ket{j}\ket{x^jk \mod N}.$$
This map is efficiently computable for powers $2^j$ via binary exponentiation.
<!--TODO:Demostrar que U es unitario-->

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

The classical part of Shor's algorithm is a randomized reduction of the decision problem associated with $\operatorname{FACTORING}$ to [@prob:order]. To prove that such reduction works, we need to present two auxiliary lemmas from [@NielsenQuantumComputationQuantum2010].

:::{.lemma #lemma:solution}
Let $N$ be a composite integer and $x \in \ZZ_N$, $x \notin \{-1,1\}$ an element such that $x^2 = 1$.

Then $\operatorname{gcd}(x-1,N)$ is a non-trivial divisor of $N$ and it is computable in classical time $O(\log^3 N)$.
:::
:::{.proof}

Since $x^2 = 1$ in $\ZZ_N$, we have that $N | x^2 -1 = (x-1)(x+1)$.
Furthermore, $x-1,x+1 < N$, and hence $N \not|x-1$ and $N \not | x+1$.

Let $k$ be such that $x^2 -1 = Nk$.
Assume $x-1$ and $N$ are coprime.
Then, by applying Bézout's identity, we have that there exists $a,b$ such that
$$aN + b(x-1) = 1.$$
Multiplying by $x+1$ we have
$$aN(x+1)+ b(x^2-1) = x+1 \implies N(a(x+1) + bk) = x+1.$$
Therefore, $N | x+1$, but this is a contradiction.

Therefore, $1<\operatorname{gcd}(x-1,N)<N$, and thus it is a non-trivial divisor of $N$.
We may then compute it using the well-known Euclides' algorithm, which has the desired complexity.
:::

[@lemma:solution] hints at the reduction used by Shor's algorithm: if we can find a non-trivial solution to 
$$x^2 \equiv_N 1,$${#eq:shor}
then we can find a non-trivial divisor of $N$.

In particular, suppose we have $a \in \ZZ_N$, we compute its order using [@lemma:order] and it turns out to be even.
Then, by choosing $x = a^{r/2}$, we have a solution to [@eq:shor].
If it is not trivial we can apply [@lemma:solution] to get a non-trivial factor of $N$.

The following lemma shows that this happens with enough probability if we sample $a \in U(\ZZ_N)$ uniformly.

:::{.lemma}
[@NielsenQuantumComputationQuantum2010; thm. A4.13]

Let $N$ be an odd positive composite integer. 
Then, if $x$ is sampled uniformly from $U(\ZZ_N)$ and $r = \operatorname{ord}_{U(\ZZ_N)}(x)$ we have
$$P[r \text{ is odd or } x^{r/2} \equiv_N -1] \leq \frac13.$$
:::
:::{.proof}

We show that 
$$P[r \text{ is odd or } x^{r/2} \equiv_N -1] \leq \frac14.$$

Let $N = \prod_{i=1}^m p_i^{n_i}$
By the Chinese remainder theorem, we have that
$$U(\ZZ_N) \cong \prod_{i=1}^m U(\ZZ_{p_i^{n_i}}),$$
hence sampling uniformly $x \sim U(\ZZ_N)$ is equivalent to sampling uniformly and independently $x_i \sim U(\ZZ_{p_i^{n_i}})$, and $x$ would be the unique element such that $x \equiv_{p_i^{n_i}} x_i$ for each $i$.

Let $r_i = \operatorname{ord}_{U(\ZZ_{p_i^{n_i}})}(x_i)$ and let $2^d$

::::{.claim}
Let $p \neq 2$ be prime, $n \geq 1$ be an integer and $2^d$ be the largest power of $2$ such that $2^d | \varphi(p^n)$, where $\varphi$ is Euler's phi function.
Then 
$$P\left[2^d | \operatorname{ord}_{U(\ZZ_{p^n})}(x)\right] = \frac12,$$
where $x$ is sampled uniformly from $U(\ZZ_{p^n})$.
::::
::::{.proof}
::::

:::


:::{.algorithm name="Shor's algorithm"}
[@NielsenQuantumComputationQuantum2010; TODO]

Solves [@prob:factoring].

1. Check if $N$ is even, if so **return** 2.
2. Check if $N = a^b$, for integers $a \geq 1, b \geq 2$, if so **return** $a$.
3. Sample $x$ uniformly from $\ZZ_N\backslash\{0\}$.
4. Check if $\operatorname{gcd}(x,N) > 1$, if so **return** $\operatorname{gcd}(x,N)$.
5. Find $r = \operatorname{ord}(x,N)$ by applying [@algo:qpe].
6. If $r$ is odd or $x^{r/2} \not \equiv_N -1$, **fail**.
7. **Return** $\operatorname{gcd}(x^{r/2} -1,N)$.
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
