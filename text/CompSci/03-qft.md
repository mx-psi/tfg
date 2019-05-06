\newpage

# The Quantum Fourier Transform

The Quantum Fourier transform is one of the main algorithms that allow us to achieve super-polynomial speedups when comparing with the best known classical and probabilistic algorithms. It depends on the notion of discrete normalised Fourier transform.


:::{.definition name="Unitary DFT"} 
[@RaoFastFouriertransform2010; sec 2.1.3]

The *discrete normalized Fourier Transform* (UDT) is the map $\operatorname{UDT} : \CC^N \to \CC^N$ given by
$$\operatorname{UDT}(x) = y,\text{ where } y_k := \frac{1}{\sqrt{N}} \sum_{n= 0}^{N-1} x_n \exp\left(\frac{2\pi ik n}{N}\right),$$
for all $k \in \{0,\dots,N-1\}, x = (x_0, \dots, x_{N-1}) \in \CC^N$.
:::

\fxnote{TODO: La transformada de Fourier aparece con el signo menos en algunos sitios y sin el signo menos en otros. En Nielsen\& Chuang aparece sin signo menos, en Rao con signo menos.}

The unitary DFT has a quantum equivalent

:::{.definition name="Quantum Fourier Transform"}
[@NielsenQuantumComputationQuantum2010; sec. 5.1]

The *quantum Fourier transform* (QFT) is the unique linear operator $\operatorname{QFT}: Q^{\otimes n} \to Q^{\otimes n}$ that maps $$\ket{x} \mapsto \frac{1}{\sqrt{N}}\sum_{k = 0}^{N-1} \exp\left(\frac{-2\pi ik n}{N}\right)\ket{k}$$
for every for $x \in \{0,\dots, N-1\}$.

Alternatively, it is the operator that maps a quantum state with amplitude vector $x$ in the quantum state with amplitudes vector $\operatorname{UDT}(x)$.
:::

The QFT is not directly applicable for the calculation of the UDT, as the amplitude vector can not be recovered directly. Its most direct application is the sampling according to the distribution given by the Fourier transform coefficients. Nonetheless, the QFT has widespread use on the design of quantum algorithms, since it allows us to efficiently encode information on the amplitude vector.

Despite this important caveat, the QFT is an essential part of Shor's algorithm construction among others.


Next, we show an alternative representation of the QFT that simplifies its calculation.

:::{.lemma name="Product representation"}
[@NielsenQuantumComputationQuantum2010; sec. 5.1]
Let $x \in \{0,\dots, N-1\}$ with $x_1 \dots x_n$ its binary expression
$$\operatorname{QFT}\ket{x} = \operatorname{QFT}\ket{x_1 \dots x_n} = \frac{1}{\sqrt{N}} \left( \ket{0} + e^{2\pi i 0.x_n}\ket{1} \right) \otimes \cdots \otimes  \left( \ket{0} + e^{2\pi i 0.x_1 \dots x_n}\ket{1} \right)$$
:::
:::{.proof}
TODO
:::

Finally, we show how to construct a polynomial-size uniform family of quantum circuits that computes the QFT.
For comparison, notice that the best-known classical algorithm for computing the DFT (the FFT algorithms) have an asymptotic efficiency of $O(TODO)$ [TODO cita].

:::{.theorem name="Quantum Fourier Algorithm" #thm:QFT}
There exists a polynomial-size uniform family of quantum circuits that computes the quantum Fourier transform.

Specifically, for a quantum input of $N = 2^n$ qubits the circuit has a size $O(n^2) = O(\log^2 N).$
:::
:::{.proof}
Let $n \in \mathbb{N}$ be the number of qubits of the input.

For $k = 2, \dot, n$, let $R_k := R_{2\pi/2^k}$ be a phase rotation gate.

TODO

Hence, the circuit will have size $$l(n) = \frac{n(n+1)}{2} \in O(n^2).$$

TODO
:::

## Quipper implementation

In this section we show how to define the uniform family of quantum circuits we constructed in the proof of [@thm:QFT] on Quipper.



