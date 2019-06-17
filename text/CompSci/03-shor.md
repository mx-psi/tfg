# Shor's algorithm

## Introduction

In this chapter we describe one of the most well-known quantum algorithms: Shor's algorithm, which shows that factoring is feasible quantumly. To develop this algorithm we will also need to describe two essential quantum subroutines that will find later use: the Quantum Fourier Transform and the quantum phase estimation algorithm.

As it is usual in complexity theory, we encode natural numbers by their binary representation, so that the length of the input $N \in \NN$ is $\lceil \log N\rceil \in O(\log N)$.

The decision problem we will solve is the one associated with the language:

:::{.definition}
$$\operatorname{FACTORING} = \{(n,k) \;:\; n,k \in \NN, \; n \text{ has a non-trivial divisor smaller than } k \}.$$
:::

In order to solve it we will solve the associated function problem: we will give a quantum algorithm that gets a non-trivial factor of a number. 

:::{.problem name="Factoring" #prob:factoring}
Find a factor of an integer $N$.

- **Input:** An integer $N$.
- **Promise:** $N$ is composite
- **Output:** A non trivial factor of $N$.
:::

Solving this function problem and solving the decision problem of $\operatorname{FACTORING}$ are equivalent up to a classical polynomial time reduction. 
Furthermore, the promise of $N$ not being prime can be checked in classical polynomial time by first using a primality testing algorithm (@AgrawalPRIMES2004).

Thus, we will prove:

:::{.theorem #thm:shor}
(@NielsenQuantumComputationQuantum2010, sec. 5.3.2)

$\operatorname{FACTORING} \in \mathsf{BQP}$.
In particular, [@prob:factoring] is solvable in $O(\log^3 N)$ quantum time with bounded error.
:::

How is [@prob:factoring] classified classically? 
$\operatorname{FACTORING} \in \mathsf{NP}$ is easy to show via [@prop:npverifier]: for $(n,k) \in \operatorname{FACTORING}$, the proof would be the non-trivial factor $m$, that would have at most as many digits as $k$, and the verifier would check that $m|n$, which can easily be done in polynomial time by the usual division algorithm.

On the other hand, it is believed that $\operatorname{FACTORING} \notin \mathsf{P}$.
Although this is not proven (since a proof would imply solving the $\mathsf{P}$ vs. $\mathsf{NP}$ problem),
the best known classical algorithm for solving this problem runs in time $\exp(O(\log^{1/3}N \sqrt{\log \log N})$ (@Lenstranumberfieldsieve1990a).

Factoring is an important problem because of the reliance of some widely used cryptographic systems on the hardness of this problem (@AroraComputationalComplexityModern2009, sec. 9.2.1).
Shor's algorithm is widely appraised for being one of the most important results of quantum computation, since it gives definite proof of an exponential quantum speedup between the best known classical algorithm and the best known quantum algorithm.

Nonetheless, its applicability is somewhat limited.
$\operatorname{FACTORING}$ is believed not to be $\mathsf{NP}$-complete, that is, an algorithm that decides this language does not seem to allow us to solve an arbitrary $\mathsf{NP}$ problem.
Hence, Shor's algorithm speedup is not as useful in principle as the one that will be provided by Grover's algorithm (although this one is only polynomial).


## The Quantum Fourier Transform

In this section we will describe the Quantum Fourier Transform, an essential part of Shor's algorithm and one of the main algorithms that allows us to achieve super-polynomial speedups. It depends on the notion of discrete normalized Fourier transform.

Recall from [@dfn:amplitude] that the *amplitude vector* of a quantum state is the coordinate vector of that state with respect to the computational basis.

:::{.definition name="Unitary DFT"} 
(@RaoFastFouriertransform2010, sec 2.1.3)

The *discrete normalized Fourier Transform* (UDT) is the map $\operatorname{UDT} : \CC^N \to \CC^N$ given by
$$\operatorname{UDT}(x) = y,\text{ where } y_k := \frac{1}{\sqrt{N}} \sum_{j= 0}^{N-1} x_j \exp\left(\frac{2\pi ijk}{N}\right),$$
for all $k \in \{0,\dots,N-1\}, x = (x_0, \dots, x_{N-1}) \in \CC^N$.
:::

The unitary DFT has a quantum equivalent:

:::{.definition name="Quantum Fourier Transform"}
(@NielsenQuantumComputationQuantum2010, sec. 5.1)

The *quantum Fourier transform* (QFT) is the unique linear operator $\operatorname{QFT}: Q^{\otimes n} \to Q^{\otimes n}$ that maps $$\ket{x} \mapsto \frac{1}{\sqrt{N}}\sum_{k = 0}^{N-1} \exp\left(\frac{-2\pi ixk }{N}\right)\ket{k}$$
for every for $x \in \{0,\dots, N-1\}$.

Alternatively, it is the operator that maps a quantum state with amplitude vector $x$ in the quantum state with amplitude vector $\operatorname{UDT}(x)$.
:::

Its most straightforward application is the sampling according to the distribution given by the Fourier transform coefficients, but it is not directly applicable for the calculation of the UDT, as the amplitude vector can not be recovered directly. 

Despite this important caveat, the QFT is an essential part of Shor's algorithm and the quantum counting algorithm among others, since it allows us to efficiently encode information on the amplitude vector.
To show how to compute it efficiently, we first arrive at an alternative representation of the QFT that simplifies its calculation.

:::{.lemma name="Product representation" #lemma:productrepr}
(@NielsenQuantumComputationQuantum2010, sec. 5.1)

Let $x \in \{0,\dots, N-1\}$ and $x_j \in \{0,1\}$ such that
$$x/2^n = \sum_{j = 1}^n x_j 2^{-j}  = 0.x_1 \dots x_n.$$

Then
\begin{align*}
\operatorname{QFT}\ket{x} & = \operatorname{QFT}\ket{x_1 \dots x_n} \\
& = \frac{1}{\sqrt{N}} ( \ket{0} + \exp(2\pi i 0.x_n)\ket{1}) \otimes \cdots \otimes ( \ket{0} + \exp(2\pi i 0.x_1 \dots x_n)\ket{1})
\end{align*}
:::
:::{.proof}

Let $k/2^n = \sum_{j = 1}^n k_j 2^{-j} = 0.k_1 \dots k_n$.

We then have
\begin{align*}
\sum_{n= 0}^{N-1} x_n \exp\left(2\pi ix \frac{k}{2^n}\right) & = \sum_{n= 0}^{N-1} x_n \exp\left(2\pi i x \sum_{j = 1}^n k_j 2^{-j}\right) \\
& = \sum_{k \in \BB^n} \bigotimes_{j = 1}^n \exp(2\pi i x k_j)\ket{k_j} \\
& = \bigotimes_{j = 1}^n \left(\sum_{k_j = 0}^1 \exp(2\pi i x k_j2^{-j})\ket{k_j} \right)\\
& = \bigotimes_{j = 1}^n  (\ket{0} + \exp(2\pi i x 2^{-j})\ket{1}) \\
& = \bigotimes_{j = 1}^n  (\ket{0} + \exp(2\pi i 0.x_{n-j+1}\dots x_n)\ket{1}),
\end{align*}
where in the last equality we have used $x2^{-j} = x_1\dots x_{n-j}.x_{n-j+1}\dots x_n$, and therefore
\begin{align*}
\exp(2\pi i x2^{-j}) & = \exp(2\pi i x_1\dots x_{n-j})\exp(2\pi i 0.x_{n-j+1}\dots x_n) \\
& = \exp(2\pi i 0.x_{n-j+1}\dots x_n),
\end{align*}
since $\exp(2\pi i a) = 1$ for any $a \in \ZZ$.
:::

This expression allows us to easily construct a polynomial-size uniform family of quantum circuits that computes the QFT.
For comparison, notice that the best-known classical algorithm for computing the DFT (the FFT algorithms) have an asymptotic efficiency of $O(N \log N)$ (@RaoFastFouriertransform2010).

:::{.theorem name="QFT Algorithm" #thm:QFT}
There exists a polynomial-size uniform family of quantum circuits that computes the quantum Fourier transform.

Specifically, for a quantum input of $N = 2^n$ qubits the circuit has a size $O(n^2) = O(\log^2 N)$.
:::
:::{.proof}
Let $n \in \mathbb{N}$ be the number of qubits of the input, of shape $\ket{x} = \ket{x_1 \dots x_n}$.

For $k = 2, \dot, n$, let $R_k := R_{2\pi/2^k}$ be a phase rotation gate.

Clearly, $$H\ket{x_i} = \frac{1}{\sqrt{2}}(\ket{0} + (-1)^{x_i}\ket{1}) = \frac{1}{\sqrt{2}}(\ket{0} + e^{2\pi i 0.x_1}\ket{1}).$$

Let $k \in \{1,\dots,n\}$.
Assume a qubit is in state $$\ket{\psi} = \frac{1}{\sqrt{2}}(\ket{0} + e^{2\pi i 0.x_1 x_2 \dots x_{k-1}}),$$
then, if we apply an $R_k$ gate controlled by $\ket{x_k}$ we then have 
$$C-R_k\ket{x_k}\ket{\psi} = \frac{1}{\sqrt{2}}(\ket{0} + e^{2\pi i 0.x_1 x_2 \dots x_k}).$$

Hence, if for each qubit $\ket{x_k}$ we apply the Hadamard gate and the controlled $R_j$ gate for $j=1,\dots, n-k+1$ controlled by $\ket{x_j}$, we will have, up to reordering of the qubits, the expression given by [@lemma:productrepr].

The circuit will have size  $$\frac{n(n+1)}{2} \in O(n^2),$$ since each qubit needs $n-k+2$ gates.
:::

As any result having to do with concrete sizes of families of quantum circuits, the $O(n^2)$ [@thm:QFT] is given with respect to a basis that has the appropriate gates, and for a fixed basis there might be a poly-logarithmic difference given by [@thm:solovay].

An example circuit for the Quantum Fourier Transform of 3 qubits can be seen in [@fig:qft].

![Circuit for the 3 qubit Quantum Fourier Transform.](assets/qft.pdf){#fig:qft width=110%}

### Quipper implementation

The Quipper implementation for the Quantum Fourier Transform is a simplified version of the one implemented at `QuipperLib.QFT`.
It can be found at `src/lib/Algorithms/QFT.hs`.

It is a simple recursive algorithm.
The base case uses the empty list and does nothing,
```haskell
qft [] = pure []
```

The recursive case applies the base case to all but the first qubit, conditionally rotates the first qubit with respect to the rest and then applies a Hadamard gate.

```haskell
qft (x:xs) = do
  xs'  <- qft xs
  xs'' <- rotations x xs' (length xs')
  x'   <- hadamard x
  pure (x' : xs'')
```

The `rotations` function implements a simple loop recursively by making use of applicative functors.
```haskell
rotations :: Qubit -> [Qubit] -> Int -> Circ [Qubit]
rotations _ []     _ = pure []
rotations c (q:qs) n = 
  (:) <$> rGate ((n + 1) - length qs) q `controlled` c <*> rotations c qs n
```
`n` is the total length of the qubits that we want to condition.

## Quantum phase estimation

We now present an algorithm that computes an $n$-bit approximation of the eigenvalue of an operator.
This will be directly useful to solve the factoring problem, and it will also be applicable in the case of Grover's algorithm.

:::{.problem name="Phase estimation" #prob:phase}
Approximate an eigenvalue of the eigenvector $\ket{u}$ a unitary operator $U$.

- **Input**: For each $j$, 
  an oracle that computes a controlled $U^{2^j}$ operation and a vector $\ket{u}$
- **Promise**: $\ket{u}$ is an eigenvector of $U$.
- **Output**: An $n$-bit approximation of $\varphi_u$ such that $$\exp(2\pi i \varphi_u)$$ 
  is the eigenvalue of $U$ associated with $U$.
:::

Since $U$ is unitary, its eigenvalues will lie on the unit circle, and thus they can all be expressed as $\exp(2\pi i \varphi)$ for some $\varphi \in [0,1[$.
Hence, if we approximate $\varphi \approx 0.x_1 \dots x_n$, we can output $\ket{x_1 \cdots x_n}$ as an answer.
We call $\varphi_u$ a *phase*.

Next, we present a quantum algorithm that solves this problem in a polynomial number of queries in the number of bits of the approximation.

:::{.algorithm name="Quantum phase estimation" #algo:qpe}
(@NielsenQuantumComputationQuantum2010, sec 5.2)

**Solves:** the phase estimation problem, [@prob:phase].

Let $t = n + 2$.

1. Initialize $\ket{0}^{\otimes t}\ket{u}$. Call the first $t$ qubits the *phase qubits* and the rest the *eigenvector qubits*.
2. Obtain an uniform superposition on the phase qubits by applying Hadamard gates.
3. For each $j = 1 \dots t$, apply the $U^{2^j}$ operation on the eigenvector qubits controlled on the $j$\textsuperscript{th} phase qubit.
4. Apply the inverse Quantum Fourier Transform on the phase qubits.
5. Discard the bottom qubits and measure the phase qubits.
:::

It is easy to show by applying [@lemma:productrepr] that the algorithm is correct on the case where $\varphi$ has exactly $n$ qubits, since the output of the first part of the algorithm gives us in that case the QFT of the desired output.

An example circuit implementing [@algo:qpe] is shown in [@fig:qpe].

![The Quantum Phase Estimation subroutine for an unitary operator $U : Q^{\otimes 2} \to Q^{\otimes 2}$ with eigenvector $\ket{00}$ and an approximation using $t = 4$ qubits. "RQFT" does the reverse QFT.](assets/qpe.pdf){#fig:qpe width=100%}

We now present the general proof of correctness.

:::{.theorem name="Correctness of QPE" #thm:phase}
(@NielsenQuantumComputationQuantum2010, sec. 5.2.1)

Let $U$ be a unitary operator with an eigenvalue $\exp(2\pi i \varphi)$.
An $n$-bit approximation of $\varphi$ is polynomial-time computable in the quantum black box model ($O(n^2)$)
:::
:::{.proof}
The proof is also adapted from (@NielsenQuantumComputationQuantum2010, sec. 5.2.1).

The number of quantum gates used by [@algo:qpe] is $O(n^2)$, since we only add a linear amount of gates apart from the ones used in the QFT algorithm. 

For the correctness, we focus on the phase qubits only, since the eigenvector qubits remain unaltered throughout the whole algorithm.
Recall that $t = n + 2$ and let $T = 2^t$.

Let $\overset{\sim}{\varphi}$ be the best $n$ bit approximation to $\varphi$, that is,
$b = \overset{\sim}{\varphi}T \in \{0,T-1\}$ and $0 \leq \delta < 2^{-t}, \text{ where } \delta = \varphi -\overset{\sim}{\varphi}.$

First, notice that since $\ket{u}$ is an eigenvector of $U$, the state of the phase qubits after step 3 is
\begin{align*}
\ket{\phi_3} & = \frac{1}{\sqrt{2^{t}}}(\ket{0} + \exp(2\pi i 0.\varphi_t)\ket{1}) \cdots (\ket{0} + \exp(2\pi i 0.\varphi_1 \dots \varphi_t)\ket{1}) \\
& = \frac{1}{\sqrt{2^{t}}} \sum_{k = 0}^{T -1} \exp(2\pi i \varphi k)\ket{k}
\end{align*}

If we apply the inverse QFT we have
$$\ket{\phi_4} = \frac{1}{2^t} \sum_{k = 0}^{T-1} \sum _{l = 0}^{T-1} \exp\left(\frac{-2\pi i k l}{2^t}\right)\exp(2\pi i \varphi k) \ket{l}$$

If we reorganize terms we have that the amplitude of $\ket{(b+l) \mod T}$ is
$$\alpha_l = \frac{1}{2^t} \sum_{k = 0}^{T-1} \left(\exp\left(2 \pi i (\varphi - (b+l)/2^t)\right)\right)^k.$$

The sum is a geometric series, so we can give the following closed expression
\begin{align*}
\alpha_l & = \frac{1}{2^t} \frac{1 - \exp(2\pi i (\varphi T -(b+l)))}{1 - \exp(2\pi i (\varphi - (b+l)/T))} \\
 & = \frac{1}{2^t} \frac{1 - \exp(2\pi i (\delta T -l))}{1 - \exp(2\pi i (\delta - (b+l)/T))} \\
\end{align*}

We now check the probability of getting an n-bit approximation.
For that to occur, the maximum error between the measured result $m$ and the desired result $b$, must be lower than $e = 2^{t-n} -1 = 2^{n+2-n} -1 = 3$.

We bound the probability of having an error higher than this for a measured result $m$:
$$P[|m-b| > e] ) = \sum_{l = -2^{t-1} +1}^{-(e+1)} |\alpha_l|^2 + \sum_{l = e + 1}^{2^{t-1}} |\alpha_l|^2.$${#eq:qpebounda}

By the triangle inequality, if $\theta \in \RR$, $e^{i\theta} \in \mathbb{T}$, so $|1 - e^{i\theta}| \leq 2$,
so
$$|\alpha_l| \leq \frac{2}{2^t|1- \exp(2 \pi i(\delta - l/T))|}.$$

If $|\theta| \in [-\pi,\pi]$, then $|1 - e^{i\theta}| >2|\theta|/\pi$.
Let $\theta = 2 \pi (\delta - l/T)$.
$\theta \in [-\pi,\pi]$, since $|l| \leq 2^{t-1}$.
Therefore
$$|\alpha_l| \leq \frac{1}{2^{t+1}(\delta - l/T)}$${#eq:qpeboundb}

If we combine [@eq:qpebounda] and [@eq:qpeboundb], we have
$$P[|m-b| > e] \leq \frac14\left( \sum_{l = -2^{t-1} +1}^{-(e+1)} \frac{1}{(l-T\delta)^2} + \sum_{l = e + 1}^{2^{t-1}} \frac{1}{(l-T\delta)^2} \right).$$
Since $T\delta \in [0,1]$:
$$P[|m-b| > e] \leq \frac14\left(\sum_{l = -2^{t-1} +1}^{-(e+1)} \frac{1}{(l-1)^2} + \sum_{l = e + 1}^{2^{t-1}} \frac{1}{(l-1)^2} \right),$$
changing the indices and joining both sums,
$$P[|m-b| > e] \leq \frac12 \sum_{l = e}^{T-1} \frac{1}{l^2}.$$

Lastly, we bound this sum from above by the corresponding integral,
$$P[|m-b| > e] \leq \frac12\int_{e}^{T-1} \frac{\mathrm{d}l}{l^2} = \frac{1}{2(e-1)} = \frac14.$$

Hence the algorithm will be correct with probability at least $3/4 > 2/3$.
:::

### Quipper implementation

This algorithm is also implemented on the file `src/lib/Algorithms/QFT.hs`.
For the reverse Quantum Fourier Transform we use Quipper's `reverse_generic_endo`, which reverses a function with shape `f :: QShape qa ba ca => qa -> Circ qa`.

Having this, we need three elements for the quantum phase estimation algorithm:

1. A function `operator :: Int -> (qa -> Circ qa)` that gives us the powers of the unitary operator of which we want to calculate the eigenvalues,
2. The eigenvector, `eigv :: qa` (or superposition of eigenvectors if necessary),
3. the desired precision, `n :: Int`.

Given these arguments the function initializes the phase qubits to a uniform superposition, 
and applies the unitary operator raised to binary powers controlling on each qubit.
It then applies the reversed Quantum Fourier transform.
The complete code is available in the following snippet.

```haskell
estimatePhase
  :: (QData qa) => (Int -> (qa -> Circ qa)) -> qa -> Int -> Circ [Qubit]
estimatePhase operator eigv n = do
  phase <- qinit (replicate t False)
  phase <- map_hadamard phase
  eigv  <- forEach (numbered phase)
                   (\(i, q) qx -> operator (2 ^ i) qx `controlled` q)
                   eigv
  phase <- box "RQFT" reverseQft phase
  qdiscard eigv
  pure phase
  where t = n + 2
```

Here we have used the `forEach` combinator, that combines a number of monadic maps into a single one.
Its type signature is:
```haskell
forEach :: (Monad m) => [b] -> (b -> a -> m a) -> (a -> m a)
```

## Order finding

As a direct application of [@thm:phase] and as an intermediate step towards proving [@thm:shor], we prove that the order of an element in $U(\mathbb{Z}_N)$ can be calculated in polynomial quantum time, that is, we can solve the problem:

:::{.problem name="Order finding" #prob:order}
Calculate the order of an element $x$ in the group of units $U(\ZZ_N)$.

- **Input:** Two integers $x$ and $N$.
- **Promise:** $x \in U(\ZZ_N)$, that is, $0 < x < N$ and $\operatorname{gcd}(x,N) = 1$.
- **Output:** The order of $x$ as an element of $U(\ZZ_N)$, that is, the least integer $r$ such that $x^r = 1$ in $U(\ZZ_N)$.
:::

We show how to solve it by using [@algo:qpe].
Notice that if [@algo:qpe] is applied with a superposition of eigenvectors $\sum \alpha_i \ket{u_i}$ as inputs, the output will be a superposition of estimations of its eigenvalues, $\sum \alpha_i \ket{\overset{\sim}{\varphi_i}}$.
This fact will be later used again for solving the quantum counting problem.

For stating the theorem, we need to make use of the *continued fractions algorithm*.

:::{.definition}
Given a decimal number $\alpha \in \RR$ with $n$ bits, its *continued fraction* is a sequence $a_0, a_1, \dots$ such that $$\alpha = a_0 + \frac{1}{a_1 + \frac{1}{a_2 + \dots}}.$$

The $k$\textsuperscript{th} *convergent* of $\alpha$ is the rational number given by considering the first $k$ terms of $a_n$.
:::

If $\alpha$ is a whole number, then the sequence has length 1 and $a_0 = \alpha$.
Otherwise, we can find it recursively: $a_0 = \lfloor\alpha\rfloor$ and if $b_n$ is the continued fractions sequence for $1/(\alpha - a_0)$, then $a_n = b_{n-1}$.
This gives rise to a simple polynomial algorithm.

The following lemma will be needed for solving [@prob:order] and it is stated without proof.

:::{.lemma #lemma:continued}
(@NielsenQuantumComputationQuantum2010, thm. 5.1)

Let $p/q \in \mathbb{Q}$ and $\varphi \in \RR$ such that
$$|p/q - \varphi| \leq \frac{1}{2q^2}.$$
Then $p/q$ is a convergent of the continued fraction for $\varphi$.
:::

Given this lemma we can prove:

:::{.theorem #thm:order}
[@prob:order] is solvable in quantum polynomial time.
:::
:::{.proof}
Let us consider the unique unitary map $U$ that maps, for $j,k \in {0, \dots, N-1}$ (expressible in $n$ qubits each),
$$\ket{k} \mapsto \begin{cases}\ket{x^jk \mod N} & \text{ if } k \leq N \\ \ket{k} & \text{ otherwise.}\end{cases}$$
This map is efficiently computable for powers $2^j$ via binary exponentiation.
It is unitary since $x$ and $N$ are coprime.

Let $r = \operatorname{ord}_{\ZZ_N}(x)$ and $s \in \{0,\dots,r-1\}$.
Let $$\ket{u_s} = \frac{1}{\sqrt{r}} \sum_{k=0}^{r-1} \exp\left(-2\pi i k \frac{s}{r}\right)\ket{x^k \mod N}.$$

For all $s \in \{0,\dots,r-1\}$, $\ket{u_s}$ is an eigenvector of $U$ since 
\begin{align*}
U\ket{u_s} & = \frac{1}{\sqrt{r}}\sum_{k = 0}^{r-1} \exp\left(-2\pi i k \frac{s}{r}\right)\ket{x^{k+1} \mod N} \\
& = \exp\left(2\pi i \frac{s}{r}\right) \ket{u_s}.\end{align*}
The phase is thus $s/r$.

Furthermore, consider that
\begin{align*}
\frac{1}{\sqrt{r}} \sum_{s=0}^{r-1}\ket{u_s} & = \frac{1}{r} \sum_{s= 0}^{r-1} \sum_{k=0}^{r-1} \exp\left(-2\pi i k \frac{s}{r}\right)\ket{x^k \mod N} \\
& = \frac{1}{r} \sum_{k=0}^{r-1} \left(\sum_{s= 0}^{r-1} \exp\left(-2\pi i k \frac{s}{r}\right)\right)\ket{x^k \mod N} = \frac{1}{r} \sum_{k=0}^{r-1} r \delta_{k0} \ket{x^k \mod N} \\
& = \ket{x^0 \mod N} = \ket{0 \dots 01}
\end{align*}

Consider applying [@algo:qpe] with unitary map $U$ and eigenvector $\ket{0 \dots 0 1}$.
Clearly, the output will be an approximation of the phase of one of the eigenvalues of some $\ket{u_s}$.

Hence, the output will be an approximation of $\frac{s}{r}.$
If the approximation is accurate enough, the period $r$ can be recovered from the decimal expression of this fraction by using [@lemma:continued].
:::

### Quipper implementation
#### Modular exponentiation and oracle

Binary exponentiation is needed for both calculating factors and for creating the oracle circuit used by the quantum phase estimation algorithm.
The Haskell code for binary exponentiation is
```haskell
binaryExp :: Integer -> Integer -> Integer -> Integer
binaryExp x 0 m = 1
binaryExp x a m = binaryExp (x ^ 2 `mod` m) q m `mod` m * (x `mod` m) ^ r
  where (q, r) = a `divMod` 2
```
where `binaryExp x a m` computes $x^a \mod m$.
The function `divMod` returns the quotient and remainder of a given number.

For the quantum oracle we use the `QuipperLib.Arith` module, that defines a series of integer types usable in the quantum setting.
These are `IntM` for parameters and `QDInt` for quantum integers.
We define the function `quantumOp x n j` that returns a circuit that maps
$$\ket{\mathtt{y}} \mapsto \ket{\mathtt{x}^\mathtt{j}\mathtt{y} \mod \mathtt{n}}.$$

The code is as follows:
```haskell
quantumOp :: Integer -> Integer -> Integer -> QDInt -> Circ QDInt
quantumOp x n j y = do
  (y,z) <- q_mult_param a y -- x^n mod n * y
  q_n <- qinit (fromIntegral n) -- q_n
  (z, q_n, res) <- q_mod_unsigned z q_n
  pure res -- x^n*y mod n
  where
    a :: IntM
    a = fromIntegral $ binaryExp x j n
```
We first calculate $\mathtt{x}^\mathtt{j} \mod \mathtt{n}$ using the `binaryExp` function.
We then multiply `y` by this using `q_mult_param` (quantum multiplication with classical parameter).

Then we apply the modulus `n` again using `q_mod_unsigned` (for which we need to transform `n` into a quantum integer `q_n`).

#### Order finding algorithm

First, we estimate the phase by simply applying the phase estimation algorithm.

```haskell
getOrder :: Integer -> Integer -> Circ [Qubit]
getOrder x n = do
  eigv <- qinit 1
  estimatePhase (quantumOp x n) eigv (2 + ceiling (logBase 2 (fromIntegral n)))
```

We then would have to calculate the convergents of the phase until we find one that has as its denominator the phase that we are looking for. For this we need to implement the continued fractions algorithm, which is straightforward, and then calculate each convergent. This is available at the `src/lib/Floating.hs` module.
What remains is classically recovering the divisor from its order if possible.

This algorithm can't be feasibly executed since it takes too much time.
Therefore, only the circuit is generated.

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
We may then compute it using the well-known Euclidean algorithm, which has the desired complexity.
:::

[@lemma:solution] hints at the reduction used by Shor's algorithm: if we can find a non-trivial solution to 
$$x^2 \equiv_N 1,$${#eq:shor}
then we can find a non-trivial divisor of $N$.

In particular, suppose we have $a \in \ZZ_N$, we compute its order using [@thm:order] and it turns out to be even.
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
For the remaining case, that is, $N = a^b$, with $a \geq 1, b \geq 2$, we may approximate $\sqrt[b]{N}$ for every $b \in \{2,\dots \lceil \log N\rceil\}$ and check whether it is an integer.

Hence, Shor's algorithm is complete and is presented at [@algo:shor].

:::{.algorithm name="Shor's algorithm" #algo:shor}
(@NielsenQuantumComputationQuantum2010, sec. 5.3)

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
For finding *all* factors of a given number we may repeat [@algo:shor] and successively divide the integer until we reach a base case. This would also take a polynomial amount of time, $O(\log^4 N)$.


### Implementation

The complete algorithm for factorization is available in the attached code at the file `src/lib/Algorithms/Shor.hs`. First, we define a datatype that deals with the possible modes of failure of the algorithm, indicating whether the integer is one (`One`), a prime number (`Prime`), a bad order was found (`BadOrder`) or any other case of failure of the intermediate algorithms (`Other`).

```haskell
data Failure = One
             | Prime
             | BadOrder Integer Integer
             | Other
```

#### Power of a number

First, we look at the case where $N = a^b$.
For this we define the function `getPower`, given by the following (simplified[^simplification]) code snippet

```haskell
getPower :: Integer -> Either Failure Integer
getPower n = base <$> exponent
 where
  a :: Double
  -- We check every possible root up to `a`
  a = ceiling $ logBase 2 n'

  base :: Double -> Double
  -- The base for a given exponent
  base x = round (n' ** (1 / x))

  exponents :: [Double]
  -- List of possible exponents, from biggest to smallest
  exponents = filter (\x -> n == round ((base x) ** x)) [a, a - 1 .. 2]

  exponent :: Either Failure Double
  exponent = if null exponents then Left Other else Right (head exponents)
```

[^simplification]: Explicit management of numeric types conversion has been omitted from this and the following snippets. The complete code can be checked in the attached files

We first calculate a list of possible `exponents`.
They can range from $2$ to $a = \lceil \log_2 N \rceil$.
We filter those that give that are true roots up to the rounding error given by the square root algorithm, 
and finally get the first of them in `exponent`.

We then calculate that square root (the `base` for the chosen `exponent`) and return it.

#### Main factorization function

The main factorization function, `factor`, takes an integer and returns a valid factor.
It distinguishes several cases.
It is an IO function since we need to make use of randomness.

```haskell
factor :: Integer -> IO (Either Failure Integer)
factor n
  | n < 0 = pure $ Right (-1)
  | n == 1 = pure $ Left One
  | isPrime n = pure $ Left Prime
  | n `mod` 2 == 0 = pure $ Right 2
  | isRight root = pure root
  | otherwise = do
    x <- randomRIO (1, n - 1)
    if gcd x n > 1 then pure (Right (gcd x n)) else factorFromOrder x n
  where root = getPower n
```

The different cases are

1. The integer is negative, then we return -1.
2. The integer is 1 or it is prime. We return the corresponding failure code.
   The prime factorization is done using a Haskell library that implements the Baille-PSW primality test 
   (@Pomerancepseudoprimes25101980).
3. The integer is even, we then return 2.
4. The integer is of the form $N = a^b$, checked by the implemented algorithm in the previous section.

Otherwise, we follow the algorithm and apply the quantum case that has previously been described.
For the full factorization, we would apply a recursive algorithm that factors each number until we get to a base case: either the number is one or it is prime.

This algorithm is not feasibly executable in practice because of the number of qubits needed in the quantum estimation phase, thus an assesment is made as to what the procedure would be and what amount of resources would be needed for calculating the factors of a number in this way.
This assesment can be seen  by running the `quantum` executable in mode `shor`.
