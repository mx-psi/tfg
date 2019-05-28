# Classical computation models

## What is a problem?

Computability and complexity theory attempt to answer questions regarding how to efficiently solve real-world problems.
To formalize the notion of problem, we need to encode the inputs and outputs in an uniform way as words over an alphabet.

:::{.definition}
An *alphabet* is a finite set. Its elements are called *symbols*.

A *word* $w = w_1 \dots w_n$ over an alphabet $A$ is a finite sequence of symbols over that alphabet.
Its length is $|w| := n$. The set of all words over $A$ is denoted $A^\star$.

Given two words $u = u_1 \dots u_n, v = v_1 \dots v_m \in A^\star$ its concatenation is the word $$\cdot(u,v) := uv := u_1 \dots u_nw_1 \dots w_m \in A^\star.$$
$(A^\star,\cdot)$ is a monoid.

A *language* over an alphabet $A$ is a subset $L \subseteq A^\star$.
:::

Using these notions one can define a variety of concepts that correspond to different kinds of problems.
In this text we will mostly focus on decision problems and promise problems.

:::{.definition}
A *promise problem* over $A$ is a pair of disjoint languages $(L_{\operatorname{YES}}, L_{\operatorname{NO}})$ over $A$.
The *promise* of a promise problem is the set $L_{\operatorname{YES}} \cup L_{\operatorname{NO}}$.

A *decision problem* is a promise problem $(L_{\operatorname{YES}}, L_{\operatorname{NO}})$ such that $L_{\operatorname{YES}} \cup  L_{\operatorname{NO}} = \BB^\ast$.
The associated language to a decision problem is $L_{\operatorname{YES}}$.
::::

In a promise problem we are promised that the input will belong to the promise, and we must decide whether it is a YES-instance or a NO-instance.
These kinds of problems do not capture the full general notion of problems such as calculating a function.
However, most real-world problems can be translated into a decision problem that captures the complexity of solving it.

Inputs are usually stated in terms of mathematical structures such as integers, graphs, Turing machines or (finitely generated) groups. 
The encoding as binary words needs to be done in a per-object basis; it will be implicitly assumed what the actual encoding is if it is clear from context.

## Computation models and computability
### Turing machines

The classical notion of computability is formalized in the field of computational complexity via the notion of Turing machines. Although Turing machines can be further generalized, for our purposes we will focus on single-tape Turing machines with tape alphabet $\talph := \{0,1,\blank\}$ that includes the *blank symbol* $\blank$.

:::{.definition}

A *Turing machine* is a 4-tuple $M = (Q,\delta, q_0, q_F)$ such that

1. $Q$, the set of *states*, is a finite set,
2. $\delta: Q \times \talph \to Q \times \talph \times \{\operatorname{L}, \operatorname{R}\}$ is the *transition function*,
3. $q_0 \in Q$ is the *initial state*,
4. $q_F \in Q$ is the *final state*.

A *configuration* of $M$ is a triplet $(q,v,u)$ such that $q \in Q$ and $v,u \in \talph^\ast$.
It is *final* if $q = q_F$.
:::

Informally, a Turing machine has an internal state, an infinitely long tape with cells that initially have the blank symbol $\blank$ and a head positioned on top of one of the cells.
At each step, the machine reads the symbol on the current position and depending on the internal state and the symbol

1. transitions to a new internal state,
2. writes a new symbol on the current position and
3. moves the head to the **L**eft or **R**ight.

We can define two relations between configurations that will allow us to formalize this notion.
The idea is that a configuration represents the cells to the left and to the right of the head except for the infinite amount of blank cells at each side.

:::{.definition} 
Given two configurations $C, C'$ of the same machine, we say $C \vdash C'$ if, if $C = (q,v,u)$ then $C' = (q', v', u')$ such that $\delta(q, u_1) = (q', b, D)$ with $D \in \{L,R\}$ and

a) if $D = L$ then if $|v| = n, |u| = m$ we have $v' := v_1 \cdots v_{n-1}$ and $u' := v_n b u$ in all cases except
  
   i) if $n = 0$ then $v' := \ew, u' := \blank b u$
   ii) if $m = 1, b = \blank$ then $v' = v_1 \cdots v_{n-1}, u' := \ew$
   iii) if both conditions are held simultaneously then $v' = \ew, u' = \blank$.
  
