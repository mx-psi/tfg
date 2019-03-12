\newpage

# Quipper

Quipper is an embedded functional programming language based on Haskell that provides tools for quantum simulation and expressing circuit families.

# Relevant functions

We can think of the following functions has having this type

1. `qinit :: Struct Bool -> Circ (Struct Qubit)`
2. `hadamard, qnot gate_X, gate_Y, gate_Y :: Qubit -> Circ Qubit`
3. `controlled :: ControlSource c => Circ a -> c -> Circ a` (creates a controlled gate)

<!-- Local Variables: -->
<!-- ispell-local-dictionary: "british" -->
<!-- End: -->
