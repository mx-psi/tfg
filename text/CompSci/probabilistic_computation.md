\newpage

# Probabilistic computation models

A simple generalization of classical models of computation is to consider the addition of randomness.
The traditional focus is on probabilistic Turing machines, yet here we focus on probabilistic circuits since they are more similar to quantum circuits.

## Probabilistic circuits

Probabilistic circuits generalize classical circuits by considering "stochastic" gates, that is, gates that given a valid distribution on the inputs, output a valid distribution on the outputs.

The state space they modify can be represented by a real vector space spanned by a basis $\{\ket{0},\ket{1}\}$.
We call such space $R$. 

:::{.definition}
A *random bit* is a vector $$p = a\ket{0} + b\ket{1}$$ of the real vector space $R$ spanned by a basis $\{\ket{0},\ket{1}\}$, such that $$a,b \geq 0 \text{ and } \norm{p}_1 = a + b = 1.$$
:::

As was the case on quantum mechanics (sec. [Composite systems]), to consider the state space of a composite system we tensor the state spaces of the subsystems. Similarly, a state can be *measured*

:::{.definition}
A measurement of a probabilistic system of dimension $N = 2^n$ with state $$p = \sum_{i = 0}^{N-1} a_i\ket{i}$$ is a discrete random variable $X$ such that 
$$P\left(X = \ket{i}\right) = a_i \qquad (i = 1, \dots, N)$$
:::


Lastly, we state the allowed operations.

:::{.definition}
Let $n,m\in \mathbb{N}$. 
A *stochastic gate* is a linear map $f : R^{\otimes n} \to R^{\otimes m}$, represented by a *stochastic matrix*, that is, a matrix such that

1. every entry is non-negative and
2. every column adds up to 1.

When considered as a gate, $n$ is the number of **inputs** and $m$ is the number of **outputs**.
:::

Some simple examples of stochastic gates can be given.

:::{.example}
- Let $f: \BB^n \to \BB^m$ be classical gate.
  A stochastic gate can be formed by considering the linear extension of $f$, 
  $\overset{\sim}{f}:R^{\otimes n} \to R^{\otimes m}$, that is, 
  $$\overset{\sim}{f}\left(\sum_{i=0}^{2^n -1} a_i\ket{i}\right) = \sum_{i=0}^{2^n -1} a_i\ket{f(i)}.$$
  Its matrix is a permutation matrix.
- The uniformly random gate $\operatorname{RANDOM}: R^{\otimes 0} \to R$ outputs a uniform random bit, $\frac12(\ket{0} + \ket{1})$.
:::

Every stochastic gate can be seen as transforming from one distribution to another.

:::{.proposition}
Let $p \in R^{\otimes n}$ such that $\norm{p}_{1} = 1$ and all entries are non-negative, and let $f: R^{\otimes n} \to R^{\otimes m}$ be a stochastic gate. 
Then $f(p) \in R^{\otimes m}$ has all entries non-negative.
:::
:::{.proof}
Let $A$ be the matrix associated with $f$ with respect to the usual basis.
Then $$f(p) = Ap = \left(\sum_{j = 1}^{2^n -1} A_{ij}p_j\right)_{i = 1,\dots 2^n-1}$$

Every entry of $A$ and $p$ are non-negative, so $$\sum_{i = 1}^{2^n -1} A_{ij}v_j \geq 0$$ for every $i$.
Furthermore, $$\norm{Ap}_1 = \sum_{i = 1}^{2^n -1} \sum_{j = 1}^{2^m -1} A_{ij}v_j = \sum_{j = 1}^{2^m -1} v_j \left(\sum_{i = 1}^{2^n -1} A_{ij}\right) =  \sum_{j = 1}^{2^m -1} v_j = 1.$$
:::

TODO comentar si es suficiente con puertas que den una cierta distribución.

:::{.proposition}
Definition invariance by probability bias (see Arora and Barak)
One can simulate an arbitrary distribution
:::


Recalling [@dfn:circuit], we can thus define a probabilistic circuit as

:::{.definition}
A probabilistic circuit is a circuit respect to the basis
:::


Lastly, analogous to the classical case, we efine 

:::{.definition}


## Probabilistic computation with Turing machines

