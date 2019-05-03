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

Lastly, we state the allowed operations. For this we need the technical concept of computable number.

:::{.definition}
A real number $r \in \RR$ is a *computable number* if the function that given $n$ outputs the n-th bit of $r$ can be computed.

It is *polynomial time computable* if this function can be computed in time polynomial in $n$.
:::

Clearly, the set of computable numbers is countable and thus there exists uncomputable numbers.
The restriction to computable numbers is not too strict though since the set of computable numbers is dense.

:::{.definition}
Let $n,m\in \mathbb{N}$. 
A *stochastic gate* is a linear map $f : R^{\otimes n} \to R^{\otimes m}$, represented by a computable *stochastic matrix*, that is, a matrix such that

1. every entry is a computable number,
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
- The random gate $\operatorname{RANDOM}(p): R^{\otimes 0} \to R$ outputs a random bit, $p\ket{0} + (1-p)\ket{1})$.
:::

Every stochastic gate can be seen as transforming from one distribution to another.

:::{.proposition}
Let $p \in R^{\otimes n}$ such that $\norm{p}_{1} =_{} 1$ and all entries are non-negative, and let $f: R^{\otimes n} \to R^{\otimes m}$ be a stochastic gate. 
Then $f(p) \in R^{\otimes m}$ has all entries non-negative.
:::
:::{.proof}
Let $A$ be the matrix associated with $f$ with respect to the usual basis.
Then $$f(p) = Ap = \left(\sum_{j = 1}^{2^n -1} A_{ij}p_j\right)_{i = 1,\dots 2^n-1}$$

Every entry of $A$ and $p$ are non-negative, so $\sum_{i = 1}^{2^n -1} A_{ij}v_j \geq 0$ for every $i$.
Lastly, $$\norm{Ap}_1 = \sum_{i = 1}^{2^n -1} \sum_{j = 1}^{2^m -1} A_{ij}v_j = \sum_{j = 1}^{2^m -1} v_j \left(\sum_{i = 1}^{2^n -1} A_{ij}\right) =  \sum_{j = 1}^{2^m -1} v_j = 1.$$
:::

Clearly, we can decompose any stochastic gate into a circuit formed by only classical gates and ancillary random bits, that is, $\operatorname{RANDOM}(p)$ gates. The following result shows us that we can restrict to single source of randomness with a fixed bias.


::::{.comment}
:::{.proposition}
Let $f : R^{\otimes n} \to R^{\otimes m}$.
There exists a circuit made of $\operatorname{RANDOM}(p)$ gates and classical gates that computes $f$.
:::
:::{.proof}
$g: \BB^{n+m} \to \BB^{n}$ such that the following circuit TODO
:::
::::

:::{.proposition}
Let $p,q \in [0,1]$ be polynomial time computable numbers and let $\varepsilon > 0$. 

A $\operatorname{RANDOM}(p)$ gate can be simulated by a constant sized circuit formed by classical gates and $\operatorname{RANDOM}(q)$ gates up to an accuracy of more than $\varepsilon$.
:::
:::{.proof}
TODO
:::


Recalling [@dfn:circuit] and using the previous proposition, we can thus define a probabilistic circuit as

:::{.definition}
A probabilistic circuit is a circuit respect to the basis 
$$\{\operatorname{NAND}, \operatorname{FANOUT}, \operatorname{RANDOM}(1/2)\}$$
:::

Here the base state space is $R$ and the product is the tensor product.
Lastly, analogous to the classical case, we define the concept of probabilistic computability.

:::{.definition}
A function $f: \BB^\ast \to \BB^\ast$ is probabilistic $T(n)$-computable if there exists a $T(n)$-sized uniform family of probabilistic circuits $\mathcal{C} = \{C_n\}$ such that for all $x \in L$,
$$P[C(x) = f(x)] \geq \frac23$$
:::

