# A model of quantum mechanics

The study of quantum computers requires us to state the basic principles and mathematical structures this physical theory is based on.
The physical systems considered in the theory of quantum computation are finite dimensional, yet in the general case physical systems are described by a system with possible infinite dimensions.
In this section we describe five principles that describe quantum mechanical systems at the appropriate level for the development of the theory of quantum computation.
We follow the presentation given at [@NielsenQuantumComputationQuantum2010 chap. 2] and [@LiptonQuantumalgorithmslinear2014 chap. 1].


## State space and bra-ket notation

\fxnote{El modelo asume que no hay ruido. Podría discutir la corrección de errores brevemente. Ver Parte 3 de Nielsen.}

A concrete state of an isolated physical system is described by a **state vector** that belongs to a **state space**.
In the case of quantum mechanics these are described by (projective) Hilbert spaces.

:::{.definition}
A (complex) **pre-Hilbert space** is a pair $(H,\bk{\cdot}{\cdot}: H^2 \to \CC)$ such that

#. $H$ is a complex vector space,
#. $\bk{\cdot}{\cdot}$ (the *product*) is *sesquilinear*, that is, if $u,v \in H$ and $\alpha, \beta \in \CC$, $\bk{u}{v} = \overline{\bk{v}{u}}$ and $$\bk{\alpha u + \beta v}{w} = \overline{\alpha}\bk{u}{w} + \overline{\beta}\bk{v}{w}\,,$$
#. $\bk{\cdot}{\cdot}$ is *definite positive*, that is, if $v \in H$, $\bk{v}{v} \geq 0$ and $\bk{v}{v} = 0 \iff v = 0$.

An **orthonormal basis** of $H$ is a basis $\{u_i\}_{i \in I}$ of $H$ as a vector space such that $\bk{u_i}{u_j} = \delta_{ij}$.

The product of a pre-Hilbert space induces a norm over $H$ given by $\norm{v} = \sqrt{\bk{v}{v}}$.
A **Hilbert space** is a pre-Hilbert space such that $(H,\norm{\cdot})$ is complete.
:::

Every finite dimensional normed space over $\CC$ is complete, therefore if $H$ is a finite dimension pre-Hilbert space then $H$ is a Hilbert space.
We will focus on this scenario when dealing with quantum computers; all the Hilbert spaces considered will be finite dimensional. Vectors in quantum computer science are usually written as a *ket* between $|$ and $\rangle$.
\fxnote{El caso infinito-dimensional se conoce como "continous variable quantum computation". Podría discutirlo brevemente.}


The canonical finite dimensional Hilbert space of dimension $N$ is $\CC^N$ with product given by
$$\bk{u}{v} = \sum_{j=1}^N \overline{u_j}v_j \quad \text{ where } u = (u_1, \dots, u_N), v = (v_1, \dots, v_N)$$
An orthonormal basis of $\CC^N$ is the computational basis of $\CC^N$ as a vector space $B = \{\ket{e_i}\}_{i = 1, \dots, N}$.
Every finite dimensional Hilbert space of dimension $N$ is isomorphic to $\CC^N$, by taking its coordinates over an orthonormal basis, thus we will focus on these spaces.

An alternative way of considering this inner product is by the use of the *adjoint*.

:::{.definition}
Let $A \in \mathcal{M}_{N \times N}(\CC)$. The **adjoint** or **conjugate transpose** of $A$, $A^\dagger$, is given by $$(A^\dagger)_{ij} = \overline{A}_{ji}.$$
:::

Given a vector $\ket{v} \in \CC^N$ we define $\bra{v} = \ket{v}^\dagger$ (by considering $\ket{v}$ as a matrix).
That way $\bra{u} \cdot \ket{v} = \bk{u}{v}$, which justifies the notation.


:::{.definition}
The **projective Hilbert space** $P(H)$ of a Hilbert space $H$ is the quotient of $H\backslash \{0\}$ under the relation
$$x \sim y \iff \exists \lambda \in \mathbb{C}\backslash\{0\}: \; x = \lambda y$$
:::

Thus, each element of a Hilbert space is a subspace of dimension 1 called a *ray*.

