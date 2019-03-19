# The Quantum Fourier Transform

The Quantum Fourier transform is one of the main algorithms that allow us to achieve superpolynomial speedups when comparing with the best known classical and probabilistic algorithms. It depends on the notion of discrete normalized Fourier transform.


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

The QFT is not directly applicable for the calculation of the UDT as the amplitude vector can not be recovered directly, its most direct application is the sampling according to the distribution given by the Fourier transform coefficients. Nonetheless, the QFT has widespread use on the design of quantum algorithms, since it allows us to efficiently encode information on the amplitude vector.

:::{.lemma name="Product representation"}
[@NielsenQuantumComputationQuantum2010; sec. 5.1]

:::


