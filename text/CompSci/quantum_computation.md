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

:::{.definition}
A function $f : \BB^\ast \to \BB^\ast$ is **quantum $T(n)$-time computable** if there exists a uniform family of $O(T(n))$ size quantum circuits such that 
:::

Computability in the classical and quantum notions coincides (exponential slowdown simulation).

## Quantum time complexity: BQP

:::{.definition}
$L \in \mathsf{BQP}$ if and only if there exists 
a polynomial $p(n)$ and 
a polynomial time uniform family of quantum circuits $\{C_n\}$ over a finite universal gate set $\mathcal{G}$ such that 

1. $l_C(n) = p(n)$ for every $n \in \NN$,
2. for every $x \in L$, $|x| = n$, $P[C_n(\ket{x}\ket{0}^{\otimes p(n) - n}) = 1] \geq \frac23$ and
3. for every $x \notin L$, $|x| = n$, $P[C_n(\ket{x}\ket{0}^{\otimes p(n) - n}) = 1] \leq \frac13$.
:::

:::{.definition}
BQP/qpoly
:::

### BQP properties

:::{.proposition}
$$\mathsf{BPP} \subseteq \mathsf{BQP}$$
:::

Error correction

:::{.theorem}
$$\mathsf{BQP}^\mathsf{BQP} = \mathsf{BQP}$$
:::


2. BQP vs PH (Optional)
### Complete problems for BQP

:::{.definition}
TODO problem complete for BQP
:::


## Quantum proofs: QMA

:::{.definition}
TODO QMA
:::

:::{.proposition}
BQP/qpoly is in QMA/poly 
:::

:::{.proposition}
QMA error correction
:::

:::{.proposition}
TODO BQP is in QMA
TODO NP is in QMA
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