:::{.definition}
A *probabilistic Turing machine* is a 5-tuple $M = (Q,\delta_0,\delta_1, q_0, q_F)$ such that for $i = 0,1$
$(Q,\delta_i, q_0, q_F)$ is a Turing machine.

Opciones:

- Dos funciones de transición
- una máquina no determinista que induce una distribución de probabilidad.
- una máquina determinista que toma dos argumentos (verlo como "polynomial time compu")
:::

## Probabilistic polynomial complexity

:::{.definition}
$L \in \mathsf{BPP}$ if and only if there exists 
a polynomial time computable function $f: \BB^\ast \to \BB$ such that 

1. for every $x \in L$,    $P[f(x) = 1] \geq \frac23$ and
2. for every $x \notin L$, $P[f(x) = 1] \leq \frac13$.
:::

:::{.proposition name="Chernoff bound" #prop:Chernoff} 
[@NielsenQuantumComputationQuantum2010; Box 3.4]

Let $\varepsilon > 0, n \in \NN, p = \frac12 + \varepsilon$ and $X_1, \dots, X_n \sim \operatorname{Bernouilli}(p)$ independent identically distributed random variables. Then
$$P\left[\sum_1^n X_i \leq \frac{n}{2}\right] \leq \exp(-2\varepsilon^2 n)$$
:::
:::{.proof}
Let $x_i \sim X_i$ such that among $x_1, \dots, x_n$ there are at most $n/2$ ones.
Since $p > \frac12$, the probability mass function $p$ of one such sequence is maximized when there are exactly $\lfloor n/2\rfloor$ ones, that is, since they are independent, $p$ is bounded above by
\begin{align*}
p(x_1 = X_1, \dots, x_n = X_n) & = \prod_{i = 1}^n p(x_i = X_i) = \prod_{i = 1}^n p^{x_i}(1-p)^{1-x_i} \\
& \leq  \left(\frac12 - \varepsilon\right)^{\frac{n}{2}}\left(\frac12 + \varepsilon\right)^{\frac{n}{2}}  = \frac{(1-4 \varepsilon)^{n/2}}{2^n}.
\end{align*}

There are at most $2^n$ sequences of that kind, therefore,
$$P\left[\sum_1^n X_i \leq \frac{n}{2}\right] \leq 2^n \cdot \frac{(1-4 \varepsilon)^{n/2}}{2^n} = (1-4 \varepsilon)^{n/2}.$$

Lastly, by the Taylor expansion of the exponential we have $1 - x \leq e^{-x}$, which proves the result,
$$P\left[\sum_1^n X_i \leq \frac{n}{2}\right] \leq \exp(-4^{\varepsilon^2 n/2})= \exp(-2\varepsilon^2 n).$$
:::

:::{.definition}
$L \in \mathsf{PP}$ if and only if there exists 
a polynomial time probabilistic Turing Machine $M$ such that 

1. for every $x \in L$,    $P[M(x) = 1] \geq \frac12$ and
2. for every $x \notin L$, $P[M(x) = 1] \leq \frac12$.
:::

:::{.example}
Problem which is in PP but we don't know wether it is in BPP
:::


### A $\mathsf{BPP}$ language

In this section we show a simple language known to be in $\mathsf{BPP}$ but not known to be in $\mathsf{P}$.
Although the general consensus among theoretical computer scientists is that $\mathsf{P} = \mathsf{BPP}$ [TODO citar y extender] (through the use of pseudorandomness), no direct classical algorithm is known to solve this problem in polynomial time.

TODO Mirar Lemma 7.5 de Arora

### BPP properties

:::{.theorem}
$$\mathsf{BPP} \subseteq \mathsf{EXP}$$
:::
:::{.proof}
TODO
:::

BPP vs PH
BPP vs P/Poly 
BPP vs EXP
Pseudorandomness

(mirar Arora y Barak)

### Semantic versus syntactic classes

:::{.definition}
Complete promise problem for BPP (ver Quantum proofs o On Promise Problems)
:::

:::{.proposition}
The language of BPP machines is undecidable 
:::

:::{.proposition}
1. Complete promise problem for BPP
:::

There are no complete problems with empty promise known for BPP

There are no hierarchy theorems


## Probabilistic polynomial time verifiers

:::{.definition}
TODO MA
:::

Graph non isomorphism is in MA
Mention derandomization
