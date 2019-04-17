\newpage
  
# Quantum computation models

## Quantum circuits

Analogous to the concept of classical or probabilistic circuits, this notion can be further generalized into the quantum realm.

:::{.definition}
TODO quantum circuit
TODO size of a quantum circuit
TODO unitary operation associated with a quantum circuit
:::


We assume a fixed encoding of quantum circuits as binary strings.

:::{.definition}
A *quantum circuit family* over a gate set $\mathcal{G}$ is a sequence $\mathcal{C} = \{C_n\}_{n \in \mathbb{N}}$ of quantum circuits such that for every $n \in \NN$, $C_n$ is a circuit over $\mathcal{G}$ with $l_{\mathcal{C}}(n) \geq n$ inputs.

We say a quantum circuit family is *uniform* if the function $1^n \mapsto C_n$ is computable.
:::

Unlike in the classical case, we allow the $n$-th circuit of a quantum circuit family to have more than $n$ inputs,
so as to allow the use of *ancilla qubits*. Therefore, a circuit family has an associated function that outputs a random variable for every input, where we right pad the input string with zeros:
if $x \in \BB^\ast$, $\mathcal{C}(x) = C_n(\ket{x}\ket{0}^{\otimes l(n) - n})$.


:::{.definition}
Watrous unitary purification
:::

### Universal quantum gate sets

#### The classical case

It is a well-known fact that, in the classical case, any function $f: \BB^\ast \to \BB^M$ can be computed exactly by a circuit (of at most exponential size) built using the basis of gates $$\{\operatorname{AND}, \operatorname{OR}, \operatorname{NOT}\}.$$
There are other possible basis universal in this sense, such as $\{\operatorname{NAND}\}$ or $\{\operatorname{NOR}\}$. Of course, not all basis are universal; a full classification of the basis is given by Post's lattice [TODO citar].

Given two finite universal basis $B_1$ and $B_2$ one may construct every element of the latter with a circuit made of gates of the former. 
The size of a family of circuits transformed in this manner increases only up to a constant and thus, in the classical case this discussion concludes with the following trivial proposition:

:::{.proposition}
Let $B_1$, $B_2$ two finite universal basis, that is, two basis of gates that allow us to construct a circuit that computes an arbitrary function $f: \BB^N \to \BB^M$.

Given a family of circuits with respect to $B_1$ that has size $O(f(n))$, there exists a family of circuits with respect to $B_2$ that computes the same function and has size $O(f(n))$.
:::

The main consequence from this proposition is that the chosen basis is irrelevant for proving there exists a family of a certain (asymptotic) size. 

This section aims to prove a similar (yet weaker) result for quantum circuits.
This result is of great theoretical importance, since we do not currently understand what quantum operations are physically realizable, and thus would like to build a theory independent of any specific quantum gate basis. 

#### Quantum universal gate sets

As we saw in sec. [A model of quantum mechanics], there are two kinds of operations by which a quantum system can be transformed

1. unitary operations, which are reversible,
2. measurements, which are not reversible.


:::{.definition}
A set of quantum gates $\mathcal{G}$ is *universal* if for every $\varepsilon > 0$ and every unitary operation $U$ there exists a quantum circuit $C$ over $\mathcal{G}$ such that $\norm{U_C - U} < \varepsilon$.
:::

:::{.theorem}
There exists a universal gate set
:::
:::{.proof}
TODO (mirar cuál es más sencillo)
:::

#### Solovay-Kitaev theorem

:::{.theorem name="Solovay-Kitaev theorem"} 
[@DawsonSolovayKitaevalgorithm2005]

Let $\mathcal{G}$ be a universal gate set and $U$ a unitary operation.

There exists a constant $c$ such that $U$ can be approximated within $\epsilon$ accuracy by a sequence of $O(\log^c(1/\epsilon))$ gates from $\mathcal{G}$.
:::
:::{.proof}
TODO
:::

### What classical operations can be made quantum?

Classical operations can in principle be non-reversible, as is the case 

Toffoli gate, reversible classical computing, ancilla qubits...

1. ·”the value of the ancilla qubits will be independent of the value of the input”
2. Watrous Quantum proofs says only a linear amount is needed, why?
3. QDemocritus says as many as we wnat
3. Discuss uncomputation as in Quipper


## Quantum Turing Machines

Historically, the theory of quantum computation started with the *quantum Turing machine* model, a model built upon the classical Turing machine model. This section aims to define this model and show it is equivalent to the quantum circuit model, which has better properties when it comes to error correction.

:::{.definition}
TODO QTM
:::

:::{.theorem}
polynomial slowdown simulation
:::




# Quantum computability


\fxnote{Mirar si podemos poner O(T(n)) computable}

\fxnote{¿Dónde definimos la función que define un algoritmo como en el caso clásico?}

:::{.definition}
A **quantum algorithm** is a uniform family of quantum circuits $\mathcal{C} = \{C_n\}$ over a finite universal gate set.

We say the algorithm is *polynomial time* if the function $n \mapsto |C_n|$ is a polynomial.
:::

