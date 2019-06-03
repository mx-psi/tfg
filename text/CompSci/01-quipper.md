:::{.comment}

# Programming quantum algorithms

In this and the following sections we will present several key quantum algorithms that provide some speedup in comparison with the best known classical (or randomized) algorithm that solves the same problem.

This first section presents the general setup; both in terms of what will be said about algorithms and how they have been implemented using the programming language Quipper.

## Quipper

\fxnote{Queda por hacer.}

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

:::

# The Deutsch-Jozsa algorithm

In this chapter we develop our first example of a quantum algorithm.
The first section presents the setting in which the complexity of this and later algorithms will be analyzed, and the following section presents the solution.

## The query complexity model

The focus of the previous sections on computation models was on time complexity.
These are the most meaningful practical measures of complexity; however, they are notoriously difficult to analyse, as the wide range of existing open problems in the field shows (@AaronsonmathoplimitsNP2016).

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

:::{.comment}

## Quipper implementation

This section outlines the implementation of [@algo:deutsch] in Quipper.
It also presents the general datatype of `Oracle`s, used in later algorithms.

### The `Oracle` datatype

An oracle is a circuit that represents a function $f: \BB^n \to \BB$.
It is given by its `shape` of input and the underlying circuit:
```haskell
data Oracle qa = Oracle {
  shape   :: qa, -- ^ The shape of the input
  circuit :: (qa,Qubit) -> Circ (qa,Qubit) -- ^ The circuit oracle
  }
```
This type constructor is parameterized by the shape of input.
It is intended that the type of input belongs to the class `QData`.

The module `Oracle` provides several ways of building an oracle:

1. Explictly from its shape and a possibly non-reversible circuit by the function `buildOracle`, with type
```haskell
buildOracle
  :: QData qa
  => qa
  -> (qa -> Circ Qubit)
  -> Oracle qa
```
2. From a csv-formatted `String` such as
```
00,0
01,1
10,0
11,1
```
via the function `decodeOracle`, with type
```haskell
decodeOracle :: String -> Either Error (Oracle [Qubit])
```
indicating a possible failure if the string is malformed.
A general use case is reading an oracle from a file and using it in some `IO` action.
The function `withOracle`, with type
```haskell
withOracle :: String -> (Oracle [Qubit] -> IO ()) -> IO ()
```
conveniently encapsulates such use case, automatically reporting possible errors.


### Deutsch-Jozsa algorithm




It is defined as a polymorphic function that takes an `Oracle`.

:::