b) if $D = R$ then if $|v| = n, |u| = m$ we have $v' := vb$ and $u' := u_2 \cdots u_m$ in all cases except
  
   i) if $m = 1$ then $v' := vb, u' := \blank$
   ii) if $n = 0, b = \blank$ then $v' = \ew, u' := u_2 \cdots u_m$
   iii) if both conditions are held simultaneously then $v' = \ew, u' = \blank$.

Given two configurations  $C, C'$ of the same machine, we say $C \vdash^\ast C'$ if there exists a finite sequence $C = C_1 \vdash \dots \vdash C_n = C'$. The Turing machine then *takes $n$ steps* to get from $C$ to $C'$.
:::

A configuration may be related with at most one other configuration.
We may assume that final configurations are not related to any other configuration.
Additionally, we say the Turing machine uses a cell of memory when a symbol different than the initial one has been written for the first time. 
Finally we have

:::{.definition #dfn:tm}
A Turing machine $M = (Q,\delta, q_0, q_F)$ *accepts* $u \in \BB^\ast$ if there exists a final configuration $C$ such that $(q_0, \ew, u) \vdash^\ast C$.

A Turing machine $M = (Q,\delta, q_0, q_F)$ *computes* $f:\BB^\ast \to \BB^\ast$ if for every word $u$ we have $(q_0, \ew, u) \vdash^\ast (q_F, v_1,v_2)$ with $f(u) = v_1v_2$.

A Turing machine $M$ *accepts a language $L$* if for every word $u \in L$, $M$ accepts $u$.
:::

If, when starting with a word on the tape at some point a Turing machine reaches a non-final configuration with no other related configuration, we say the Turing machine *rejects* its input.
When it is clear from context, we will also denote by $M$ the partial function computed by the Turing machine $M$.


### The circuit model

The circuit model provides an alternative computation model that will be useful in proving the relation between classic and quantum computation models. We adapt the definition from (@VollmerIntroductioncircuitcomplexity1999, chap. 1).

We will use the term circuit in different contexts in this document.
In general, there is an implicit base state space (for example $\BB, \RR$, a random bit or a qubit), that can be composed with a certain product (usually the cartesian product or the tensor product).[^category]
Both will be clear from context.

[^category]: In its most general terms what we are essentially describing a morphism in a planar monoidal category via a string diagram (@Selingersurveygraphicallanguages2010, thm. 3.1).

Using these basic pieces, a circuit is made of gates from a certain set (*basis*).
A *gate* is a function $f: A^n \to A^m$ from a product of the base state space $A$ to another product.
We say that the gate has $n$ inputs and $m$ outputs.

:::{.definition #dfn:circuit}
A *circuit* with $n$ inputs $\{x_1, \dots, x_n\}$ and $m$ outputs $\{y_1, \dots, y_m\}$ with respect to basis $\mathcal{B}$ is a $3$-tuple $C = (G, \beta, \mathcal{B})$ such that

1. $G = (V,E)$ is a finite directed acyclic graph,
2. $\beta: V \to \mathcal{B} \cup \{x_1, \dots, x_n\} \cup \{y_1, \dots, y_m\}$ is a function such that

   a) the in-degree and out-degree of a vertex match the number of inputs and outputs of its image by $\beta$,
   b) each input or output  is the image of $\beta$ in at most one node.

The *size* of a circuit $C$ is $|C| := |V|$.
:::

We assume a fixed efficient encoding of a circuit ( over a finite basis) as a binary string such that

1. the encoding $\operatorname{enc}$ is an injective function,
2. the encoding is efficient; there exists a polynomial $p(n) \geq n$ such that $$|\operatorname{enc}(C)| = p(|C|)$$

A possibility is the representation of the graph as and adjacency matrix.


In the case of classical circuits we allow the following known logical gates

1. the AND gate ($\wedge : \BB^2 \to \BB$), 
2. the OR  gate ($\vee : \BB^2 \to \BB$) and
3. the NOT gate ( $\neg : \BB \to \BB$).