:::{.definition #dfn:qcomputable}
A function $f : \BB^\ast \to \BB^\ast$ is **quantum computable** if there exists 
a polynomial time quantum algorithm $\{C_n\}$ such that 

> for every $x \in \BB^\ast$, $P[C(\ket{x}) = f(x)] \geq \frac23$.
:::

Computability in the classical and quantum notions coincides; the behavior of a uniform family of quantum circuits can be simulated with at most exponential slowdown. Thus any quantum computable function can be computed classically.
The discussion on the section [What classical operations can be made quantum?] proves the other implication.

\fxnote{Discutir que el dominio podría ser distinto dada una codificación concreta.}

The interest lies therefore in studying complexity results, since, at least *a priori*, some functions might be able to be computed faster in the quantum model. 
The feasibly computable functions are, as in the classical an probabilistic case, those calculated in polynomial time.

:::{.definition}
A function $f : \BB^\ast \to \BB$ is **quantum polynomial time computable** if it is quantum computable by a family of circuits of polynomial size.
:::

As it happened in the probabilistic case, by [@prop:Chernoff] we can see that the constant $\frac{2}{3}$ in [@dfn:qcomputable] is irrelevant when talking about polynomial time; by repeatedly executing the quantum algorithm a polynomial number of times we can ensure correctness with any probability $c \in ]1/2,1[$. 

## Quantum time complexity: BQP

:::{.definition}
$L \in \mathsf{BQP}$ if and only if the characteristic function of $L$, $1_L: \BB^\ast \to \BB$ is a quantum polynomial time computable function.
:::

:::{.definition}
BQP/qpoly
:::

### BQP properties

:::{.proposition}
$\mathsf{BPP} \subseteq \mathsf{BQP}$
:::

Error correction

:::{.theorem}
$\mathsf{BQP}^\mathsf{BQP} = \mathsf{BQP}$
:::


2. BQP vs PH (Optional)

### Complete problems for BQP

:::{.definition}
TODO problem complete for BQP
:::


## Quantum proofs: QMA

:::{.definition #dfn:qma} 
[@VidickQuantumProofs2016; dfn. 3.1]

$L \in \mathsf{QMA}$ if and only if there exists 
a polynomial $p(n)$ and
a polynomial time quantum algorithm $\mathcal{V}$ such that

1. $l_{\mathcal{V}}(n) \leq p(n) + n$,
2. for every $x \in L$, $|x| = n$, there exists a quantum state $\ket{\psi}$ of at most $p(n)$ qubits (the *proof*) such that $$P[\mathcal{V}(\ket{x}\ket{\psi}) = 1] \geq \frac23 \text{ and}$$
3. for every $x \notin L$, $|x| = n$, and every quantum state $\ket{\psi}$ of at most $p(n)$ qubits $$P[\mathcal{V}(\ket{x}\ket{\psi}) = 1] \leq \frac13.$$
:::

If we look at [@prop:npverifier], we can see $\mathsf{QMA}$ is a straightforward generalization of $\mathsf{NP}$ to the quantum realm; thus we can easily guess the following proposition.

:::{.proposition}
$\mathsf{BQP}, \mathsf{NP} \subseteq \mathsf{QMA}$
:::
:::{.proof}
1. $\mathsf{BQP} \subseteq \mathsf{QMA}$.
   Let $L \in \mathsf{BQP}$. 
   Then there exists a polynomial time quantum algorithm $\mathcal{C}$ that computes $1_L$.
   In the affirmative case, any proof will suffice, while when $x \notin L$, 
   no proof will be correct with probability more than $\frac13$.
2. $\mathsf{NP} \subseteq \mathsf{QMA}$.
   Let $L \in \mathsf{NP}$.
   By [@prop:npverifier] there exists a classical verifier $V$, that can be made quantum by TODO.
   When $x \in L$, the proof will be the quantum state associated with the classical proof $y$ of $V$.
   Since the verifier answers with certainty, every condition on [@dfn:qma] holds.
:::

The constants $\frac23$ and $\frac13$ can be substituted by any $c \in ]\frac12,1[$, yet the proof in this case is not as straightforward as in the case of the previous classes. The problem lies in the quantum *no-cloning theorem*, that prevents us from copying the quantum proof and running the algorithm several times.

Two approaches are possible for this error reduction; either multiplying the length of the proof by a constant (known as *parallel error reduction*) or relying on the information of the *garbage* registers to reconstruct the proof and run the proof sequentally (*witness-preserving error reduction*) [@VidickQuantumProofs2016; sec. 3.2].
The latter process has the advantage of preserving the proof size yet its proof is somewhat more contrived.
Here we present a proof using parallel error reduction.

:::{.proposition name="QMA error reduction"}
TODO
:::

:::{.proposition}
BQP/qpoly is in QMA/poly 
:::
  
### Problems in QMA

:::{.definition}
GNM
:::

## Quantum space complexity

BQPSPACE == PPSPACE == PSPACE


## Further generalizations {.hidden}

Matrix representation of classical , probabilistic (stochastic matrices) and quantum computation.
Quaternionic computing