:::{.principle #ppl:state}
The state space of an isolated (quantum) physical system is the projective space associated with a complex separable Hilbert space (also called state space).
:::

Thus, the state vectors of an isolated physical system are *rays* on a Hilbert space.
We will identify a ray with a unit vector that generates it. 
This unit vector is unique up to a constant of the form $e^{i\theta}$ with $\theta \in \mathbb{R}$.

A **qubit** is an isolated physical system with state space $\PC^2$ in which we fix an orthonormal basis $\ket{0}, \ket{1}$ (called the *computational basis*).
The term is also used to refer to an element of this state space; using the identification of rays with unit vectors a qubit can also refer to a vector 
$$\ket{\psi} = \alpha\ket{0} + \beta\ket{1} \quad \text{such that } \norm{\ket{\psi}} = |\alpha|^2 + |\beta|^2 = 1$$

## Composite systems

A physical system may be composed of several separate subsystems. 
The relationship between the state spaces of the subsystems and the composite system is given by the tensor product, which is justified by the following result: \fxnote{Podría definir el producto tensorial de espacios vectoriales}

:::{.proposition}
Let $H_1, H_2$ be finite dimensional Hilbert spaces with orthonormal basis $B_1 = \{u_i\}_{i \in I}, B_2 = \{v_j\}_{j \in J}$ respectively. 
Then $H_1 \otimes H_2$ is a finite dimensional Hilbert space with inner product given by the linear extension of $$\bk{u \otimes v}{u' \otimes v'} = \bk{u}{u'}\bk{v}{v'}$${#eq:tensorscalar} and $B_1 \otimes B_2 = \{u_i \otimes v_j\}_{(i,j) \in I \times J}$ is an orthonormal basis.
:::
:::{.proof}

By definition $H_1 \otimes H_2$ is a complex vector space with $\dim(H_1 \otimes H_2) = \dim(H_1)\dim(H_2)$ and $B_1 \otimes B_2$ is a basis of it. 
Furthermore
$$\bk{u_i \otimes v_j}{u_l \otimes v_k} = \bk{u_i}{u_l}\bk{v_j}{v_k} = \delta_{il}\delta_{jk}$${#eq:orthonormal}
which is equal to one if and only if $i = l$ and $j = k$ and it is zero otherwise.

It suffices to prove that the product is definite positive.
Let $v \in H_1 \otimes H_2$. Since $B_1 \otimes B_2$ there exists unique $\alpha_{ij} \in \CC$ such that $$v = \sum_{i,j} \alpha_{ij}(u_i \otimes v_j)\,.$$
and by linearity
$$\bk{v}{v} = \sum_{i,j,k,l} \alpha_{il}\alpha_{jk}\bk{u_i \otimes v_j}{u_l \otimes v_k} = \sum_{i,j} \alpha_{ij}^2 \geq 0\,,$$
Furthermore $\bk{v}{v} = 0 \iff \sum_{i,j} \alpha_{ij}^2 = 0 \iff \alpha_{ij} = 0 \;\forall i,j$.

Therefore $H_1 \otimes H_2$ is a Hilbert space with the previously defined Hilbert product and by [@eq:orthonormal] we know that $B_1 \otimes B_2$ is therefore an orthonormal basis.
:::


Therefore we can write:

:::{.principle}
The state space of a composite system is the tensor product of the state spaces of the subsystems.

The state vector of a composite system is the tensor product of the state vectors of the subsystems.
:::

We will write $\ket{\phi\psi} := \ket{\phi}\ket{\psi} := \ket{\phi} \otimes \ket{\psi}$.
As in [@ppl:state], we take the projective Hilbert space and work with the rays.
By [@eq:tensorscalar] the tensor product of two unit vectors is a unit vector and thus we can take the tensor product of the representatives of two rays as a unit norm representative of the tensor product of the rays.


We will mostly use composite systems made out of qubits.
The tensor product of $N$ qubits has a state space of $2^n$ dimension. We fix as a basis, the tensor product of the computational basis of each qubit
$$\ket{a_1\dots a_n} \quad \text{ where } a_i \in \{0,1\}$$
The basis is ordered in lexicographic order.

Given $0 \leq i < 2^N$ we write $\ket{i} = \ket{a_1 \dots a_N}$ where $a_1 \dots a_N$ is the representation of $i$ in binary.

:::{.example name='2 qubit system'}
Let $Q_A, Q_B$ be two qubits with orthonormal basis $\ket{0}_A, \ket{1}_A$ and $\ket{0}_B, \ket{1}_B$ respectively.
An orthonormal basis of the composite system $Q_A \otimes Q_B$ is
$$(\ket{0}_A \otimes\ket{0}_B, \ket{0}_A \otimes\ket{1}_B, \ket{1}_A \otimes\ket{0}_B, \ket{1}_A \otimes\ket{1}_B),$$
which we write
$(\ket{00}, \ket{01}, \ket{10}, \ket{11})$
or
$(\ket{0}, \ket{1}, \ket{2}, \ket{3}).$
:::


## Quantum operations

Following the classical model, the theory of quantum computation considers time as a discrete variable, thus we are only interested in the evolution of quantum systems in discrete steps.
Two kinds of operations are possible within this framework: *unitary* operations, which are reversible and keep the system in a quantum state and  *measurements* which are irreversible and non-deterministic and return a classical bit.

Given an operator $A: H \to H'$ and $\ket{\psi} \in H$ we write $A\ket{\psi} := A(\ket{\psi})$.
We will identify a linear operator with its matrix over the fixed basis.

Operators form a normed vector space given by the following proposition

:::{.proposition}
Let $X,Y$ be two normed (complex) spaces and let $L(X,Y)$ be the set of linear maps $A:X \to Y$. Then $(L(X,Y),\norm{\cdot})$ is a normed (complex) space, with $\norm{\cdot}$ given by 
$$\norm{A} = \sup\{\norm{A\ket{x}}\;:\; \ket{x} \in X, \norm{\ket{x}} = 1\}.$$
:::

The operators that can be used in quantum mechanics are unitary.

:::{.definition}
Let $H$ be a Hilbert space, a **unitary operator** $U: H \to H$ is a continuous linear operator such that

1. $U$ is surjective and
2. $U$ is an isometry, that is, for all $\ket{\phi},\ket{\psi} \in H$, $\bk{\phi}{\psi} = \bk{U\phi}{U\psi}$.
:::

If $\norm{\ket{\psi}} = 1$ then 
$\norm{U\ket{\psi}} = \sqrt{\bk{U\psi}{U\psi}} = \sqrt{\bk{\psi}{\psi}} = \norm{\ket{\psi}} = 1$,
therefore a unitary operator takes unit vectors into unit vectors.
This justifies the identification of unit vectors with rays.

In finite dimensional Hilbert spaces this concept admits a simple characterisation on the matrix associated with the operator.

:::{.proposition}
Let $U:\CC^N \to \CC^N$ be a linear operator, then $$U \text{ is unitary} \iff U \text{ is invertible and } U^{-1} = U^\dagger\,.$$
:::
:::{.proof}

$\Rightarrow)$
: Let $U$ be unitary. We consider its matrix representation with respect to $\{e_i\}_{i \in I}$. $$(U^\dagger U)_{ij} = \bra{e_i}U^\dagger U \ket{e_j} = \ket{e_i}^\dagger U^\dagger U \ket{e_j} = \bk{Ue_i}{Ue_j} = \bk{e_i}{e_j} = \delta_{ij}$$ 
where we have used $(AB)^\dagger = B^\dagger A ^\dagger$. Therefore $U$ is invertible and $U^\dagger U = I$.

$\Leftarrow)$
: Since $U$ is invertible it is surjective. Furthermore, let $\ket{\phi},\ket{\psi} \in \CC^N$.
Then
$$\bk{U\phi}{U\psi} = \bra{\phi}U^\dagger U \ket{\psi} = \bra{\phi} I \ket{\psi} = \bk{\phi}{\psi}$$
:::

Quantum operations are represented by unitary operators, as stated in the following principle:

:::{.principle}
The evolution of the state of a quantum system from time $t_1$ to time $t_2 > t_1$ is given by a unitary transformation $U$, that is $$\ket{\psi(t_2)} = U\ket{\psi(t_1)}$$
:::

If we apply a unitary operation on each subsystem the resulting operation is also a unitary operation.
This is given by the following proposition:

:::{.proposition}
Let $H_1,H_2$ be finite dimensional Hilbert spaces with orthonormal basis $B_1 = \{u_i\}_{i \in I}, B_2 = \{v_j\}_{j \in J}$ respectively and let $U_i: H_i \to H_i$ ($i = 1,2$) be unitary operators.

Then $U^{(1)} \otimes U^{(2)}:H_1\otimes H_2 \to H_1 \otimes H_2$ given by $$U^{(1)} \otimes U^{(2)}\ket{u_i}\otimes\ket{v_j} = U^{(1)} \ket{u_i}\otimes U^{(2)} \ket{v_j} \quad \forall i \in I, j \in J,$$ is a unitary operator.

Furthermore, if $U^{(1)} = (u^{(1)}_{ij})$, its matrix expression wrt. the basis $B_1 \otimes B_2$ is given by the *Kronecker product*, $$U^{(1)} \otimes U^{(2)} = \left(\begin{matrix}
  u^{(1)}_{11} U^{(2)} & \cdots & u^{(1)}_{1n}U^{(2)} \\
  \vdots & \ddots &           \vdots \\
  u^{(1)}_{m1} U^{(2)} & \cdots & u^{(1)}_{mn} U^{(2)}
\end{matrix}\right).$$
:::
:::{.proof}
TODO?
:::


Lastly we state the measurement operation for finite dimensional systems.

:::{.principle #fig:measurement}
A measurement of a quantum system of dimension $N = 2^n$ with state $$\ket{\psi} = \sum_{i = 0}^{N-1} \alpha_i\ket{i}$$ is a discrete random variable $X$ such that 
$$P\left(X = \ket{i}\right) = |\alpha_i|^2 \qquad (i = 1, \dots, N)$$
:::

Since we take $\norm{\ket{\psi}} = 1$ this means $$\sum_{i = 0}^{N-1} |\alpha_i|^2  = 1$$
Furthermore, $|\alpha_i|^2 \geq 0$, so the random variable defined at [Principle @fig:measurement] is well-defined.

We can restrict ourselves to measurements on the computational basis, but since the change of basis matrix for any other orthonormal basis is unitary we can in practice measure with respect to any orthonormal basis by applying an appropriate unitary operation before the measurement.

### Some useful quantum operations

:::{.proposition #prop:quantumOps}
The following operators given by their matrices wrt. the computational basis are unitary:

Identity
: The identity operator (for any number of qubits) is unitary,

Hadamard
: The *Hadamard gate* is the (1 qubit) unitary operation given by $$H = \frac{1}{\sqrt{2}}\left(\begin{matrix} 1 & 1 \\ 1 & -1 \end{matrix}\right), \qquad H\ket{0} = \frac{1}{\sqrt{2}}(\ket{0} + \ket{1}) \quad H\ket{1} = \frac{1}{\sqrt{2}}(\ket{0} - \ket{1}).$$ It is its own inverse.

NOT
: The *NOT gate* (or *$X$ gate*) is the (1 qubit) unitary operation given by $$X = \left(\begin{matrix} 0 & 1 \\ 1 & 0 \end{matrix}\right), \qquad X\ket{0} = \ket{1} \quad X\ket{1} = \ket{0}.$$ On classical states it performs the logical NOT operation. 

SWAP
: A *SWAP gate* is the (2 qubit) unitary operation given by $$\operatorname{SWAP} = \left(\begin{matrix} 1 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 \\ 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 1 \end{matrix}\right).$$ 
It swaps the position of two qubits: $\operatorname{SWAP}\ket{i}\ket{j} = \ket{j}\ket{i}$.

Phase change
: Let $\theta \in [0,2\pi]$. The *$\theta$-phase change gate* is the (1 qubit) unitary operation given by
$$R_\theta = \left(\begin{matrix}1 & 0 \\ 0 & e^{i\theta}\end{matrix}\right), \qquad R_\theta\ket{0} = 0, \quad R_\theta\ket{1} = e^{i\theta}\ket{1}.$$

Controlled $U$-gate
: Given an $n$ qubit unitary operation $U$, the controlled $U$ gate is an $n+1$ qubit operation given by $$C_U= \left(\begin{array}{c|c} I_2 & 0 \\ \hline 0 & U \end{array} \right), \qquad C_U\ket{a}\ket{x} = \ket{a}U^a\ket{x}.$$
It serves as a conditional operation.

CNOT
: The controlled not operation is the operation $\operatorname{CNOT} = C_{\operatorname{NOT}}$.
It maps $\operatorname{CNOT}\ket{x,y} = \ket{x,x \oplus y}$.

Toffoli gate
: The *Toffoli gate* (or *CCNOT gate*) is the 3 qubit gate that maps $\operatorname{CCNOT}\ket{x,y,z} = \ket{x,y,z \oplus (x\cdot y)}$. Its matrix expression is $$\operatorname{CCNOT}= \left(\begin{array}{c|c} I_6 & 0 \\ \hline 0 & X \end{array} \right).$$

:::


Classical reversible