This is not the smallest possible set of gates; it is a well-known fact that they can be reduce to the singleton set $\{\operatorname{NAND}\}$, where $\operatorname{NAND}:\BB^2 \to \BB$ is given by 
$$\operatorname{NAND}(x,y) = \neg(x \wedge y),$$
but, as we shall see in [a later section](#universal-quantum-gate-sets), this is irrelevant for asymptotic measures of size. 
It is also important that all gates are symmetric.

Furthermore, we will use three operations that allow us to clone, destroy and create bits, namely,

4. the FANOUT gate, given by $\operatorname{FANOUT}(x) = (x,x)$,
5. the 1-input 0-ouput DISCARD gate, that ignores the output and
6. the 0-input 1-output ANCILLARY gate that produces a $0$ bit.

Thus,

:::{.definition}
A (classical) circuit is a circuit with respect to the basis $$\{\operatorname{AND},\operatorname{OR},\operatorname{NOT},\operatorname{FANOUT},\operatorname{DESTROY},\operatorname{ANCILLARY}\}$$
:::

Clearly, a (classical) circuit $C$ with $n$ inputs and $m$ outputs computes a function $C: \BB^n \to \BB^m$.
To allow for functions with an input of arbitrary length we need the concept of a *circuit family*.

:::{.definition}
A (classical) *circuit family* is a sequence $\mathcal{C} = \{C_n\}_{n \in \NN}$ such that for every $n \in \NN$ $C_n$ is a circuit with $n$ inputs.
:::

We will mostly restrict ourselves to the case where every circuit in the family has one output.
In this case, a circuit family computes a function $\mathcal{C} : \BB^\ast \to \BB$ given by $\mathcal{C}(x) = C_{|x|}(x)$. We say $\mathcal{C}$ decides a language $L$ if $$\mathcal{C}(x) = \begin{cases} 1 & \text{ if } x \in L \\ 0 & \text{ otherwise} \end{cases}$$
In what follows we will not describe circuits explicitly as $2$-tuples, relying instead on graphical representations or high-level descriptions.

### Computability 

A Turing machine $M$ can be encoded in a canonical way as a binary string $w_M$, in such a way that there exists a *universal Turing machine* $U$ that computes $U(w_M,x) =M(x)$ (@AroraComputationalComplexityModern2009, thm. 1.9). Furthermore, we denote by $n(M)$ the number associated with the binary string $w_M$.

It is clear from the previous paragraph that the set of Turing machines is countable, since the function $M \mapsto n(M)$ is injective. On the other hand, the set of all languages $\mathcal{P}(\BB^\ast)$ is uncountable by Cantor's theorem. Therefore there are languages that are *undecidable*, that is, that are not the language associated with a Turing machine.

The following example showcases one undecidable language that is the language associated with a circuit family. This shows the power difference between the two models of computation.

:::{.proposition #prop:halting}
Let $L_{\mathrm{HALT}} = \{1^{n(M)} : M \notin L(M)\}$. Then

1. $L_{\mathrm{HALT}}$ is undecidable.
2. For any $L$ such that every $x\in L$ is of the form $x = 1^n$ (such as $L_{\mathrm{HALT}}$) there exists a circuit family $\mathcal{C}$ of linear size such that $L(\mathcal{C}) = L$.
:::
:::{.proof}
**1.**

Assume that $L_{\mathrm{HALT}}$ is decidable, that is, that there exists a Turing machine $M$ such that $L(M) = L$.

Let $M'$ be a Turing machine such that

> On input $x$, $M'$ computes $M(1^{n(M')})$. If accepted then reject, otherwise accept.

Then we arrive at a contradiction since 

- If $M' \in L(M)$ then by the definition of $M$, $M' \in L(M')$. But in that case, $L(M') = \varnothing$, thus $M' \notin L(M')$.
- If $M' \notin L(M)$ then by the definition of $M$, $M' \notin L(M')$. But in that case, $L(M') = \BB^\ast$, thus $M' \in L(M')$.

Therefore $M$ does not exist.

*****

**2.**

Let $n \in \NN$. Let $C_n$ be a linear size circuit that computes 

a) the constant function 0 if $1^n \notin L$ or 
b) the function $C_n(x_1 \dots x_n) = x_1 \wedge \cdots \wedge x_n$ otherwise.

The latter circuit can be computed by building a tree of $\wedge$s of logarithmic height.
The family $\{C_n\}_{n \in \NN}$ then decides $L$. 
:::

## Complexity
### Deterministic complexity

There are different approaches as to how to measure the complexity of a given algorithm, here we will focus on two such notions: the worst-case time and space complexity for Turing machines and the number of gates per input size in the case of circuits. <!--TODO: Mencionar otros approaches-->

:::{.definition}
Let $g \in \NN^\NN$. $$O(g) = \set{f \in \NN^\NN}{\exists N, C \in \NN: \;\; f(n) \leq Cg(n) \quad \forall n > N}$$
:::

