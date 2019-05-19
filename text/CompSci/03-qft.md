\newpage

# The Quantum Fourier Transform

The Quantum Fourier transform is one of the main algorithms that allow us to achieve super-polynomial speedups when comparing with the best known classical and probabilistic algorithms. It depends on the notion of discrete normalised Fourier transform.


:::{.definition name="Unitary DFT"} 
[@RaoFastFouriertransform2010; sec 2.1.3]

The *discrete normalized Fourier Transform* (UDT) is the map $\operatorname{UDT} : \CC^N \to \CC^N$ given by
$$\operatorname{UDT}(x) = y,\text{ where } y_k := \frac{1}{\sqrt{N}} \sum_{n= 0}^{N-1} x_j \exp\left(\frac{2\pi ijk}{N}\right),$$
for all $k \in \{0,\dots,N-1\}, x = (x_0, \dots, x_{N-1}) \in \CC^N$.
:::

The unitary DFT has a quantum equivalent

:::{.definition name="Quantum Fourier Transform"}
[@NielsenQuantumComputationQuantum2010; sec. 5.1]

The *quantum Fourier transform* (QFT) is the unique linear operator $\operatorname{QFT}: Q^{\otimes n} \to Q^{\otimes n}$ that maps $$\ket{x} \mapsto \frac{1}{\sqrt{N}}\sum_{k = 0}^{N-1} \exp\left(\frac{-2\pi ixk }{N}\right)\ket{k}$$
for every for $x \in \{0,\dots, N-1\}$.

Alternatively, it is the operator that maps a quantum state with amplitude vector $x$ in the quantum state with amplitudes vector $\operatorname{UDT}(x)$.
:::

The QFT is not directly applicable for the calculation of the UDT, as the amplitude vector can not be recovered directly. Its most direct application is the sampling according to the distribution given by the Fourier transform coefficients. Nonetheless, the QFT has widespread use on the design of quantum algorithms, since it allows us to efficiently encode information on the amplitude vector.

Despite this important caveat, the QFT is an essential part of Shor's algorithm construction among others.


Next, we show an alternative representation of the QFT that simplifies its calculation.

:::{.lemma name="Product representation" #lemma:productrepr}
[@NielsenQuantumComputationQuantum2010; sec. 5.1]
Let $x \in \{0,\dots, N-1\}$ with $x_1 \dots x_n$ its binary expression
$$\operatorname{QFT}\ket{x} = \operatorname{QFT}\ket{x_1 \dots x_n} = \frac{1}{\sqrt{N}} \left( \ket{0} + \exp(2\pi i 0.x_n)\ket{1} \right) \otimes \cdots \otimes  \left( \ket{0} + \exp(2\pi i 0.x_1 \dots x_n)\ket{1} \right)$$
:::
:::{.proof}

Let $k/2^n = \sum_{j = 1}^n k_j 2^{-j} = 0.k_1 \dots k_n$.

We then have
\begin{align*}
\sum_{n= 0}^{N-1} x_n \exp\left(2\pi ix \frac{k}{2^n}\right) & = \sum_{n= 0}^{N-1} x_n \exp\left(2\pi i x \sum_{j = 1}^n k_j 2^{-j}\right) \\
& = \sum_{k \in \BB^n} \bigotimes_{j = 1}^n \exp(2\pi i x k_j)\ket{k_j} \\
& = \bigotimes_{j = 1}^n \left(\sum_{k_j = 0}^1 \exp(2\pi i x k_j2^{-j})\ket{k_j} \right)\\
& = \bigotimes_{j = 1}^n  (\ket{0} + \exp(2\pi i x 2^{-j})\ket{1}) \\
& = \bigotimes_{j = 1}^n  (\ket{0} + \exp(2\pi i 0.x_{n-j+1}\dots x_n)\ket{1}),
\end{align*}
where in the last equality we have used $x2^{-j} = x_1\dots x_{n-j}.x_{n-j+1}\dots x_n$, and therefore
$$\exp(2\pi i x2^{-j}) = \exp(2\pi i x_1\dots x_{n-j})\exp(2\pi i 0.x_{n-j+1}\dots x_n) = \exp(2\pi i 0.x_{n-j+1}\dots x_n),$$
since $\exp(2\pi i a) = 1$ for $a \in \ZZ$.
:::

Finally, we show how to construct a polynomial-size uniform family of quantum circuits that computes the QFT.
For comparison, notice that the best-known classical algorithm for computing the DFT (the FFT algorithms) have an asymptotic efficiency of $O(N \log N)$ [@RaoFastFouriertransform2010].

:::{.theorem name="Quantum Fourier Algorithm" #thm:QFT}
There exists a polynomial-size uniform family of quantum circuits that computes the quantum Fourier transform.

Specifically, for a quantum input of $N = 2^n$ qubits the circuit has a size $O(n^2) = O(\log^2 N)$.
:::
:::{.proof}
Let $n \in \mathbb{N}$ be the number of qubits of the input, of shape $\ket{x} = \ket{x_1 \dots x_n}$.

For $k = 2, \dot, n$, let $R_k := R_{2\pi/2^k}$ be a phase rotation gate.

Clearly, $$H\ket{x_i} = \frac{1}{\sqrt{2}}(\ket{0} + (-1)^{x_i}\ket{1}) = \frac{1}{\sqrt{2}}(\ket{0} + e^{2\pi i 0.x_1}\ket{1}).$$

Let $k \in \{1,\dots,n\}$.
Assume a qubit is in state $$\ket{\psi} = \frac{1}{\sqrt{2}}(\ket{0} + e^{2\pi i 0.x_1 x_2 \dots x_{k-1}}),$$
then, if we apply an $R_k$ gate controlled by $\ket{x_k}$ we then have 
$$C-R_k\ket{x_k}\ket{\psi} = \frac{1}{\sqrt{2}}(\ket{0} + e^{2\pi i 0.x_1 x_2 \dots x_k}).$$

Hence, if for each qubit $\ket{x_k}$ we apply the Hadamard gate and the controlled $R_j$ gate for $j=1,\dots, n-k+1$ controlled by $\ket{x_j}$, we will have, up to reordering of the qubits, the expression given by [@lemma:productrepr].

The circuit will have size  $$\frac{n(n+1)}{2} \in O(n^2),$$ since each qubit needs $n-k+2$ gates.
:::


As any result having to do with concrete sizes of families of quantum circuits, the $O(n^2)$ [@thm:QFT] is given with respect to a basis that has the appropiate gates, and for a fixed basis there might be a polylogarithmic difference given by [@thm:solovay].

An example circuit for the Quantum Fourier Transform of 3 qubits can be seen in [@fig:qft].

![Circuit for the 3 qubit Quantum Fourier Transform.](assets/qft.pdf){#fig:qft width=110%}

## Quipper implementation

In this section we show how to define the uniform family of quantum circuits we constructed in the proof of [@thm:QFT] on Quipper.

TODO


