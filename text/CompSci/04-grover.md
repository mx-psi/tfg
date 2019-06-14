# Grover's algorithm

In this section we present *Grover's algorithm*, a quantum algorithm that can be used to solve search and minimization problems, providing polynomial speedup in the query complexity setting with respect to the best possible classical algorithm.

The chapter is organized as follows: first we present the general problem Grover's algorithm attempts to solve and why it can be potentially useful.

Then, we describe the classical algorithm and the quantum Grover's algorithm with a known number of solutions.
Finally, we show how to obtain the number of solutions and prove that it is asymptotically optimal in the query complexity setting.

## Search problems

The general problem Grover's algorithm attempts to solve is a *search problem*.
It is a very general problem with many potential applications.

:::{.problem name="Search" #prob:search}

Search a string that has a certain property.

- **Input:**  A function $f:\BB^n \to \BB$.
- **Promise:** There is at least one solution to the equation $f(x) = 1$.
- **Output:** A string $x$ such that $f(x) = 1$.
:::

As a possible application, consider a language $L \in \mathsf{NP}$, and fix a word $x \in \BB^n$ (if we allow randomness, we can consider $L \in \mathsf{MA}$ and proceed similarly).

Recalling [@prop:npverifier] consider as $f : \BB^{p(n)} \to \BB$ the function associated with the verifier $V$.
Then, if we have an algorithm to solve the search problem we can decide whether $x \in L$ or not.
Given the wide variety of problems of practical usefulness in $\mathsf{NP}$ (@AroraComputationalComplexityModern2009, chap. 2), this is an important and useful application of such problem.

As a more practical application, one can consider a search on a database.
In this case the function would indicate whether there has been a match or not for each item in the database.
Notice that we allow for potentially more than one matching string.

## The classical case

In the query complexity setting we are not interested in the time it takes to compute $f$ but rather in the number of queries necessary to provide an answer. 

In the classical case, there is a trivial algorithm that provides an answer: simply check for every possible input until a match is found. The query complexity of this algorithm is $O(N) = O(2^n)$.

Even if $f$ takes unit time to compute, this algorithm is not efficient for solving the search problem associated with an $\mathsf{NP}$ language since it would take at least exponential time on the size of word being decided.

Furthermore, this algorithm is clearly optimal in the classical setting: in the worst case the last inputs checked are the matching ones and thus $\Omega(N)$ queries are needed.

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
   $$\ket{x} \mapsto -\ket{x} \text{ if } x \neq 0, \quad \ket{0} \mapsto \ket{0},$$
3. apply the Hadamard transform again to each qubit.
:::

It can be done with a linear number of gates; a circuit performing the diffusion operator for $n = 3$ qubits can be seen in [@fig:diffusion].

![Diffusion operator for $n =  3$ qubits. The "Z" gate is the phase change gate for an angle of $\theta = \pi$.](assets/diffusion.pdf){#fig:diffusion width=100%}

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

:::{.lemma #lemma:geogrover}
Let $f : \BB^n \to \BB$ and $M = |f^{-1}(1)|$.

Let $\ket{\psi}$ be a uniform superposition, that is,
$$\ket{\psi} = H^{\otimes n}\ket{0}^{\otimes n} = \frac{1}{\sqrt{N}}\sum_{y \in \BB^n} \ket{y}$$
and $\ket{\beta}$ be the uniform superposition of solutions to the equation $f(x) = 1$, that is
$$\ket{\beta} = \frac{1}{\sqrt{M}} \sum_{x \in f^{-1}(1)} \ket{x}.$$

The restriction of Grover's operator to the subspace spanned by $\ket{\psi}$ and $\ket{\beta}$ is a rotation, whose angle $\theta$ verifies $$\cos \frac{\theta}{2} = \sqrt{\frac{N-M}{N}}.$$
:::
:::{.proof}

The subspace spanned by $\ket{\psi}$ and $\ket{\beta}$ can be given by the orthonormal basis $\{\ket{\alpha}, \ket{\beta}\}$, where $\ket{\alpha}$ is the uniform superposition of those vectors that are not a solution to $f(x) = 1$,
$$\ket{\alpha} =  \frac{1}{\sqrt{N-M}} \sum_{x \in f^{-1}(0)} \ket{x}.$$

In particular, expressed in terms of the basis we have
$$\ket{\psi} = \sqrt{\frac{N-M}{N}}\ket{\alpha} + \sqrt{\frac{M}{N}}\ket{\beta}.$$

The restriction of $G_f$ to $\operatorname{Lin}(\ket{\alpha},\ket{\beta})$ is composed by two reflections

1. $U_f$ is a reflection about $\ket{\alpha}$, since 
  $$U_f(a\ket{\alpha} + b \ket{\beta}) = a \ket{\alpha} - b \ket{\beta}.$$
2. The diffusion operator is an operator of the form $D_n = H^{\otimes n} O H^{\otimes n}$, where the phase shift $O$ is a reflection about the vector $\ket{0}^{\otimes n}$. Thus, we can easily check that since $H^{\otimes n}$ is its own inverse, $D_n$ is a reflection about the vector $\ket{\psi} = H^{\otimes n}\ket{0}^{\otimes n}$.

The composition of two reflections is a rotation, and the angle of rotation $\theta$ will be twice the one between the vectors that give rise to the reflections, $\ket{\psi}$ and $\ket{\alpha}$.
Hence, we have 
$$\cos \frac{\theta}{2} = \bk{\psi}{\alpha} = \sqrt{\frac{N-M}{N}}.$$
:::

This gives us a rough idea of the algorithm that we can follow to get a possible answer: rotate some vector in the plane so as to minimize its distance from $\ket{\beta}$ and measure the result.
This idea is formalized in [@algo:grover].
We assume the number of solutions is known in advance.

:::{.algorithm name="Grover's algorithm" #algo:grover}
(@Kayeintroductionquantumcomputing2007, sec 8.1)

**Solves:** The search problem, [@prob:search], given the number of solutions $M = |f^{-1}(1)|$.

1. Pick a random solution and check whether it is a match. If so, output and stop.
1. Initialize an $n$ qubit register to $\ket{0 \dots 0}$ and a last qubit to $\ket{1}$.
2. Apply the $H$ gate to each qubit to obtain an uniform state in the first $n$ qubits, $\ket{\psi}$ and the state $\ket{\downarrow} = (\ket{0}-\ket{1})/\sqrt{2}$ in the last one.
3. Apply $T = \lfloor \frac{\pi}{4} \sqrt{\frac{N}{M}} \rfloor$ times Grover's operator $G_f$.
4. Measure the $n$ qubit register and output the result.
:::

A schematic for Grover's algorithm can be seen in [@fig:grover].

![A circuit for Grover's algorithm with $n = 5$ input qubits, $T = 4$ repetitions (the optimal number is 1)](assets/grover.pdf){#fig:grover width=100%}

Lastly, we prove that Grover's algorithm outputs the correct answer with bounded error.

:::{.theorem name="Correctness of Grover's algorithm"}
(@Kayeintroductionquantumcomputing2007, sec. 8.1)

Let $f: \BB^n \to \BB$ be a function such that $f$ is not constantly zero.
Then [@algo:grover] succeeds with bounded error.
:::
:::{.proof}
The proof is adapted from (@Kayeintroductionquantumcomputing2007, sec. 8.1).

Let $M = |f^{-1}(1)|$. 
If $M \geq N/2$ then the probability of getting a match on the first step is over one half.
Assume for the remainder of the proof that $M < N/2$.

Since the last qubit remains unaltered after step 1, we focus on the $n$ qubit register only.
Using the expression of $\ket{\psi}$ in the proof of [@lemma:geogrover], we can see that 
$$\ket{\psi} = \cos \frac{\theta}{2} \ket{\alpha} + \sin \frac{\theta}{2}\ket{\beta},$$
hence by [@lemma:geogrover] we have that 
$$G^k\ket{\psi} = \cos\left(\frac{2k + 1}{2}\theta\right)\ket{\alpha} + \sin\left(\frac{2k +1}{2}\theta\right)\ket{\beta}.$$

To get a probability of success close to one, we would like $\sin\left(\frac{2k +1}{2}\theta\right) \approx 1$,
thus we should have $\frac{2k +1}{2}\theta \approx \pi/2$.

For a real $k'$ picking 
$$k' = \frac{\pi}{2\theta} - \frac12$$
would get us the exact result.

By [@lemma:geogrover], we now that 
$$\theta = 2\arcsin \left(\sqrt{\frac{M}{N}}\right) \approx 2\sqrt{\frac{N}{M}},$$
where the error of the approximation is under one half since $M < N/2$.

Thus, if we pick 
$$k = \left\lfloor \frac{\pi}{4}\sqrt{\frac{M}{N}} \right\rfloor$$
we have $k -k' \leq 1/2$ and therefore 
$$\frac{2k+1}{2}\theta = \frac{\pi}{2} + \varepsilon, \text{ where } \varepsilon  \in O\left(\frac{1}{\sqrt{N}}\right)$$
thus $\sin(\frac{\pi}{2} + \varepsilon) = \cos(\varepsilon) \geq 1 - \frac{\varepsilon^2}{2} = 1 - O\left(\frac{1}{N}\right)$. where we have used the second order approximation of the cosine by its Taylor series.
:::

### Quipper implementation

Grover's algorithm is implemented on `src/lib/Algorithms/Grover.hs`.
It can be run by using the `grover` subcommand on the `quantum` binary in the attached code.

First, we need to define the diffusion operator.
For this we first define the phase shift, that negates all qubits, applies a $\pi$ conditional rotation to one of them, and negates all qubits again.

```haskell
phaseShift :: [Qubit] -> Circ [Qubit]
phaseShift (x:xs) = do
  x:xs <- mapUnary qnot (x : xs)
  x    <- gate_Z x `controlled` xs
  mapUnary qnot (x : xs)
```
The `controlled` operator can make an operation controlled on a list of qubits.


The diffusion operator is then defined by composing this monadic function with the monadic functions `map_hadamard`, that apply the Hadamard gate to each qubit.
```haskell
diffusion :: [Qubit] -> Circ [Qubit]
diffusion = map_hadamard >=> phaseShift >=> map_hadamard
```

This allows us to define Grover's operator for a given oracle.
We define it by composing the oracle's circuit with the diffusion operator, taking care to leave the lower qubit (the one that has state $\ket{\downarrow}$) unchanged.
```haskell
groverOperator :: Oracle [Qubit] -> ([Qubit], Qubit) -> Circ ([Qubit], Qubit)
groverOperator oracle (xs, y) = do
  (xs, y) <- circuit oracle (xs, y)
  xs      <- diffusion xs
  pure (xs, y)
```

Finally, this allows us to define Grover's algorithm for a given number of solutions.
For this we need the function `timesM`, defined in module `src/lib/Utils.hs`, that allows us to raise a monadic function to a certain power (effectively working as a loop with a fixed number of iterations).

```haskell
grover :: Int -> Oracle [Qubit] -> Circ [Bit]
grover m oracle = do
  (x, y) <- qinit (qc_false (shape oracle), True)
  (x, y) <- map_hadamard (x, y)
  (x, y) <- n `timesM` box "Grover's operator" (groverOperator oracle) $ (x, y)
  qdiscard y
  measure x
  where n :: Int
        n = round $ pi / 4 * sqrt $ inputSize oracle / fromIntegral m
```

As we see, we first initialize the `x` register to a uniform superposition and the `y` register to state $\ket{\downarrow}$.
We then apply Grover's operator a number of times given by the previously calculated formula,
and, discard the auxiliary qubit `y` and finally we measure the bits to get an answer.
To boost the probability of correctness, we run the algorithm a fixed number of times.

## Quantum counting

[@algo:grover] requires the number of solutions to be known in advance.
Furthermore, we need to check the promise that the number of solutions is non-zero.
Therefore, we need to solve the following problem.

:::{.problem name="Counting" #prob:counting}
Count the number of solutions to an equation.

- **Input**: A function $f : \BB^n \to \BB$
- **Output**: $M = |f^{-1}(1)|$
:::

The answer to solving it lies in using of the quantum phase estimation algorithm, [@algo:qpe].

The geometrical characterization given by [@lemma:geogrover] tells us that Grover's operator is a rotation of an angle $\theta/2$ such that $$\sin^2\left(\frac{\theta}{2}\right) = \frac{M}{N}.$${#eq:count}
Thus, if we can estimate the angle, then, since $N$ is known, we may estimate $M$.

It is easy to check that the eigenvalues of the matrix are $\exp(\pm i\theta/2)$ corresponding to eigenvectors that add up to the uniform superposition, $\ket{\psi}$ (@Kayeintroductionquantumcomputing2007, sec. 8.3).

Thus, by applying [@algo:qpe] with enough accuracy, we can estimate either $\theta/2$ or $2 \pi - \theta/2$, which is enough to estimate $\theta$ and thus $M$.

It turns out that $O(\sqrt{N})$ queries are enough to obtain an exact estimate.
A lower accuracy might be used if we just want to check if $M > 0$, though it is asymptotically equivalent (@NielsenQuantumComputationQuantum2010, sec. 6.3).
We present the algorithm from (@Kayeintroductionquantumcomputing2007), but omit the details of the accuracy estimates.

:::{.algorithm name="Quantum counting" #algo:counting}
(@Kayeintroductionquantumcomputing2007, Exact Counting)

- **Solves:** [@prob:counting]

1. Run [@algo:qpe] twice with $\ket{\psi}$ as the eigenvector and $t = \lceil n/2 \rceil + 6$ qubits of precision.
   Call the resulting estimates $M_1, M_2$.
2. Run [@algo:qpe] again with $t = \log_2\left(M\right)$, where 
  $$M = \min\left(\left\lceil 30 \sqrt{(NM_1 +1)(N-NM_1 +1)}\right\rceil, \left\lceil 30 \sqrt{(NM_2 +1)(N-NM_2 +1)}\right\rceil\right)$$
  and return the estimate.
:::

Combining [@algo:grover] and [@algo:counting] gives us and algorithm that solves [@prob:search] using $O(\sqrt{N})$ queries, which is better than any classical or randomized algorithm.


### Quipper implementation

The quantum counting and quantum existence algorithms have been implemented on Quipper.
The latter can be executed by running the subcommand `existence` of the `quantum` binary.
Both are available at `src/lib/Algorithms/Count.hs`.

The quantum counting algorithm needs to much precision for it to be feasibly simulated on a laptop, therefore the code is shown for illustrative purposes and to create diagrams.
Its code is a simple application of the quantum phase estimation algorithm with Grover's operator.

```haskell
quantumCount :: Oracle [Qubit] -> Int -> Circ [Qubit]
quantumCount oracle t = do
  eigv <- qinit (qc_false (shape oracle), True)
  eigv <- map_hadamard eigv
  estimatePhase (`timesM` groverOperator oracle) eigv t
```

Given this phase, we estimate the number of solutions by transforming this phase using [@eq:count].
The following simplified snippet presents the algorithm:
```haskell
phaseToNum :: Oracle [Qubit] -> Int -> IO Int
phaseToNum oracle t = do
  bits <- run_generic_io (0 :: Double) (quantumCount oracle t)
  let phi = bitsToFloating bits
  let theta = if phi <= 0.5 then 2 * pi * phi else 2 * pi * (1 - phi)
  pure $ ceiling (n * sin theta ^^ 2)
 where n = inputSize oracle
```
Checking whether the estimated phase $\varphi$ is above or below $\frac12$ tells us whether the positive or negative eigenvalue was estimated, and thus allows for the recovery of the number of solutions.
The quantum existence algorithm then uses `phaseToNum` to see whether it is positive or zero.

## Optimality

In the case of solving an $\mathsf{NP}$ problem, Grover's algorithm gives us at most a quadratic speedup replacing a query complexity of $O(2^n)$ to one of $O(\sqrt{2^n}) = O(2^{n/2})$.
This is an insufficient speedup from a practical point of view, since it still leaves us with an (at least) exponential run-time. Is there any possible improvement of this technique?

The following result proves that in the query complexity model Grover's algorithm is asymptotically optimal, meaning that any other algorithm that solves the search problem will have to make $\Omega(\sqrt{N})$ queries.
This does not prove of course that $\mathsf{NP} \not\subseteq \mathsf{BQP}$ or any other similar result.
It does however show that the general task of solving $\mathsf{NP}$ problems or other search problems with an exponential search space must be attacked by using the inner structure of the problem, since any algorithm that does not do so would have a running time in $\Omega(\sqrt{N})$.

:::{.theorem name="Grover's optimality"}
[@algo:grover] is asymptotically optimal in the query complexity setting; any quantum algorithm that solves [@prob:search] needs $\Omega(\sqrt{N})$ queries to do so with bounded error.
:::
:::::{.proof}

We present the proof for the case where there is exactly one matching string from (@NielsenQuantumComputationQuantum2010, sec. 6.6).
The result can be generalized to the case where there are several matches.

Let $U_x$ be the oracle for the function $$f(y) = \begin{cases}1 & \text{ if } y = x \\ 0 & \text{ otherwise.}\end{cases}$$

Any circuit $C_n$ within a quantum algorithm $\{C_n\}$ can be represented as a sequence of unitary operators 
$$U_x, A_1, \dots, A_{k-1}, U_x, A_k,$$
together with a starting state $\ket{\psi_0}$.
We are assuming that the quantum algorithm applies the oracle exactly $k$ times.

Let
$$\ket{\psi^x_k} = A_k U_x \dots A_1 U_1\ket{\psi_0} \text{ and }$$
$$\ket{\phi_k} = A_k \dots A_1 \ket{\psi_0}.$$

Define the *deviation after $k$ steps* as 
$$D_k = \sum_{x \in \BB^n} \norm{\ket{\psi^x_k}- \ket{\phi_k}}^2.$$
This number measures the difference that applying the oracle $k$ times produces.

We now prove two claims that will lead us to the result.
First, the deviation is $O(k^2)$.

:::{.claim}
For all $k \in \NN$, $D_k \leq 4k^2$.
:::
:::{.proof}
The proof is by induction.

Clearly, for $k = 0$, $D_k = 0$.

Let $k \in \NN$. Then
$$\norm{U_x \ket{\psi^x_k} - \ket{\phi_k}}^2 = \norm{U_x(\psi^x_k - \phi_k) + (U_x - I_N)\phi_k}^2 = \norm{U_x(\psi^x_k - \phi_k) -2\bk{x}{\phi_x}\ket{x}}^2.$$
If we apply $\norm{u+v}^2 \leq \norm{u}^2 + 2\norm{u}\norm{v} + \norm{v}^2$, and add up for all $x$, we have
$$D_{k+1} \leq \sum_{x \in \BB^n} \norm{\psi_k^x - \phi_k}^2 + 4 \norm{\psi_k^x - \phi_k}|\bk{x}{\psi_k}| + 4 |\bk{x}{\psi_k}|^2.$$

We now apply the Cauchy-Schwarz inequality, obtaining
$$D_{k+1} \leq D_k + 4 \sqrt{\sum_{x \in \BB^n}  \norm{\psi_k^x - \phi_k}^2 }\sqrt{\sum_{x \in \BB^n} |\bk{x}{\phi_k}|^2} + 4.$$

Since $\ket{\phi_k}$ is unitary, $\sum_{x \in \BB^n} |\bk{x}{\phi_k}|^2 = 1$, and thus we can rewrite
$$D_{k+1} \leq D_k + 4 \sqrt{D_k} + 4.$$

By induction,
$$D_{k+1} \leq 4k^2 + 8k + 4 = 4(k+1)^2.$$
:::

And secondly, if the algorithm outputs the correct answer with probability at least $1/2$, then the deviation must be $\Omega(N)$.

:::{.claim}
Suppose $|\bk{x}{\psi^x_k}|^2 \geq \frac12$ for all $x \in \BB^n$.

Then $D_k \geq cN$ for any $c < (\sqrt{2} - \sqrt{2 - \sqrt{2}})^2$.
:::
:::{.proof}
Let
$$E_k = \sum_{x \in \BB^n} \norm{\psi^x_k - x}^2 \text{ and } F_k = \sum_{x \in \BB^n} \norm{\phi_k - x}^2.$$

We may multiply $\ket{x}$ by a certain constant so that $\bk{x}{\psi^x_k} = |\bk{x}{\psi^x_k}|$.
If we do so we have
$$\norm{\ket{\psi^x_k} - \ket{x}}^2 = \bk{\psi^x_k}{\psi^x_k} + \bk{x}{x} -2\bk{\psi^x_k}{x} = 2 - 2|\bk{\psi^x_k}{x}| \leq 2 - \sqrt{2},$$
hence $E_k \leq (2-\sqrt{2})N$.
Furthermore, by applying the Cauchy-Schwarz inequality we have $F_k \geq 2N - 2\sqrt{N}$.

We then have, applying $\norm{u+v}^2 \geq \norm{u}^2 + \norm{v}^2 - 2\norm{u}\norm{v}$ and the Cauchy-Schwarz inequality,
\begin{align*}
  D_k & = \sum_{x \in \BB^n} \norm{(\psi^x_k - x) + (x-\phi_k)} \\
      & \geq \sum_{x \in \BB^n} \norm{\psi^x_k - x}^2 + \sum_{x \in \BB^n} \norm{\phi_k - x}^2 -2 \sum_{x \in \BB^n} \norm{\psi^x_k - x}\norm{\phi_k - x} \\
      &  \geq E_k + F_k - 2\sqrt{E_kF_k} \\
      & = (\sqrt{F_k} - \sqrt{E_k})^2 \\
      & \geq \left(\sqrt{2}-\sqrt{2-\sqrt{2}}\right)N
\end{align*}
:::


Combining the previous claims we have $$k \geq \sqrt{\frac{\left(\sqrt{2}-\sqrt{2-\sqrt{2}}\right)N}{4}},$$
and hence any algorithm must take $\Omega(\sqrt{N})$ steps.
:::::