:::{.definition}
Let $f: \NN \to \NN$, $L \subseteq \BB^\ast$. Then:

1. $L \in \TIME(f(n))$ if there exists a Turing Machine $M$ such that $L(M) = L$ and $M$ takes $g(n) \in O(f(n))$ steps to decide any $x \in \BB^\ast$ with $|x| = n$.
2. $L \in \SPACE(f(n))$ if there exists a Turing Machine $M$ such that $L(M) = L$ and $M$ writes $g(n) \in O(f(n))$ cells to decide any $x \in \BB^\ast$ with $|x| = n$.
3. $L \in \SIZE(f(n))$ if there exists a circuit family $\mathcal{C}$ over the basis $B$ such that $L(\mathcal{C}) = L$ and $|C_n| \in O(f(n))$.
:::

If $F \subseteq \NN^\NN$ then $$\TIME(F) = \bigcup_{f(n) \in F} \TIME(f(n))$$ and likewise for $\SPACE$ and $\SIZE$.

These classes are potentially dependent on the use of the specific single-tape Turing machine model of [@dfn:tm]; if a different model is used, such as multitape Turing machines or RAM models, the classes might change (@vanLeeuwenHandbookTheoreticalComputer1990, chap. 1).

<!-- #### The hierarchy theorems {.hidden} -->

<!-- Time and space hierarchy theorems -->

<!-- Discussion about relativization -->

### Non-deterministic complexity 

Analogous to the concept of Turing machine, a prevalent idea in complexity theory is the use of non-deterministic models of computation.
These models will be useful in that their associated complexity classes encapsulate several problems of practical importance and they provide upper-bounds for deterministic classes.

Intuitively, a non-deterministic Turing machine can be simultaneously in several configurations and thus have multiple computation paths.
Depending on the imposed criteria these computation paths can be interpreted in terms of probability or a more general non-determinism.

:::{.definition}
A *non-deterministic Turing machine* (NDTM) is a 4-tuple $M = (Q,\delta, q_0, q_F)$ such that

1. $Q$, the set of *states*, is a finite set,
2. $\delta \subseteq (Q \times \talph) \times (Q \times \talph \times \{\operatorname{L}, \operatorname{R}\})$ is the *transition relation*,
3. $q_0 \in Q$ is the *initial state*,
4. $q_F \in Q$ is the *final state*.

A *configuration* of $M$ is a triplet $(q,v,u)$ such that $q \in Q$ and $v,u \in \talph^\ast$.
It is *final* if $q = q_F$.
:::

An identical relation to that of Turing machines exists between configurations of NDTM.
In this case each configuration may be related to more than one other configuration, which is what gives rise to non-determinism. 
Using this assumed notions we define when a NDTM accepts a language in an analogous way to Turing machines.
The number of steps and memory usage is given by the maximum steps (resp. memory cells) used by any computation path.
This gives rise to the classes $\NTIME(f(n))$ and $\NSPACE(f(n))$ for languages that can be decided by a NDTM using $O(f(n))$ time or space respectively.

The possible computation paths on a given execution of a non-deterministic Turing machine can be seen as a tree with vertices labeled by the current configurations. Every tree of computation paths of the same NDTM will have a maximum *branching factor* that can be calculated from the transition relation.

For stating the relations between the different notions of complexity we will make use of the following technical lemma, that we present without proof.

