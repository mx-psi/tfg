# Probabilistic computation models

## Probabilistic models

:::{.definition}
A *probabilistic Turing machine* is a 5-tuple $M = (Q,\delta_0,\delta_1, q_0, q_F)$ such that for $i = 0,1$
$(Q,\delta_i, q_0, q_F)$ is a Turing machine.

Opciones:

- Dos funciones de transición
- una máquina no determinista que induce una distribución de probabilidad.
- una máquina determinista que toma dos argumentos (verlo como "polynomial time compu")
:::



The probabilistic circuit model is not usually studied but can easily be formed by adding a gate that outputs a random bit from a possibly biased Bernouilli random variable.

:::{.proposition}
Definition invariance by probability bias (see Arora and Barak)
One can simulate an arbitrary distribution
:::

## Probabilistic polynomial complexity

:::{.definition}
$L \in \mathsf{BPP}$ if and only if there exists 
a polynomial time computable function $f: \BB^\ast \to \BB$ such that 

1. for every $x \in L$,    $P[f(x) = 1] \geq \frac23$ and
2. for every $x \notin L$, $P[f(x) = 1] \leq \frac13$.
:::

:::{.proposition name="Chernoff bound" #prop:Chernoff} 
[@NielsenQuantumComputationQuantum2010; Box 3.4]

Let $\varepsilon > 0, n \in \NN, p = \frac12 + \varepsilon$ and $X_1, \dots, X_n \sim \operatorname{Bernouilli}(p)$ independent identically distributed random variables. Then
$$P\left[\sum_1^n X_i \leq \frac{n}{2}\right] \leq \exp(-2\varepsilon^2 n)$$
:::
:::{.proof}
TODO
:::

:::{.definition}
$L \in \mathsf{PP}$ if and only if there exists 
a polynomial time probabilistic Turing Machine $M$ such that 

1. for every $x \in L$,    $P[M(x) = 1] \geq \frac12$ and
2. for every $x \notin L$, $P[M(x) = 1] \leq \frac12$.
:::

:::{.example}
Problem which is in PP but we don't know wether it is in BPP
:::


### BPP properties

BPP vs PH
BPP vs P/Poly 
BPP vs EXP
Pseudorandomness

(mirar Arora y Barak)

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

There are no hierarchy theorems


## Probabilistic polynomial time verifiers

:::{.definition}
TODO MA
:::

Graph non isomorphism is in MA
Mention derandomization
