# The Deutsch-Jozsa algorithm

In this chapter we develop our first example of a quantum algorithm.
The first section presents the setting in which the complexity of this and later algorithms will be analyzed, and the following section presents the solution.

## The query complexity model

The focus of the previous sections on computation models was on time complexity.
These are the most meaningful practical measures of complexity; however, they are notoriously difficult to analyze, as the wide range of existing open problems in the field shows (@AaronsonmathoplimitsNP2016).

In the analysis of the algorithms that will be presented we will sometimes focus on an alternative complexity measure: *query complexity*, also known in the classical case as *decision tree complexity* (@AmbainisUnderstandingQuantumAlgorithms2017, sec. 2).

In the quantum case, we are given an *oracle* (or, more generally, a family of oracles) that gives us information about a certain binary string $x \in \BB^N$ (@Kayeintroductionquantumcomputing2007, sec 9.2).
Similar to the approach for [simulating classical operations](#simulating-classical-operations), we can have a unitary operation that maps $$\ket{j}\ket{y} \mapsto \ket{j}\ket{y \oplus x_j}.$$

We would then like to compute some property about the oracle; the question then becomes: 
how many *queries* have to be made to the oracle in order to compute such property with bounded error?

That is we say that a quantum algorithm $\{C_N\}_{}$ (with respect to any set of gates that includes the quantum oracle) that computes a certain function $f: \BB^\ast \to \BB^\ast$ (with bounded error) has query complexity $O(T(N))$ if the function that for each $N$ counts the number of oracle gates in $C_N$ is $O(T(N))$.

An alternative way of presenting query complexity is to talk about a function $f:\BB^n \to \BB$ that outputs $f(j) = x_j$ (where $j$ is passed as a binary string). We note that $N = 2^n$, and thus in this approach the query complexity would be $O(T(2^n))$.

Query complexity then gives a lower bound estimate of the actual time complexity; since we would have to add in the non-query gates as well as the amount of gates needed to simulate the oracle.

## Deutsch's problem 

The Deutsch-Jozsa algorithm is one of the first quantum algorithms that provide some quantum speedup in the query complexity model.
It was first proposed in 1992 [@CleveQuantumAlgorithmsRevisited1998].
It will serve as a first approximation to a concrete algorithm, although it is of little practical value.

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
is its "bit-wise inner product" in $\ZZ_2$.
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

In particular, we can obtain an uniform superposition of all possible $n$ bit strings by using [@lemma:hadamard],
$$H^{\otimes n}\ket{0}^{\otimes n} = \frac{1}{\sqrt{2^n}}\sum_{y \in \BB^n} (-1)^{0 \odot y}\ket{y} = \frac{1}{\sqrt{2^n}}\sum_{y \in \BB^n} \ket{y}.$$

Another simple lemma that will be useful later is

:::{.lemma #lemma:signchange}
Let $f: \BB^n \to \BB$ be a function and $U_f: Q^{\otimes n+1} \to Q^{\otimes n+1}$ be the reversible function associated with $f$, that is, 
$$U_f\ket{x}\ket{y} = \ket{x}\ket{y \oplus f(x)}.$$

Let $$\ket{\downarrow} = \frac{1}{\sqrt{2}}\left(\ket{0} - \ket{1}\right).$$
Then $$U_f\ket{x}\ket{\downarrow} = (-1)^{f(x)}\ket{x}\ket{\downarrow}.$$
:::
:::{.proof}
Clearly, 
$$U_f\ket{x}\ket{\downarrow} =\frac{1}{\sqrt{2}}(\ket{x}\ket{f(x)} - \ket{x}\ket{1 \oplus f(x)}).$$

If $f(x) = 0$ then 
$$\ket{x}\ket{f(x)} - \ket{x}\ket{1 \oplus f(x)} = \ket{x}\ket{0} - \ket{x}\ket{1} = \ket{x}\otimes(\ket{0} - \ket{1}).$$
Similarly, if $f(x) = 1$,
$$\ket{x}\ket{f(x)} - \ket{x}\ket{1 \oplus f(x)} = \ket{x}\ket{1} - \ket{x}\ket{0} = -\ket{x}\otimes(\ket{0} - \ket{1}).$$
:::

Next, consider the following algorithm:

:::{.algorithm name="Deutsch-Jozsa algorithm" #algo:deutsch}
(@NielsenQuantumComputationQuantum2010, sec. 1.4.4)

**Solves:** [@prob:deutsch].

1. Initialize $n$ qubits to $\ket{0}$ and an extra qubit to $\ket{1}$.
2. Apply Hadamard gates to each qubit.
3. Apply the oracle for $f$ to the whole state.
4. Apply Hadamard transform to the first $n$ qubits.
5. Discard the last qubit and measure the first $n$ qubits.
6. Output the logical OR of the measured bits.
:::

An example of the algorithm for $n=2$ can be seen in [@fig:deutsch].

![Deutsch-Jozsa algorithm for a function $f:\BB^3 \to \BB$](assets/deutsch.pdf){#fig:deutsch width=100%}


:::{.proposition name="Correctness of Deutsch-Jozsa algorithm"}
(@NielsenQuantumComputationQuantum2010, sec. 1.4.4)

Let $f:\BB^n \to \BB$ be a constant or balanced function.
Then [@algo:deutsch] output is non-zero if and only if $f$ is balanced.
:::
:::{.proof}

Let $\ket{\phi_j}$ be the state at step $j$.

By construction, 
$$\ket{\phi_1} = \ket{0}^{\otimes n}\ket{1}.$$

Applying Hadamard gates to each qubit gives us
$$\ket{\phi_2} = H^{\otimes n}\ket{0}^{\otimes n}H\ket{1} = \left(\frac{1}{\sqrt{2^n}}\sum_{y \in \BB^n} \ket{y}\right)\otimes \frac{1}{\sqrt{2}}\left(\ket{0} - \ket{1}\right).$$

We now apply $f$'s oracle and by [@lemma:signchange] we have
$$\ket{\phi_3} = \frac{1}{2^n}\sum_{y \in \BB^n} (-1)^{f(y)}\ket{y}\otimes \frac{1}{\sqrt{2}}\left(\ket{0} - \ket{1}\right).$$

By [@lemma:hadamard] we see that
$$\ket{\phi_4} = \frac{1}{2^n}\left(\sum_{z \in \BB^n} \sum_{y \in \BB^n} (-1)^{y \odot z + f(y)}\ket{z}\right)\otimes \frac{1}{\sqrt{2}}\left(\ket{0} - \ket{1}\right).$$

Ignore the last qubit and consider the probability of measuring $\ket{0}^{\otimes n}$ at step 5.
Its probability is given by 
$$\left|\frac{1}{2^n}\sum_{y \in \BB^n} (-1)^{f(y)}\right|^2.$$

If $f$ is constant, then this probability is exactly $1$, and the logical OR will give us $0$.
If $f$ is balanced, then 
$$\sum_{y \in \BB^n} (-1)^{f(y)} = \sum_{y \in f^{-1}(0)} (-1)^0 + \sum_{y \in f^{-1}(1)} (-1)^1 = 0.$$
Hence, at least one of the measured bits will be $1$ and the output will be $1$.
:::

In contrast with the deterministic case, [@algo:deutsch] solves [@prob:deutsch] in one query,
thus we can obtain a provable speedup from $O(N)$ to $O(1)$.

Although this is a non-negligible improvement, the speedup vanishes when randomness is allowed.
Consider an algorithm that uniformly samples two different strings $x_1, x_2$ from $\BB^n$ and outputs constant if $f(x_1) = f(x_2)$ or balanced otherwise.

If $f$ is constant, then the algorithm always outputs the correct answer.
If $f$ is balanced, assume, without loss of generality, that $f(x_1) = 0$.
The probability of success is then 
$$P(\operatorname{Success}) = P(f(x_2) = 1) = \frac{N/2}{N-1} = \frac12 + \frac{1}{2(N-1)},$$
and therefore by [@prop:Chernoff] the error can be bounded by repeating the algorithm and taking the majority vote.

[@algo:deutsch] may seem superior to this probabilistic alternative in that it outputs the correct answer with certainty and it does so in exactly one query, when, in comparison the probabilistic algorithm takes at least two queries.
Nonetheless, this property is dependent on the chosen gate basis, since the approximation given by the Solovay-Kitaev theorem might introduce some error, so the seeming advantage might vanish in practice.

Hence, the two alternatives are asymptotically equivalent and there is no speedup gained by this algorithm in comparison with the classical case.

## Quipper implementation

This section outlines the implementation of [@algo:deutsch] in Quipper.
The complete code is available at `src/lib/Algorithms/Deutsch.hs`.
We will need some functions and datatypes mentioned in [Quipper features].

The algorithm will have type
```haskell
deutschJozsa :: (QShape ba qa ca) => Oracle qa -> Circ ca
```
since it takes an oracle with input shape `qa` and returns classical bits `ca` with the same shape.
We name the input oracle `oracle`.


First, we need to initialize as much qubits as the oracle takes to $\ket{0}$ and an extra one to $ket{1}$.
We use `qinit :: QShape qa ba ca => ba -> Circ qa`, that  initializes an arbitrary data structure with qubits that have some fixed value. It can be used in conjunction with `qc_false` to initialize the qubits:
```haskell
(x, y) <- qinit (qc_false (shape oracle), True)
```

Next, we apply `map_hadamard :: QShape qa ba ca => qa -> Circ qa` that applies the Hadamard gate to each qubit:
```haskell
(x, y) <- map_hadamard (x, y)
```

For the next step we apply the oracle.
To have a simpler graphical representation, we use the function `box`, which encapsulates a circuit into a box, so that on its depiction it appears on a different page.
This has no effect on the simulation.
```haskell
(x, y) <- boxedOracle (x, y) -- boxedOracle = box "Oracle" $ circuit oracle
```

We apply the Hadamard gate again, this time to the top qubits (called `x`), measure the top qubits and discard the 
bottom qubit `y`. Finally, we return the result using `pure`.

The complete algorithm can be seen in the following code snippet.

```haskell
deutschJozsa :: (QShape ba qa ca) => Oracle qa -> Circ ca
deutschJozsa oracle = do
  -- Initialize x (to False) and y (to True)
  (x, y) <- qinit (qc_false (shape oracle), True)

  -- Apply Hadamard gates to each qubit
  (x, y) <- map_hadamard (x, y)

  -- Apply oracle
  (x, y) <- boxedOracle (x, y)

  -- Apply Hadamard gate again to x
  x      <- map_hadamard x

  -- Measure and discard
  z      <- measure x
  qdiscard y
  pure z
```

In order to solve [@prob:deutsch], we use the function `run_generic_io` to get the result:
```haskell
result <- run_generic_io (0 :: Double) deutschCircuit
```
and the output will be given by whether there is or not a `True` boolean:
```haskell
if or result then Balanced else Constant
```

This algorithm can be run by using the `quantum` binary with the `deutsch` subcommand.
