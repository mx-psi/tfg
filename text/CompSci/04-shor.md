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

The two are equivalent due to the closure properties of $\mathsf{BQP}$ and the well-known classical reductions between the problems. The main theorem thus will be 

:::{.theorem #thm:shor}
(@NielsenQuantumComputationQuantum2010, TODO)

$$\operatorname{FACTORING} \in \mathsf{BQP},$$
in particular, [@prob:factoring] is solvable in $O(\log^3 N)$ quantum time with bounded error.
:::

How does this problem fit in classical complexity classes? 
$\operatorname{FACTORING} \in \mathsf{NP}$ is easy to show via [@prop:npverifier]: for $(n,k) \in \operatorname{FACTORING}$, the proof would be the non-trivial factor $m$, that would have at most as many digits as $k$, and the verifier would check that $m|n$, which can easily be done in polynomial time by the usual division algorithm.

On the other hand, it is believed that $\operatorname{FACTORING} \notin \mathsf{P}$.
Although this is not proven (since a proof would imply solving the $\mathsf{P}$ vs. $\mathsf{NP}$ problem),
the best known classical algorithm for solving this problem runs in time $\exp(O(\log^{1/3}N \sqrt{\log \log N}$ (@Lenstranumberfieldsieve1990a).

Factoring is an important problem because of the reliance of some widely used cryptographic systems on the hardness of this problem (@AroraComputationalComplexityModern2009, sec. 9.2.1).
Shor's algorithm is widely appraised for being one of the hallmarks of quantum computation, since it gives definite proof of an exponential quantum speedup between the best known classical algorithm and the best known quantum algorithm.

Nonetheless, its applicability is somewhat limited.
$\operatorname{FACTORING}$ is believed not to be $\mathsf{NP}$-complete, that is, an algorithm that decides this language does not seem to allow us to solve an arbitrary $\mathsf{NP}$ problem.
Hence, Shor's algorithm speedup is not as useful in principle as the one provided by Grover's algorithm (although this one is only polynomial).

## Quantum phase estimation

Firstly, we will present an algorithm that computes an $n$-bit approximation of the eigenvalue of an operator.
This will be directly useful to solve the factoring problem, but it will also be applicable in the case of Grover's algorithm.

:::{.problem name="Phase estimation" #prob:phase}
Approximate an eigenvalue of the eigenvector $\ket{u}$ a unitary operator $U$.

- **Input**: For each $j$, 
  an oracle that computes the controlled unitary operation $C-U^{2^j}$ and a vector $\ket{u}$
- **Promise**: $\ket{u}$ is an eigenvector of $U$.
- **Output**: An $n$-bit approximation of $\varphi_u$ such that $$\exp(2\pi i \varphi_u)$$ 
  is the eigenvalue of $U$ associated with $U$.
:::

Since $U$ is unitary its eigenvalues will lie on $\mathbb{T}$, and thus they can all be expressed as $\exp(2\pi i \varphi)$ for some $\varphi \in [0,1[$.
Hence, if we approximate $\varphi \approx 0.x_1 \dots x_n$, we can output $\ket{x_1 \cdots x_n}$ as an answer.

Next, we present a quantum algorithm that solves this problem in polynomial time in the number of bits of the approximation (in the query complexity setting).

:::{.algorithm name="Quantum phase estimation" #algo:qpe}
(@NielsenQuantumComputationQuantum2010, TODO)

**Solves:** the phase estimation problem, [@prob:phase].

Let $t = n + 2$.

1. Initialize $\ket{0}^{\otimes t}\ket{u}$. Call the first $t$ qubits the *top qubits* and the rest the *bottom qubits*.
2. Obtain an uniform superposition on the top qubits by applying Hadamard gates.
3. For each $j = 1 \dots t$, apply the $U^{2^j}$ operation on the bottom qubits controlled on the $j$th top qubit.
4. Apply the inverse quantum fourier transform on the top qubits.
5. Discard the bottom qubits and measure the top qubits.
:::

It is easy to show by applying [@lemma:productrepr] that the algorithm is correct on the case where $\varphi$ has exactly $n$ qubits, since the output of the first part of the algorithm gives us in that case the QFT of the desired output.

We now present the general proof of correctness.

:::{.theorem name="Correctness of phase estimation algorith" #thm:phase}
(@NielsenQuantumComputationQuantum2010, sec. 5.2.1)


Let $U$ be a unitary operator with an eigenvalue $\exp(2\pi i \varphi)$.
An $n$-bit approximation of $\varphi$ is polynomial-time computable in the quantum black box model ($O(n^2)$)
:::
:::{.proof}

The proof is also adapted from (@NielsenQuantumComputationQuantum2010, sec. 5.2.1).
We focus on the top qubits only, since the bottom qubits remain unaltered throughout the whole algorithm.
Let $T = 2^t$ and let $\overset{\sim}{\varphi}$ be the best $n$ bit approximation to $\varphi$, that is,
$b = \overset{\sim}{\varphi}2^t \in \{0,T-1\}$ and 
$$0 \leq \varphi -\overset{\sim}{\varphi} < 2^{-t}.$$


First, notice that since $\ket{u}$ is an eigenvector of $U$, the state of the top qubits after step 3 is
\begin{align*}
\ket{\phi_3} & = \frac{1}{\sqrt{2^{t}}}(\ket{0} + \exp(2\pi i 0.\varphi_t)\ket{1}) \dots (\ket{0} + \exp(2\pi i 0.\varphi_1 \dots \varphi_t)\ket{1}) \\
& = \frac{1}{\sqrt{2^{t}}} \sum_{k = 0}^{T -1} \exp(2\pi i \varphi k)\ket{k}
\end{align*}

If we apply the inverse QFT we have
$$\ket{\phi_4} = \frac{1}{2^t} \sum_{k = 0}^{T-1} \sum _{l = 0}^{T-1} \exp\left(\frac{-2\pi i k l}{2^t}\right)\exp(2\pi i \varphi k) \ket{l}$$

If we reorganize terms we have that the amplitude of $\ket{(b+1) \mod T}$ is
$$\alpha_t = \frac{1}{2^t} \sum_{k = 0}^{T-1} \left(\exp\left(2 \pi i (\varphi - (b+l)/2^t)\right)\right)^k.$$

The sum is a geometric series, with sum TODO
$$\alpha_t = \frac{1}{2^t} \sum_{k = 0}^{T-1} \left(\exp\left(2 \pi i (\varphi - (b+l)/2^t)\right)\right)^k.$$


:::

As a direct application of [@thm:phase] and as an intermediate step towards proving [@thm:shor], we prove that the order of an element in $U(\mathbb{Z}_N)$ can be calculated in polynomial quantum time, that is, we can solve the problem:

:::{.problem name="Order calculation" #prob:order}
Calculate the order of an element $x$ in the group of units $U(\ZZ_N)$.

- **Input:** Two integers $x$ and $N$.
- **Promise:** $x \in U(\ZZ_N)$, that is, $0 < x < N$ and $\operatorname{gcd}(x,N) = 1$.
- **Output:** The order of $x$ as an element of $U(\ZZ_N)$, that is, the least integer $r$ such that $x^r = 1$ in $U(\ZZ_N)$.
:::

We show how to solve it by using [@algo:qpe].
Notice that if [@algo:qpe] is applied with a superposition of eigenvectors $\sum \alpha_i \ket{u_i}$ as inputs, the output will be a superposition of estimations of its eigenvalues, $\sum \alpha_i \ket{\overset{\sim}{\varphi_i}}$.
This fact will be later used again for solving the quantum counting problem.

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

The classical part of Shor's algorithm is a randomized reduction of the decision problem associated with $\operatorname{FACTORING}$ to [@prob:order]. To prove that such reduction works, we need to present two auxiliary lemmas from (@NielsenQuantumComputationQuantum2010).

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
(@NielsenQuantumComputationQuantum2010, thm. A4.13)

Let $N$ be an odd positive composite integer with more than one prime factor. 
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

Let $r_i = \operatorname{ord}_{U(\ZZ_{p_i^{n_i}})}(x_i)$ and let

1. $2^d$ be the largest power of 2 such that $2^d | r$ and
2. for each $i$, $2^{d_i}$ the largest power of 2 such that $2^{d_i} | r_i$.

Assume $r$ is odd.
For all $i$, $r_i|r$, and hence $r_i$ is odd, so $d_i = 0$.

Assume $r$ is even and $x^{r/2} \equiv_N -1$.
Then for all $i$, $x^{r/2} \equiv_{p_i^{n_i}} -1$ and hence $r_i \not | r/2$, but $r_i | r$.
Therefore, $d_i = d$.

In any of these cases we have that $d_i$ is equal to the same value for all $i$ ($0$ or $d$).
Consider the following claim:

::::{.claim}
(@NielsenQuantumComputationQuantum2010, lemma A4.12)

Let $p \neq 2$ be prime, $n \geq 1$ be an integer and $2^d$ be the largest power of $2$ such that $2^d | \varphi(p^n)$, where $\varphi$ is Euler's phi function.
Then 
$$P\left[2^d | \operatorname{ord}_{U(\ZZ_{p^n})}(x)\right] = \frac12,$$
where $x$ is sampled uniformly from $U(\ZZ_{p^n})$.
::::
::::{.proof}
$\varphi(p^n) = p^{n-1}(p-1)$ is even and therefore $d\geq 1$.

Let $x \in U(\ZZ_{p^n})$ and $r =  \operatorname{ord}_{U(\ZZ_{p^n})}(x)$.
Since $p$ is prime, $U(\ZZ_{p^n})$ is a cyclic group. 
Let $U(\ZZ_{p^n}) = \langle a\rangle$, so that 
there exists some $k \in \{1,\dots,\varphi(p^n)\}$ such that $a^k = x$.

If $k$ is odd, then $a^{kr} = 1$ and hence $\varphi(p^n)|kr$, therefore $2^d|r$.

If $k$ is even then $$a^{k/2\varphi(p^n)} = (a^{\varphi(p^n)})^{k/2} = a^{k/2} = 1,$$
therefore $r | \varphi(p^n)/2$ and hence $2^d \not | r$.
::::

This claim shows then that, by applying the bound for each $i$ and using independence,
$$P[r \text{ is odd or } x^{r/2} \equiv_N -1] \leq \frac{1}{2^m} \leq \frac14,$$
where the last inequality follows from $N$ having more than one prime factor.
:::

Hence, we can apply the previously sketched-out algorithm to odd integers with more than one factor.
What remains is only checking the other cases.

We can check if $N$ is even by looking at its last digit on its binary representation, which takes constant time on a classical family of circuits.
For the remaining case, that is, $N = a^b$, with $a \geq 1, b \geq 2$, TODO.

Hence, Shor's algorithm is complete and is presented at [@algo:shor].

:::{.algorithm name="Shor's algorithm" #algo:shor}
(@NielsenQuantumComputationQuantum2010, TODO)

Solves [@prob:factoring].

1. Check if $N$ is even, if so **return** 2.
2. Check if $N = a^b$, for integers $a \geq 1, b \geq 2$, if so **return** $a$.
3. Sample $x$ uniformly from $\ZZ_N\backslash\{0\}$.
4. Check if $\operatorname{gcd}(x,N) > 1$, if so **return** $\operatorname{gcd}(x,N)$.
5. Find $r = \operatorname{ord}(x,N)$ by applying [@algo:qpe].
6. If $r$ is odd or $x^{r/2} \not \equiv_N -1$, **fail**.
7. **Return** $\operatorname{gcd}(x^{r/2} -1,N)$.
:::

By the previous discussion this proves [@thm:shor].
For finding *all* factors of a given number we may repeat [@algo:shor] and succesively divide the integer until we reach a base case. This would also take a polynomial amount of time, $O(\log^4 N)$.

## Quipper implementation


## The hidden subgroup problem