The constant $\frac23$ is arbitrary and can be replaced by any constant $c \in ]\frac12,1[$ with at most polynomial overhead, as the following proposition shows.

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

## Probabilistic polynomial complexity

The languages that are feasibly decided by probabilistic algorithms form the class $\mathsf{BPP}$ (*bounded probabilistic polynomial*):

:::{.definition}
$L \in \mathsf{BPP}$ if and only if $1_{L_{}}$ is a probabilistic polynomial time computable function, that is, there exists a probabilistic polynomial time algorithm $M$ such that

1. for every $x \in L$, $P[M(x) = 1] \geq \frac23$ and
2. for every $x \notin L$, $P[M(x) = 1] \leq \frac13$.
:::

As we saw in [@prop:Chernoff], we can make the bounds as close to 1 as we want and we will have the same class of languages.

Another possibility is to consider unbounded probabilistic algorithms, that are given by the class $\mathsf{PP}$.

:::{.definition}
$L \in \mathsf{PP}$ if and only if there exists 
a probabilistic polynomial time algorithm $M$ such that 

1. for every $x \in L$,    $P[M(x) = 1] \geq \frac12$ and
2. for every $x \notin L$, $P[M(x) = 1] \leq \frac12$.
:::

The following relations hold between classical and probabilistic classes.

:::{.proposition}
$$\mathsf{P} \subseteq \mathsf{BPP} \subseteq \mathsf{PP} \subseteq \mathsf{PSPACE}$$
:::
:::{.proof}
The first three inclusions are 
:::

$\mathsf{P}$ and $\mathsf{BPP}$ are conjectured to be equal, that is, every probabilistic algorithm could be *derandomized* into a classical algorithm. In contrast, $\mathsf{PP}$ is considered unfeasible, as the following proposition shows 

:::{.proposition #prop:nppp}
[@KatzNotesComplexityTheory]

$$\mathsf{NP} \subseteq \mathsf{PP}$$
:::
:::{.proof}
Let $L \in \mathsf{NP}$ and $x \in \BB^\ast$.

By [@prop:npverifier], there exist a verifier $V$ and a polynomial $p$ such that $x\in L$ iff there exists $y \in \BB^{p(|x|)}$ with $V(x,y) = 1$.

The following $\mathsf{PP}$ algorithm $M$ decides $L$.

Accept $x$ with probability $\frac12 - 2^{-p(|x|)-2}$.
Otherwise, pick a random $y \in \BB^{p(|x|)}$ and accept if $V(x,y) = 1$.

If $x \notin L$, then $$P[M(x) = 1] = \frac12 - 2^{-p(|x|)-2} < \frac12.$$
Otherwise, if $x \in L$ then $P[V(x,y) = 1] \geq 2^{-p(|x|)}$, thus
$$P[M(x) = 1] \geq \frac12 - 2^{-p(|x|)-2} + 2^{-p(|x|)} > \frac12.$$
<!--TODO: En la fuente original pone 2^{-p(|x|)}/2-->

Therefore, $M$ decides $L$.
$M$ runs in polynomial time since $V$ runs in polynomial time on its first input.
:::

As the proof of [@prop:nppp] shows, the difference between $\mathsf{PP}$ and $\mathsf{BPP}$ lies in the possibility of applying [@prop:Chernoff]. 
The probability bounds of the algorithm stated in this proof can not be amplified efficiently by applying that procedure.

Lastly, we can show the following relation between $\mathsf{BPP}$ and non-uniform classes,

:::{.proposition}
$$\mathsf{BPP} \subseteq \mathsf{P}/\operatorname{poly}$$
:::
:::{.proof}
TODO
:::

<!--
Podría añadir 
BPP vs PH
-->

### Probabilistic computation with Turing machines

The traditional presentation of probabilistic computation using Turing machines can be given by recalling [@prop:ppoly]

:::{.proposition}
TODO
:::

### A $\mathsf{BPP}$ language

In this section we show a simple language known to be in $\mathsf{BPP}$ but not known to be in $\mathsf{P}$.
Although the general consensus among theoretical computer scientists is that $\mathsf{P} = \mathsf{BPP}$ [TODO citar y extender] (through the use of pseudorandomness), no direct classical algorithm is known to solve this problem in polynomial time.

The problem is called *polynomial identity testing* and can be formally stated by making use of algebraic circuits, which essentially describe a polynomial expression.
We follow the approach of [@SaxenaProgressPolynomialIdentity].

:::{.definition}
An *algebraic circuit* is a circuit with one output with respect to the basis $\{+,-,\times, \operatorname{FANOUT}\}$.

The set of algebraic circuits is $\mathcal{A}$.
:::

Here the state space is an arbitrary field $\mathbb{F}$ (or more generally a ring) and the product between state spaces is the cartesian product.
We assume that the field operations can be computed in constant time[^constant].

[^constant]: Although this is a common assumption in the study of PIT it is not trivial. If for example we want to apply the algorithm to circuits over $\ZZ$ further considerations are needed to ensure the algorithm is efficient, since the binary representation of intermediate calculations might have exponential size. See [@AroraComputationalComplexityModern2009; sec 7.2.3] for a possible approach.

Clearly, the function associated with an algebraic circuit $A$ is a (multivariate) polynomial $p_A$.
The output of the function for a given input can be computed in polynomial time, though obtaining the polynomial coefficients can in principle take exponential time (since its degree can be exponential on the number of gates).

:::{.definition}
$$\operatorname{ZEROP} = \{A \in \mathcal{A} \;:\; p_A \equiv 0 \}$$
:::

Solving the decision problem associated with $\operatorname{ZEROP}$ allows us to solve whether two polynomial expressions are equivalent, since we can reduce this problem to checking that their difference is the zero function.

The straightforward approach of obtaining the polynomial coefficients proves $\operatorname{ZEROP} \in \mathsf{EXP}$ but not $\operatorname{ZEROP} \in \mathsf{P}$, since an algebraic circuit might have an exponential number of coefficients.

Surprisingly, a polynomial probabilistic algorithm can be given for this problem.
The algorithm is based on the following lemma.

:::{.lemma name="Schwartz-Zippel Lemma" #lemma:zippel}
[@SaxenaProgressPolynomialIdentity; Lemma 1.2]

Let $p \in \mathbb{F}[X_1, \dots, X_m]$ be a nonzero polynomial of (total) degree $d$ and $S \subseteq \mathbb{F}$ a finite set.
Then, if $a_1, \dots, a_m$ are sampled independently and uniformly from $S$,
$$P[p(a_1, \dots, a_m) \neq 0] \geq 1 - \frac{d}{|S|}$$
:::
:::{.proof}
The proof is by induction on the number of variables.

In the **base case** $p$ is an univariate polynomial. $p$ has a maximum of $d$ roots and thus the probability of finding a root, i.e $P[p(a_1) = 0]$ is at most $\frac{d}{|S|}$.

For the **inductive case**, assume the lemma holds for any polynomial of total degree less than $d$.
We may consider $p$ as a polynomial on its first variable, 
$p \in \mathbb{F}[X_2, \dots, X_m][X_1]$, where the coefficients are now polynomials $p_i$ in the rest of variables.

$p \neq 0$, so let $p_k$ be the polynomial coefficient accompanying the largest $X_1$ power.

Since the total degree of $p$ is $d$, it follows that the total degree of $p_k$ is at most $d-k$.
By the inductive hypothesis, since $d-k < d$ we have that 

1. if $a_2, \dots, a_m$ are sampled independently and uniformly from $S$,
   $$P[p_k(a_2, \dots, a_m) \neq 0] \geq 1 - \frac{(d-k)}{|S|} \text{ and}$$
2. if $p_k(a_2, \dots, a_m) \neq 0$, then $p(X_1, a_2, \dots, a_m)$ is a univariate polynomial and by the base case,
   $$P[p(a_1, \dots, a_m) \neq 0 | p_k(a_2, \dots, a_m) \neq 0] \geq 1 - \frac{k}{|S|}.$$
   
By joining the previous inequalities we have
$$P[p(a_1, \dots, a_m) \neq 0] \geq \left(1 - \frac{k}{|S|}\right)\left(1 - \frac{d-k}{|S|}\right) \geq 1 - \frac{d}{|S|}$$
:::

Using this lemma, we can prove the following proposition

:::{.proposition}
$$\operatorname{ZEROP} \in \mathsf{BPP}$$
:::
:::{.proof}
The polynomial associated with a circuit $A$ has a total degree of at most $2^{|A|}$ and at most $|A|$ inputs.
We call $m$ the number of inputs of $A$.

The randomized algorithm is as follows:

1. Sample $m$ elements $a_1, \dots, a_m$ from a finite subset $S$ such that $|S| > 3 \cdot 2^{|A|}$.
   In the case of finite fields, we might need to consider a field extension that has enough elements (for example 
   by working over a cyclotomic extension).
2. Evaluate $p_A(a_1, \dots, a_n)$. This can be done in a polynomial amount of field operations.
3. If the previous result is zero, accept, otherwise, reject.

Clearly, if $A \in \operatorname{ZEROP}$ we always accept.
If $A \notin \operatorname{ZEROP}$, by [@lemma:zippel] 
$$P[p_A(a_1, \dots, a_n) \neq 0] \geq 1 - \frac{2^{|A|}}{|S|} > \frac23.$$

Thus $\operatorname{ZEROP} \in \mathsf{BPP}$.
:::

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


## Probabilistic polynomial time verifiers

A natural generalization of $\mathsf{NP}$ is to consider the possibility of randomized verifiers.
This gives rise to the class $\mathsf{MA}$ (*Merlin-Arthur*).

:::{.definition}
TODO MA
:::

Clearly, $\mathsf{NP}, \mathsf{BPP} \subseteq \mathsf{MA}$.
There are no known natural problems that lie in $\mathsf{MA}$ and are not in $\mathsf{BPP} \cup \mathsf{NP}$.

<!--
Mencionar AM
Graph non isomorphism is in AM
Mention derandomization
-->
