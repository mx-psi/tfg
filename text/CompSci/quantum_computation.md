\newpage
  
# Quantum computation models

## Quantum circuits

Analogous to the concept of classical or probabilistic circuits, this notion can be further generalized into the quantum realm. Recall that in [@dfn:circuit] we defined circuits as dependent on a basis of gates.

:::{.definition}
A *quantum gate* with $n$ inputs and $n$ outputs is a unitary operation $$U: Q^{\otimes n} \to Q^{\otimes n}.$$
:::

A *quantum basis* will be a set of quantum gates together with the following non-unitary operations,

1. The ANCILLARY gate, with $0$ inputs and $1$ output, that outputs a $\ket{0}$ qubit and
2. the DISCARD gate with $1$ input a $0$ outputs, that discards a qubit.

Notice that the FANOUT operation is missing due to [@prop:nocloning].

Thus,

:::{.definition}
A *quantum circuit* is a circuit with respect to a quantum basis.

A *unitary quantum circuit* is circuit with no ancillary or discard gates.
It has the same number of inputs and outputs.
:::

Note that the ancillary and discard gates are not operations allowed within the model presented in [A model of quantum mechanics] since they are not unitary; nonetheless every quantum circuit can be transformed into a unitary quantum circuit (its *unitary purification*) by the following process [@WatrousQuantumComputationalComplexity2009 sec III.3]

- every ancillary gate is replaced by a new input and 
- every discard gate is replace by an output.

Every unitary quantum circuit has an associated unitary operation from the inputs to the outputs:
given a topological sort of the nodes, we tensor each quantum gate with the identity matrix and compose the resulting unitary operations in order.
By applying the unitary purification this process can be extended to every quantum circuit.

Thus, every quantum circuit $C$ has an associated function that outputs a random variable;
if $C$ has $n$ inputs then given $\ket{\psi} \in Q^{\otimes n}$ we apply the associated unitary operation and measure with respect to the computational basis.
We denote this random variable by $C(\ket{\psi})$.

:::{.definition}
A *quantum circuit family* over a gate set $\mathcal{G}$ is a sequence $\mathcal{C} = \{C_n\}_{n \in \mathbb{N}}$ of quantum circuits such that for every $n \in \NN$, $C_n$ is a circuit over $\mathcal{G}$ with $n$ inputs.

We say a quantum circuit family is *uniform* if the function $1^n \mapsto \operatorname{enc}(C_n)$ is computable.
:::

Lastly, given a quantum state $\ket{\psi}$ of $n$ qubits and a quantum circuit family $\mathcal{C} = \{C_n\}_{n \in \mathbb{N}}$, we can get a random variable $\mathcal{C}(\ket{\psi}) = C_n(\ket{\psi})$ in an analogous manner.

### Universal quantum gate sets

#### The classical case

It is a well-known fact that, in the classical case, any function $f: \BB^\ast \to \BB^M$ can be computed exactly by a circuit (of at most exponential size) built using the basis of gates $$\{\operatorname{AND}, \operatorname{OR}, \operatorname{NOT}\}.$$
There are other possible basis universal in this sense, such as $\{\operatorname{NAND}\}$ or $\{\operatorname{NOR}\}$. Of course, not all basis are universal; a full classification of the basis is given by Post's lattice [@LauFunctionAlgebrasFinite2006].

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
https://github.com/cmdawson/sk/tree/master/src
:::

### Simulating classical operations

Classical and probabilistic operations can in principle be non-reversible, as is the case of the (linear extensions of) AND and OR gates, the NAND gate, the FANOUT gate or the RANDOM probabilistic gate.
For the quantum model to be a generalization of the probabilistic one we must be able to compute the same functions in a reversible manner.

This can be done thanks to the use of ancillary qubits.
In the following discussion, let $\ket{x}$, $ket{y}$ and $\ket{z}$ be classical states, 
that is states from the computational basis.

Recall from [@prop:quantumOps] the Toffoli gate, that maps $\ket{x,y,z} \mapsto \ket{x,y,z \oplus xy}$. 
By using an ancillary qubit on $z$ and discarding qubits $x,y$ we can simulate a NAND gate, that is 
$$\operatorname{TOFFOLI}\ket{x,y,1} = \ket{x,y}\operatorname{NAND}\ket{x}\ket{y}.$$
This therefore allows us to simulate any classical logical gate.

Similarly, the FANOUT gate can be simulated by using a CNOT gate,
$$\operatorname{CNOT}\ket{x}\ket{0} = \ket{x}\ket{x}.$$
This is not a contradiction with [@prop:nocloning], since we are only cloning classical states.

Lastly, the RANDOM gate can be simulated with the aid of a Hadamard gate, since
$$H\ket{0} = \frac{1}{\sqrt{2}}(\ket{0} + \ket{1}),$$
and therefore when measuring with respect to the computational basis we have a random bit.

These equivalences can be seen on figure TODO.

Since any probabilistic function can be computed by a probabilistic circuit composed by NAND, FANOUT, ANCILLARY and RANDOM gates (see TODO), we can simulate it on a quantum computer by replacing each gate by its simulation.

In general, the unitary purification of the quantum circuit obtained in this way gives us for a function $f : \BB^N \to \BB^M$ a reversible function that maps $$\ket{x}\ket{c} \mapsto \ket{x}\ket{c \oplus f(x)},$$
which uses an extra polynomial amount of wires and gates.


::::::{.comment}
## Quantum Turing Machines

Historically, the theory of quantum computation started with the *quantum Turing machine* model, a model built upon the classical Turing machine model. This section aims to define this model and show it is equivalent to the quantum circuit model, which has better properties when it comes to error correction.
An advantage of quantum Turing machines are that they allow us to define $\operatorname{BQTIME}$ easily.

:::{.definition}
TODO QTM
:::

:::{.theorem}
polynomial slowdown simulation
:::
::::::



# Quantum computability

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
The discussion on the section [Simulating classical operations] proves the other implication.

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
:::{.proof}
Let $L \in \mathsf{BPP}$.
Then, by TODO there exists a probabilistic circuit that decides $L$.
Without loss of generality we may assume that the circuit is composed by NAND, FANOUT, ANCILLARY and RANDOM gates.

Then, by the discussion on sec. [Simulating classical operations], we can create a quantum circuit by replacing each gate with its simulation. If the original circuit has a polynomial number of gates, the resulting quantum circuit will also have a polynomial number of gates.

Furthermore, the output random variable will be the same, and thus the $\frac23$ bounds will be met.
Hence, $L \in \mathsf{BQP}$.
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
   When $x \in L$, any proof will suffice, while when $x \notin L$, 
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
