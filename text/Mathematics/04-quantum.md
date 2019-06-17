# Quantum computation models

## Quantum circuits

Analogous to the concept of classical or probabilistic circuits, this notion can be further generalized into the quantum realm. Recall that in [@dfn:circuit] we defined circuits as dependent on a basis of gates.

:::{.definition}
A *quantum gate* with $n$ inputs and $n$ outputs is a unitary operation $$U: Q^{\otimes n} \to Q^{\otimes n}.$$
:::

A *quantum basis* will be a set of quantum gates together with the following non-unitary operations,

1. The ANCILLARY gate, with $0$ inputs and $1$ output, that outputs a $\ket{0}$ qubit and
2. the DISCARD gate with $1$ input a $0$ outputs, that discards a qubit.

A quantum equivalent to the FANOUT operation is missing due to [@prop:nocloning].

Thus,

:::{.definition}
A *quantum circuit* is a circuit with respect to a quantum basis.

A *unitary quantum circuit* is a quantum circuit with no ancillary or discard gates.
It has the same number of inputs and outputs.
:::

The ancillary and discard gates are not operations allowed within [the quantum model](#a-model-of-quantum-mechanics) since they are not unitary; nonetheless every quantum circuit can be transformed into a unitary quantum circuit:

:::{.definition #dfn:purification}
 (@WatrousQuantumComputationalComplexity2009, sec III.3)
 
Let $C$ be a quantum circuit.
The  *unitary purification* of $C$ is a unitary quantum circuit $C'$ constructed by the following process

- every ancillary gate is replaced by a new input and 
- every discard gate is replace by an output.
:::

A unitary quantum circuit has an associated unitary function, whose construction is given in the following definition.

:::{.definition #dfn:unitaryop}
Let $C$ be a unitary quantum circuit with $n$ inputs and outputs.
The function associated with the quantum circuit, $C:Q^{\otimes n} \to Q^{\otimes n}$ is constructed as follows

1. Construct a topological sort of the gates of $C$, that is, a way of sorting the gates such that if there is a wire from $g_1$ to $g_2$, then $g_1 \leq g_2$.
2. Tensor each quantum gate with the identity matrix to construct an unitary operation on $Q^{\otimes n}$.
3. Compose the resulting unitary operations in reverse order.
:::

Step 1 is possible since the graph associated to a circuit is acyclic.
The independence of the construction from the chosen topological sort is given by the identity 
$$(f \circ g) \otimes (h \circ s) = (f \otimes h) \circ (g \otimes s).$$

Using the previous definitions, every quantum circuit $C$ has an associated function that outputs a random variable;
if $C$ has $n$ inputs then given $\ket{\psi} \in Q^{\otimes n}$ we apply the operation of its unitary purification to the tensor product of $\ket{\psi}$ by the original values of the ancillary qubits and measure with respect to the computational basis.
Finally, we discard the outputs that originally were a DISCARD gate.

We denote this random variable also by $C(\ket{\psi})$.
Restricting the measurement to the original outputs would give the same random variable; this is known as the *Principle of unterminated wires* in the literature (@NielsenQuantumComputationQuantum2010).

The concept of circuit family is analogous to the classical and probabilistic cases:

:::{.definition}
A *quantum circuit family* over a gate set $\mathcal{G}$ is a sequence $\mathcal{C} = \{C_n\}_{n \in \mathbb{N}}$ of quantum circuits such that for every $n \in \NN$, $C_n$ is a circuit over $\mathcal{G}$ with $n$ inputs.
:::

Lastly, given a quantum state $\ket{\psi}$ of $n$ qubits and a quantum circuit family $\mathcal{C} = \{C_n\}_{n \in \mathbb{N}}$, we can get a random variable $\mathcal{C}(\ket{\psi}) = C_n(\ket{\psi})$ in an analogous way.

### Universal quantum gate sets

#### The classical case

It is a well-known fact that, in the classical case, any function $f: \BB^\ast \to \BB^\ast$ can be computed exactly by a circuit (of at most exponential size) built using the basis of gates $$\{\operatorname{AND}, \operatorname{OR}, \operatorname{NOT}\}.$$
There are other possible basis universal in this sense, such as $\{\operatorname{NAND}\}$ or $\{\operatorname{NOR}\}$. Of course, not all basis are universal; a full classification of the basis is given by Post's lattice (@LauFunctionAlgebrasFinite2006).


Given two finite universal basis $B_1$ and $B_2$ one may construct every element of the latter with a circuit made of gates of the former. 
The size of a family of circuits transformed in this manner increases only up to a constant and thus, in the classical case this discussion concludes with the following trivial proposition:

:::{.proposition}
Let $B_1$, $B_2$ two finite universal basis, that is, two basis of gates that allow us to construct a circuit that computes an arbitrary function $f: \BB^N \to \BB^M$.

Given a family of circuits with respect to $B_1$ that has size $O(f(n))$, there exists a family of circuits with respect to $B_2$ that computes the same function and has size $O(f(n))$.
:::

The main consequence from this proposition is that the chosen basis is irrelevant for proving there exists a family of a certain (asymptotic) size. 
A similar result can be stated for probabilistic circuits by using [@prop:randomSource].

This section aims to prove a similar (yet weaker) result for quantum circuits.
This result is of great theoretical importance, since we do not currently understand what quantum operations are physically realizable, and thus would like to build a theory independent of any specific quantum gate basis. 

#### Quantum universal gate sets

The set of unitary operations over a fixed Hilbert space can be seen as a group by considering the composition operation and as a normed space by considering the usual *operator norm*.

:::{.definition}
A set of quantum gates $\mathcal{G}$ is *universal* if for every $\varepsilon > 0$ and every unitary operation $U$ there exists a quantum circuit $C$ over $\mathcal{G}$ such that $\norm{U_C - U} < \varepsilon$.
:::

Several universal gate sets are described in the literature. 
For example, a minimal universal gate set can be obtained with probability 1 by combining the CNOT with a single qubit gate (@AaronsonLecturenotes28th2016, sec. 2.1).

We now present an example of a universal gate set, which is not minimal but will serve our purposes.

:::{.theorem}
(@NielsenQuantumComputationQuantum2010, sec. 4.5.3)

$\{\operatorname{CNOT}, H, R_{\pi/4}\}$  is a universal gate set.
:::
:::{.proof name="Proof sketch"}

We present a brief proof sketch adapted from (@NielsenQuantumComputationQuantum2010, sec. 4.5.3).

A *two-level unitary operation* is a unitary operation that acts different from the identity in at most two computational basis states. The first step towards proving the theorem is to prove that these gates form an (infinite) universal gate set.

:::{.claim}
(@NielsenQuantumComputationQuantum2010, sec. 4.5.1)
The set of two-level unitary operations is a universal gate set.
:::

This can be easily shown to be the case by constructing matrices whose multiplication zero-out the components of a unitary matrix.
Using this claim we can prove:

:::{.claim}
(@NielsenQuantumComputationQuantum2010, sec. 4.5.2)
The set of single qubit gates together with the CNOT gate forms a universal gate set.
:::

To prove this claim we use the previous claim and construct an arbitrary two-level unitary gate by appropiately composing single qubit gates and the CNOT gate so that they are applied to the basis states that we need.

Lastly, to prove the theorem, it is shown that $\{H, R_{\pi/4}\}$ can approximate an arbitrary rotation of the qubit Hilbert space from any axis. This, together with a decomposition of an arbitrary single-qubit gate into these rotations, proves that $\{H, R_{\pi/4}\}$ can approximate any single qubit gate, which using the last lemma proves the result.
:::


#### Solovay-Kitaev theorem

The previous theorem does not mention how "fast" the gates can be approximated; 
this is, what the asymptotic change of size of a circuit family would be if we were to replace the gates on it by approximations.
This is crucial information; without it we would be unable to construct a theory independent of the universal gate set, and thus it would be unclear whether a certain algorithm would be efficient in practice.

The *Solovay-Kitaev Theorem* shows that the approximation can be done in quasi-logarithmic time for *any* universal gate set.
This celebrated result is essential for the usefulness of certain algorithms, such as Grover's algorithm.

:::{.theorem name="Solovay-Kitaev theorem" #thm:solovay} 
[@dawson2005]

Let $\mathcal{G}$ be a universal gate set closed under inverses and $U$ a unitary operation.

There exists a constant $c$ such that $U$ can be approximated within $\epsilon$ accuracy by a sequence of $O(\log^c(1/\epsilon))$ gates from $\mathcal{G}$.
:::
:::{.proof name="Proof sketch"}

What follows is a proof sketch adapted from [@dawson2005].

Let $n \in \NN$.
A recursive algorithm can be defined that returns the sequence of gates that approximates $U$.
This algorithm gives more accurate and longer sequences depending on $n$.

For $n = 0$, we consider a basic approximation up to a certain accuracy $\varepsilon_0$.
This approximation can be done for any gate by considering all possible sequences of gates up to a certain length.

If $n > 1$, we consider the approximation given by $n-1$, $U_{n-1}$.
Then, let $\Delta = U_{n-1}U^{\dagger}_{n-1}$, where $U^{\dagger}_{n-1}$ is the adjoint of $U_{n-1}$ (see [@dfn:adjoint]).
We can express $\Delta$ as the conmutator of two unitary operators $V,W$, that is
$$\Delta = [V,W] = VWV^\dagger W^\dagger,$$
such that $V$ and $W$ are close enough to the identity.

We then find approximations to $V$ and $W$ of depth $n-1$, $V_{n-1}, W_{n-1}$ and return as the approximation of depth $n$ $$U_n = [V_{n-1},W_{n-1}]U_{n-1}.$$
This turns out to be an approximation up to an accuracy of order $\varepsilon_n = c_{\operatorname{approx}}\varepsilon_{n-1}^{3/2}$.

This defines a sequence such that, to obtain an accuracy $\varepsilon$, we need to get an approximation of depth logarithmic on the length of $\varepsilon$ which in turns gives a sequence of length
$$O(\operatorname{ln}^{\operatorname{ln}(5)/\operatorname{ln}(3/2)}(1/\varepsilon)),$$
which fulfills the conditions of the theorem.
:::

Suppose a certain family of quantum circuits has $O(f(n))$ size.
[@thm:solovay] states then that there is an $\varepsilon$-approximation by any universal quantum gate set of the family by another family that has $O(f(n)\log(f(n)/\varepsilon))$ size.
If $f(n) \in \poly(n)$, this gives us a *poly-logarithmic time* family.


### Simulating classical operations

Classical and probabilistic operations can in principle be non-reversible, as is the case of the (linear extensions of) AND and OR gates, the NAND gate, the FANOUT gate or the $\operatorname{RANDOM}(1/2)$ probabilistic gate.
For the quantum model to be a generalization of the probabilistic one we must be able to compute the same functions in a reversible manner.

This can be done thanks to the use of ancillary qubits.
In the following discussion, let $\ket{x}$, $\ket{y}$ and $\ket{z}$ be classical states, 
that is states from the computational basis.

Recall from [@prop:quantumOps] the Toffoli gate, that maps $\ket{x,y,z} \mapsto \ket{x,y,z \oplus xy}$. 
By using an ancillary qubit on $z$ and discarding qubits $x,y$ we can simulate a NAND gate, that is 
$$\operatorname{TOFFOLI}\ket{x,y,1} = \ket{x,y}\operatorname{NAND}\ket{x}\ket{y}.$$
This therefore allows us to simulate any classical logical gate.

Similarly, the FANOUT gate can also be simulated by using a TOFFOLI gate,
$$\operatorname{TOFFOLI}\ket{x}\ket{1}\ket{0} = \ket{1}\ket{x}\ket{x}.$$
This is not a contradiction with [@prop:nocloning], since we are only cloning classical states.

Lastly, the $\operatorname{RANDOM}(1/2)$ gate can be simulated with the aid of a Hadamard gate, since
$$H\ket{0} = \frac{1}{\sqrt{2}}(\ket{0} + \ket{1}),$$
and therefore when measuring with respect to the computational basis we have a random bit.

These equivalences can be seen on [@fig:probSimulation].

<div id="fig:probSimulation">
![The TOFFOLI gate symbol.](assets/toffoli.pdf){width=40%}
![NAND simulation.](assets/nand.pdf){width=50%}

![FANOUT simulation.](assets/fanout.pdf){width=50%}
![$\operatorname{RANDOM}(1/2)$ simulation.](assets/random.pdf){width=50%}

![AND gate simulated composing NAND gates.](assets/and.pdf){width=100%}

Reversible simulation of the probabilistic gate basis.
Made with Quipper.
</div>

Clearly, we can then simulate any probabilistic circuit on a quantum computer by replacing each gate by its simulation.

In general, the unitary purification of the quantum circuit obtained in this way gives us for a function $f : \BB^N \to \BB^M$ a reversible function that maps $$\ket{x}\ket{c} \mapsto \ket{x}\ket{c \oplus f(x)},$$
which uses an extra polynomial amount of wires and gates.

## Quantum computability

In this section we define what it means for a function to be efficiently computed by a quantum computer.

:::{.definition #dfn:qalgo}
A **quantum algorithm** is a uniform family of quantum circuits $\mathcal{C} = \{C_n\}$ over a finite universal gate set.

We say the algorithm is *polynomial time* if the function $1^n \mapsto C_n$ can be computed in polynomial time.
:::


Computability in the classical and quantum notions coincides; the behavior of a uniform family of quantum circuits can be simulated with at most exponential slowdown. Thus any quantum computable function can be computed classically.
The [quantum simulation of classical operations](#simulating-classical-operations) proves the other implication.

The interest lies therefore in studying complexity results, since, at least *a priori*, some functions might be able to be computed faster in the quantum model.
The feasibly computable functions are, as in the classical and probabilistic case, those calculated in polynomial time. Analogous to the probabilistic case, we define quantum computability with bounded error.

:::{.definition #dfn:qcomputable}
A function $f : \BB^\ast \to \BB^\ast$ is (polynomial time) **quantum computable** if there exists
a (polynomial time) quantum algorithm $\{C_n\}$ such that

> for every $x \in \BB^\ast$, $P[C(\ket{x}) = f(x)] \geq \frac23$.
:::

As it happened in the probabilistic case, by [@prop:Chernoff] we can see that the constant $\frac{2}{3}$ in [@dfn:qcomputable] is irrelevant when talking about polynomial time; by repeatedly executing the quantum algorithm a polynomial number of times we can ensure correctness with any probability $c \in ]1/2,1[$.

Furthermore, [@thm:solovay] shows that [@dfn:qcomputable] is independent from the chosen universal gate set: we may approximate it with an $\varepsilon$ sufficiently small so as to remain above the $\frac12$ threshold and we may do so in polynomial time if we are interested in efficiently computable functions.

## Quantum time complexity

In the realm of complexity classes, the set of languages that can be efficiently decided by a quantum computer is formalized in the class $\mathsf{BQP}$.

:::{.definition}
$L \in \mathsf{BQP}$ if and only if the characteristic function of $L$, $1_L: \BB^\ast \to \BB$ is a quantum polynomial time computable function.
:::

Any language efficiently decidable in the probabilistic case is also efficiently decidable in the quantum case.

:::{.proposition}
$\mathsf{BPP} \subseteq \mathsf{BQP}$
:::
:::{.proof}
Let $L \in \mathsf{BPP}$.
There exists a $O(p(n))$ sized uniform family of probabilistic circuits $\{C_n\}$ that decides $L$.

Let $n \in \NN$.
Consider the circuit $C'_n$ formed by replacing every gate by its quantum simulation,
as described in section [Simulating classical operations].

$|C'n|$ is bounded above by $4|C_n|$, since the simulation of any probabilistic gate on the standard gate set can be done with at most 4 quantum gates.
Therefore the family $\{C'_n\}$ is also $O(p(n))$ sized.

Their associated random variables for each input are identical, and thus the probability bound is achieved.
:::

Furthermore, a classical upper bound on $\mathsf{BQP}$ can be given.
Consider the following class:

:::{.definition}
$L \in \mathsf{PQP}$ if and only if there exists
a quantum polynomial time algorithm $\mathcal{C} = \{C_n\}$ such that

1. for every $x \in L$,    $P[\mathcal{C}(x) = 1] > \frac12$ and
2. for every $x \notin L$, $P[\mathcal{C}(x) = 1] \leq \frac12$.
:::

This class is the quantum equivalent of $\mathsf{PP}$, that is, a class like $\mathsf{BQP}$ where the probability bounds have been relaxed.
As such, it is clear that $\mathsf{BQP} \subseteq \mathsf{PQP}$.

The following theorem shows that when these bounds are relaxed quantum computers provide no more than polynomial advantage.

:::{.theorem #thm:pqp}
$\mathsf{PQP} = \mathsf{PP}$
:::
:::{.proof name="Proof sketch"}
The following proof sketch is adapted from (@WatrousQuantumComputationalComplexity2009, sec. IV.5).

A function $f : \BB^\ast \to \ZZ$ is $\operatorname{GapP}$ if there exists a non-deterministic Turing Machine $M$ such that for any $x$, $f(x)$ is the difference of the number of accepting paths and the number of rejecting paths of $M$ with input $x$.

A simple characterization of $\mathsf{PP}$ is that there exists a function $f \in \operatorname{GapP}$ such that 
$f(x) > 0$ if and only if $x \in L$.

[@FortnowComplexityTheoryRetrospective1997] proves the following claim:

:::{.claim}
Let $p,q \in \poly(n)$.

For each $n$, let $A_n,1, \dots, A_n,p(n) \in \mathcal{M}_{2^{q(n)} \times 2^{q(n)}}(\mathbb{C})$ be a sequence of matrices.

If there exist $f,g \in \operatorname{GapP}$ functions such that
$$f(1^n, 1^k, i,j) = \operatorname{Re}(A_{n,k}(i,j)) \text{ and }$$
$$g(1^n, 1^k, i,j) = \operatorname{Im}(A_{n,k}(i,j)),$$
where $i,j$ are written in binary, then there exists $F,G \in \operatorname{GapP}$ functions such that
$$F(1^n, i, j)= \operatorname{Re}((A_{n,p(n)} \dots A_{n,k})(i,j)) \text{ and }$$
$$G(1^n, i, j)= \operatorname{Im}((A_{n,p(n)} \dots A_{n,k})(i,j)).$$
:::

If $L \in \mathsf{PQP}$ then, there exists a uniform polynomial family of quantum circuits $\mathcal{C}$ that decides the language. Furthermore, a universal gate set may be chosen such that every gate has rational coefficients.

The procedure stated at [@dfn:unitaryop] gives us then a sequence of matrices that verifies the conditions of the claim: 

- It is polynomial and polynomial-sized because of the size of the circuits and
- since it is uniform and the gates have rational coefficients, 
  the functions $f$ and $g$ can be constructed for each matrix.
  
Applying the claim we then have a $\operatorname{GapP}$ function such that 
$$P[\mathcal{C}(x) = 1] = \frac{F(x)}{2^{p(|x|)}},$$
and therefore by taking $h(x) = F(x) - 2^{p(|x|) - 1}$ we have that $L \in \mathsf{PP}$.
:::


Thus, the probabilistic class $\mathsf{PP}$ and therefore the classical class $\mathsf{PSPACE}$ are non-quantum upper bounds of the $\mathsf{BQP}$ class.
This shows that the power of quantum computers is limited to what classical computers can do in polynomial space.

<!-- TODO :::{.theorem name="Subroutine theorem"} -->
<!-- $\mathsf{BQP}^\mathsf{BQP} = \mathsf{BQP}$ -->
<!-- ::: -->


## Quantum verifiers

Following the chapters on classical and probabilistic models of computation, it is now natural to consider quantum verifiers.
In this kind of verifiers both the proof and the verifier are quantum.

:::{.definition #dfn:qma}
(@VidickQuantumProofs2016, dfn. 3.1)

$L \in \mathsf{QMA}$ if and only if there exists
a polynomial $p(n)$ and
a polynomial time quantum algorithm $\mathcal{V}$ such that

1. for every $x \in L$, $|x| = n$, there exists a quantum state $\ket{\psi}$ of at most $p(n)$ qubits (the *proof*) such that $$P[\mathcal{V}(\ket{x}\ket{\psi}) = 1] \geq \frac23 \text{ and}$$
2. for every $x \notin L$, $|x| = n$, and every quantum state $\ket{\psi}$ of at most $p(n)$ qubits $$P[\mathcal{V}(\ket{x}\ket{\psi}) = 1] \leq \frac13.$$
:::

If we look at [@prop:npverifier], we can see $\mathsf{QMA}$ is a straightforward generalization of $\mathsf{NP}$ (and $\mathsf{MA}$) to the quantum realm; thus we can easily guess the following proposition.

:::{.proposition}
$\mathsf{BQP}, \mathsf{MA} \subseteq \mathsf{QMA}$
:::
:::{.proof}
1. $\mathsf{BQP} \subseteq \mathsf{QMA}$.
   Let $L \in \mathsf{BQP}$.
   Then there exists a polynomial time quantum algorithm $\mathcal{C}$ that computes $1_L$.
   When $x \in L$, any proof will suffice, while when $x \notin L$,
   no proof will be correct with probability more than $\frac13$.
2. $\mathsf{MA} \subseteq \mathsf{QMA}$.
   Let $L \in \mathsf{MA}$.
   By definition, there exists a probabilistic verifier $M$, that can be made quantum by replacing each gate with its simulation.
   When $x \in L$, the proof will be the quantum state associated with the classical proof $y$ of $M$.
   The probability bounds hold since they are identical in each class.
:::

There is an obvious similarity between the $\mathsf{P}$ vs. $\mathsf{NP}$ problem and the $\mathsf{BQP}$ vs. $\mathsf{QMA}$ problem (the latter are also believed to be different).
Nonetheless, there is no known formal result that relates the two problems, that is, separating one pair of classes would give us, in principle, no information about the other pair (@AaronsonmathsfBQPvsmathsfQMA2010).

The constants $\frac23$ and $\frac13$ can be substituted by any $c \in ]\frac12,1[$, yet the proof in this case is not as straightforward as in the case of the previous classes. The problem lies in the quantum *no-cloning theorem*, that prevents us from copying the quantum proof and running the algorithm several times.

Two approaches are possible for this error reduction; either multiplying the length of the proof by a constant (known as *parallel error reduction*) or relying on the information of the *garbage* registers to reconstruct the proof and run the proof sequentally (*witness-preserving error reduction*) (@VidickQuantumProofs2016, sec. 3.2).
The latter process has the advantage of preserving the proof size yet its proof is somewhat more contrived.

These give rise to the following proposition.

:::{.proposition name="QMA error reduction" #prop:qmaerror}
(@VidickQuantumProofs2016, sec. 3.2)

Let $c \in ]\frac12,1[$. 

Then $L \in \mathsf{QMA}$ if and only if there exists
a polynomial $p(n)$ and
a polynomial time quantum algorithm $\mathcal{V}$ such that

1. for every $x \in L$, $|x| = n$, there exists a quantum state $\ket{\psi}$ of at most $p(n)$ qubits (the *proof*) such that $$P[\mathcal{V}(\ket{x}\ket{\psi}) = 1] \geq c \text{ and}$$
2. for every $x \notin L$, $|x| = n$, and every quantum state $\ket{\psi}$ of at most $p(n)$ qubits $$P[\mathcal{V}(\ket{x}\ket{\psi}) = 1] \leq 1-c.$$
:::
:::{.proof name="Proof sketch"}
Although we omit the proof, a brief sketch of the proof in the parallel case can be given, 
adapted from (@VidickQuantumProofs2016, sec. 3.2).

Let $L \in \mathsf{QMA}$, and let $\mathcal{V}$ be a verifier for $L$.
For a given $x \in L$, we call a valid proof $\ket{\psi_x} \in Q^{\otimes p(|x|)}$.

We create a verifier $\mathcal{V}'$ that takes as a proof of length at most $Tp(|x|)$ qubits for a certain $T \in \NN$. $\mathcal{V}'$ takes groups of $p(|x|)$ qubits and runs verifier $\mathcal{V}$ on them, outputting the majority vote.

Clearly, $\ket{\psi_x}^{\otimes T}$ would be a valid proof for $\mathcal{V}'$, and by applying [@prop:Chernoff] we can choose an appropiate $T$ such that condition 1 is fulfilled.

What remains is showing that there is no possibility of taking advantage of the new verifier by using some superposition.
This analysis can be done by considering the verifier as a measurement operator, which is outside the scope of this text.
:::

[@prop:qmaerror] shows that we can prove a similar result to [@prop:nppp], namely:

:::{.proposition}
(@WatrousQuantumComputationalComplexity2009, sec V.4)

$\mathsf{QMA} \subseteq \mathsf{PP}$
:::
:::{.proof}
By [@thm:pqp], we know that $\mathsf{PQP} = \mathsf{PP}$, 
thus, it suffices to prove $\mathsf{QMA} \subseteq \mathsf{PQP}$.

The proof of this result is then identical to [@prop:nppp], using quantum circuits and adjusting for the probability bound of $\mathsf{QMA}$ as was suggested for $\mathsf{MA}$.
:::

This result gives us information about the tightness of the upper bound of $\mathsf{BQP}$ by $\mathsf{PP}$.
The chain $\mathsf{BQP} \subseteq \mathsf{QMA} \subseteq \mathsf{PP}$ hints that the bound is not very tight, since quantum proofs are presumed to have higher computational power than quantum algorithms. 


The complete diagram of relationships between quantum, probabilistic and classical complexity classes is shown in [@fig:diagram].

![The hierarchy of classical, probabilistic and quantum complexity classes. 
Inclusions are represented by an arrow from the subset to the superset. 
Dashed lines indicate the two classes are conjectured to be equal](assets/quantum.pdf){#fig:diagram width=60%}


<!-- :::{.proposition} -->
<!-- BQP/qpoly is in QMA/poly -->
<!-- ::: -->
  
<!-- ### Problems in QMA -->

<!-- :::{.definition} -->
<!-- GNM -->
<!-- ::: -->


<!-- ## Quantum space complexity -->

<!-- BQPSPACE == PPSPACE == PSPACE -->


<!-- ## Further generalizations {.hidden} -->

<!-- <\!-- Matrix representation of classical , probabilistic (stochastic matrices) and quantum computation. -\-> -->
<!-- <\!-- Quaternionic computing -\-> -->