:::{.lemma name="Oblivious Turing machine" #lemma:oblivious}
(@AroraComputationalComplexityModern2009, remark 1.7)

For any $f(n)$-time Turing machine $M$ there exists a $f(n) \log f(n)$-time Turing machine $\overset{\sim}{M}$ that decides the same language and such that for every input $x \in \BB^\ast$ and $i \in \NN$ the location of the head of $M$ at the $i$th step of execution is a function of $|x|$ and $i$.
:::

Using this lemma we can prove

:::{.proposition #prop:timespace}
The following inequalities hold for every $f \in \NN^\NN$

1. $\TIME(f(n)) \subseteq \SIZE(f(n) \log f(n))$,
2. $\TIME(f(n)) \subseteq \NTIME(f(n))$ and $\SPACE(f) \subseteq \NSPACE(f)$,
3. $\NTIME(f(n)) \subseteq \SPACE(f(n))$ ad
4. if $f(n) \geq \log(n)$ then $\NSPACE(f(n)) \subseteq \TIME(2^{f(n)})$.
:::
:::{.proof}
1. Let $L \in \TIME(f(n))$ and $M$ a $f(n)$-time Turing Machine. 
   By [@lemma:oblivious] there exists a $g(n) = f(n) \log f(n)$-time oblivious Turing machine $M'$ that decides the same language. 
   
   On input $x$, the configuration of $M'$ at step $n$ can be encoded as a constant-size string.
   Furthermore, the transition from configuration $C$ to configuration $C'$ can be computed with a constant-sized circuit with inputs $C$ and the configurations that were in the same position as configuration $C'$, that, since $M'$ is oblivious, depend only on the size of the input.
   The composition of these circuits gives rise to a $g(n)$-sized circuit family that computes the same language as $M$.
   
2. Clearly, every (deterministic) Turing machine can be transformed into a non-deterministic one by transforming the transition function into a transition relation.
   The running time and space will be identical and thus we have both inclusions
3. Let $L \in \NTIME(f(n))$ and $M$ the associated NDTM. 
   Let $d$ be the maximum branching factor of $M$.
   Any sequence of choices can be written in $O(f(n)\log d)$ space as a sequence of $O(f(n))$ numbers between $0$ and $d$.
   
   For every posible sequence of choices, try the execution of $M$ and accept if $M$ accepts.
   If $M$ rejects for any of these sequences, then reject.
   
4. Let $L \in \NSPACE(f(n))$, $M = (Q, \delta, )$ the associated NDTM. 
   The set of possible configurations of $M$ has size $|Q|2^{f(n)}(n+1) \in O(2^{f(n) + \log(n)}) = O(2^{f(n)})$.
   
   Checking $x \in L$ is equivalent to checking if there is a path between the initial configuration and a final configuration, the graph of possible configurations, where two configurations are connected if they are related by $\vdash$. This can be done in quadratic time, which proves the result.
:::

### Polynomial usage of resources

A polynomial amount of resources is informally described as an efficient usage of time or space.
This definition does not precisely match the everyday definition of "efficient"; for practical purposes an algorithm that takes $n^{1000}$ steps to decide a word of size $n$ is not considered efficient and an algorithm with running time $n^{\log \log n}$ is (@AaronsonmathoplimitsNP2016, sec. 1.2.1).

Nonetheless, the interpretation of the following classes as containing efficiently decidable languages makes sense since these are the minimal classes closed under composition, concatenation and union that contain linear-time decidable languages (or respectively space or size)  (@CobhamIntrinsicComputationalDifficulty1965). Additionally, these classes are robust under small changes in the computational models used to define them (e.g. by using multi-tape machines or RAM models) (@vanLeeuwenHandbookTheoreticalComputer1990, chap. 1).

:::{.definition}
Let $\poly(n) = \set{P \in \NN^\NN}{P \text{ is a polynomial}}$. Then

- $\mathsf{P} := \TIME(\poly(n))$,
- $\mathsf{NP} := \NTIME(\poly(n))$,
- $\mathsf{PSPACE} := \SPACE(\poly(n))$,
- $\mathsf{NPSPACE} := \NSPACE(\poly(n))$ and
- $\mathsf{P/\poly} := \SIZE(\poly(n))$.
:::

Clearly, by [@prop:timespace], $\mathsf{P} \subseteq \mathsf{NP} \subseteq \mathsf{PSPACE} \subseteq \mathsf{NPSPACE}$. The first inequality is conjectured to be strict and is the most important problem in the field (@AaronsonmathoplimitsNP2016 sec. 2.2.5), given the wide range of practical problems that are in $\mathsf{NP}$. The last inequality is in fact an equality given by *Savitch's theorem* (@AroraComputationalComplexityModern2009, thm. 4.14).


As seen in [@prop:halting] $\mathsf{P/\poly}$ contains languages that are uncomputable by the classic notion of computation, thus $\mathsf{P} \subsetneq \mathsf{P/poly}$, and some restriction is needed to use the circuit model for stating complexity results.

The following definition and result gives an alternative characterization of $\mathsf{P}$ in terms of families of circuits. 

:::{.definition}
A circuit family $\mathcal{C}$ is said to be *polynomial-time uniform* if there exists a Turing machine $M$ that computes the function $1^n \mapsto \operatorname{enc}{C_n}$ in polynomial time.
:::

Clearly, a polynomial-time uniform circuit family has polynomial size, since it could not be written as the output otherwise.

:::{.proposition #prop:ppoly}
Let $L$ be a language. Then

1. $L \in \mathsf{P}$ if and only if $L$ is decidable by some polynomial-time uniform circuit family.
2. $L \in \mathsf{P/\poly}$ if and only if there exists a Turing machine $M$ and a sequence of words $w_n$ of polynomial size such that $x \in L$ if and only if $M$ accepts $x \blank w_{|x|}$.
:::
:::{.proof}

**1.**

$\implies\!\!)$ The circuit family described in [@prop:timespace] 1 is polynomial-sized if $M$ is polynomial-time.
Additionally, it can clearly be computed by a Turing machine simulating the execution of $M$ on $1^n$ and constructing the circuit as it goes.

$\Leftarrow)$ Let $\{C_n\}_{n \in \NN}$ be a polynomial-time uniform circuit family that decides $L$. 
Then let $M$ be the Turing machine given by the following description

> On input $x$ write $1^{|x|}$ and compute $C_{|x|}$.
> Finally compute $C_{|x|}(x)$ and accept depending on the outcome.

Clearly $1^{|x|}$ can be written on linear time and, since, $\{C_n\}_{n \in \NN}$ is polynomial-time uniform, $C_{|x|}$ can be calculated in polynomial time.
Computing $C_{|x|}(x)$ implies computing the outcome at each vertex which can be done in constant time. The whole computation takes polynomial time since the circuit family has polynomial size. 

****

**2.**

$\implies\!\!)$ Since $L \in \mathsf{P/\poly}$, take as the sequence of words $w_n$ the encoding of the polynomial-size circuit family $C_n$ that decides $L$. Since $C_n$ has polynomial size, $w_n$ has polynomial size.

Then, let $M$ be the Turing machine that on input $x \blank w_n$ output $C_n(x)$.
As in the proof of **1**, one can do this in polynomial time.


$\Leftarrow)$ By [@prop:timespace] 1 we know that there exists a polynomial-size sequence of circuits $C'_n$ such that $C'_n$ has $n + |w_n|$ inputs and $C'_n(x,w_n) = M(x \blank w_n)$. 

Let $C_n$ be the circuit $C'_n$ with input $w_n$ fixed. 
$C_n$ has polynomial-size on the variable $m = n + |w_n|$ and thus has polynomial size with respect to $n$.
:::

<!-- #### The Karp-Lipton theorem {.hidden} -->

### Polynomial time verifiers

An important notion in the field of computational complexity is the notion of *verifiers*.
Potentially, a language might not be able to be decided in polynomial time, yet one can decide membership when supplied with a *proof*. Here we show a characterization of $\mathsf{NP}$ as a verifier class.

:::{.proposition #prop:npverifier}
Let $L \subseteq \BB^\ast$. Then $L \in \mathsf{NP}$ if and only if there exists a Turing Machine $V$ (*verifier*) that takes polynomial time to execute with respect to the length of its first argument and a polynomial $p(n) \in \poly(n)$ such that 

> $x \in L$ if and only there exists $y \in \BB^\ast$ with $|y| \leq p(|x|)$ such that $V(x,y) = 1$.
:::
:::{.proof}
$\implies\!\!)$ Let $M = (Q,\delta,q_0,q_F)$ be a polynomial-time non-deterministic Turing machine for $L$.
As in the proof of [@prop:timespace], any sequence of choices can be written in a polynomial-length word as a sequence of numbers between $0$ and the maximum branching factor.

We can then let $V$ be the verifier given by the following description

> On input $x,y$ run $M$ with input $x$. Whenever a pair $(q,a)$ is related with more than one triplet by $\delta$, choose among the triplets at step $i$ by using the $i$th number of $y$. Output $1$ if and only $M$ accepts.

Since $M$ runs in polynomial time $V$ runs in polynomial time. Furthermore, if and only if $x \in L$ there exists a set of choices $y$ that leads to an accepting path.

****

$\Leftarrow)$ Let $V$ be a verifier for $L$ and $p$ its associated polynomial. 
Then let $M$ be the Turing machine with the following description

> On input $x$ non-deterministically select a string $y$ of length $|y| \leq p(|x|)$. Accept if $V(x,y) = 1$.

The selection of a string is done in polynomial time since writing each symbol takes one step.
By hypothesis, $V$ runs in polynomial time on $x$, thus $M$ is a non-deterministic polynomial-time Turing machine.
:::


<!-- Local Variables: -->
<!-- ispell-local-dictionary: "british" -->
<!-- End: -->
