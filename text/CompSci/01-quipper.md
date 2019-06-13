# Quipper

In this chapter we present Quipper, a quantum programming language that we use to implement concrete quantum algorithms as uniform families of quantum circuits, and we describe the setup followed for the implementation.

## Quantum programming languages

Quantum programming languages are programming languages that would be practically useful in the design and implementation of quantum algorithms.
Since the early 2000s there has been a surge in proposals for quantum programming languages,
which can roughly be classified into *imperative quantum programming languages*, which follow Knill's QRAM model (@KnillConventionsquantumpseudocode1996) and *functional quantum programming languages*, which extends lambda calculus in some fashion, frequently using sophisticated type systems to ensure the correctness of programs (@GayQuantumprogramminglanguages2006).

Even without practically useful quantum computers in the present, the presence of quantum programming languages is essential for the design and verification of quantum algorithms, since they can be more easily tested against different examples.
Furthermore, these programming languages can be given precise formal semantics that allow for their verification
(@YingFoundationsquantumprogramming2016, chap. 1).

In this bachelor's thesis I have chosen to use *Quipper*, a purely functional scalable programming language, since it is both practically usable and both its actual programs and its underlying semantics most closely resemble the uniform families of quantum circuits model for quantum programs.
Quipper was designed as part of IARPA's QCS project and it has been used to implement several non-trivial quantum algorithms present in the literature (@GreenIntroductionQuantumProgramming2013).
Parts of Quipper have been given formal semantics, and the language has been generalized to describe families of morphisms in a symmetric monoidal category (@RossAlgebraicLogicalMethods2015, @RiosCategoricalModelQuantum2018).

The following sections introduce practical aspects of programming in Quipper, and the next chapters each present the implementation of one or several quantum algorithms that exemplify these notions.

## Quipper: a functional quantum programming language

Quipper is an embedded language based on *Haskell*, a functional programming language widely used within the functional programming community.
In practical terms, Quipper consists of

1. `Quipper`, a Haskell library that defines several constructs and functions that allow us to define and 
   manipulate both classical and quantum circuits,
2. `QuipperLib`, a second library that allows us to optimize, represent and simulate those circuits and
3. a preprocessing script that compiles the Quipper-specific syntax into Haskell.

The following sections describe these parts in more detail, as well as the host language Haskell.

### Haskell

The host language used by Quipper is Haskell. 
Haskell is a purely functional programming language created in 1990, that has strong static typing and lazy evaluation.
It has a formal specification given by the Haskell Report (@MarlowHaskell2010language2010).

In this document we make use of the version of Haskell implement by the Glasgow Haskell's compiler version 8.2.2 (@GlasgowHaskellCompiler).
We make use of several language extensions that are not part of the Haskell standard since these are used by Quipper for its internal implementation.

We will not make an extensive description of Haskell here, yet here we briefly highlight a number of features that are relevant for the understanding of Quipper.
An introduction to Haskell can be found at (@HuttonProgramminghaskell2016).

Some relevant features of Haskell for the implementation of quantum algorithms in Quipper are:

Higher-kinded types
: Haskell's type system (together with GHC's non-standard extensions) allow for the use of *higher kinded types*.
  Haskell does not have dependent types, but rather its types have a *kind*.
  Base types such as `Char`, `Int` or `Double` have the kind `Type`, 
  while type constructors such as lists can have a kind `Type -> Type`,
  that is, they take a base type and return a different base type 
  (for example, `[Int]`, the type of lists of integers).

Typeclasses
: Polymorphic functions in Haskell are defined through the use of *typeclasses*. 
  In its most general terms, a typeclass `Class a1 a2 .. an` is defined by a public interface 
  that defines a number of polymorphic functions that can make use of the (possibly higher kinded) types `a1`, 
  `a2`, ... `an` in their type signatures.
  Then, the programmer can manually specify instances of the typeclass for a fixed colection of types `T1`, ..., 
  `Tn`, by giving the definition of these functions for the fixed types.
  For example, the typeclass `Ord a` defines (among others) the "less than" function, with type signature:
  ```haskell
  (<) :: Ord a => a -> a -> Bool
  ```
  It has instances for most types, such as `Int`, `Char` or `Double`.

Monads
: A particular typeclass that is extensively used in Quipper is the `Monad` typeclass.
  It is defined for types of kind `Type -> Type`, and it is inspired by the concept of *monad*
  in category theory, a monoid object in the category of endofunctors over a particular category.
  They are widely used in functional programming as computational contexts, to handle side effects
  and failure.
  Its public interface can be given[^monad] by two functions,

  - `pure :: a -> Monad a`, that introduces an object into a minimal computational context and
  - `(<=<) :: Monad m => (b -> m c) -> (a -> m b) -> a -> m c`, a composition operator for monadic 
  functions.
  
  Any instance of the `Monad` class should verify that the defined `<=<` is an associative operation
  with `pure` as its neutral element.
  
  Haskell introduces a special syntax for monadic operations, the `do` notation.
  This syntax resembles imperative code, and will be used for defining the families of circuits.


[^monad]: This is not the actual definition in the Haskell Report, but it is equivalent. We are describing a monad in terms of its Kleisli category.

### Quipper features

Quipper implements a mixed circuit model of quantum computing, that includes both classical and quantum circuits, and allows for the mixing of both.
As discussed in previous chapters, this model is equivalent to using pure quantum circuits, yet it allows for further flexibility in the implementation. We will also mix circuit code with Haskell code when this is possible for simplicity.
While a complete formalization of the semantics of Haskell that would allow for a formal justification of this fact is not available, as most programming languages Haskell is considered to be Turing-equivalent, and thus code written this way would in principle still be able to be transformed to the circuit model.

#### Datatypes

Within its circuit model we can distinguish three phases of execution (@GreenIntroductionQuantumProgramming2013): compile time (when Quipper code is transformed into Haskell code and compiled), *circuit generation* time (when, during program execution, the circuit is generated) and *circuit execution* time (when the circuit execution is simulated).

Using this distinction, we can distinguish two kinds of types

1. *parameters*, known at circuit generation time. These are represented by the datatype `Bool`.
2. *inputs*, known at circuit execution time. The classical inputs are represented by the type `Bit` and the quantum 
   inputs are represented by `Qubit`.
   
Parameters can be turned into inputs but not vice versa.
Furthermore, classical inputs can be turned into quantum inputs,
but transforming quantum inputs into classical ones requires performing a measurement.

To define a circuit in Quipper we use the `Circ` monad.
For example, a function $f : Q^{\otimes 2} \to Q^{\otimes 3}$ would have type
```haskell
f :: (Qubit, Qubit) -> Circ (Qubit, Qubit, Qubit)
```

:::{.example name="A simple circuit"}
The file `src/apps/Classical.hs` in the associated code[^code] defines several simple classical and quantum gates, that have been used to produce the diagrams in this document. 

For example, the $\operatorname{FANOUT}$ gate can be seen as having type 
```haskell
fanout :: Qubit -> Circ (Qubit, Qubit)
```
Its definition is
```haskell
fanout x = do
  y  <- qinit True
  z  <- qinit False
  (x, y, z) <- toffoli (x, y, z)
  qterm True y
  pure (x, z)
```

For its definition we use the `qinit` function, that transforms parameters into quantum inputs (serving as the $\operatorname{ANCILLARY}$ gate), the `toffoli` gate and the `qterm` function for the $\operatorname{DISCARD}$ gate.
:::

[^code]: See the Appendix for instructions on how to obtain the code if it has not been provided with this file.

To allow for the definition of families of quantum circuits, 
Quipper introduces the typeclass `QShape ba qa ca`.
It is defined for triples of types with kind `Type`, 
and its purpose is to allow for generic definitions of circuits.

For example, an instance of `QShape` can be given by the types `Bool`, `Qubit` and `Bit`,
but also for `[Bool]`, `[Qubit]` and `[Bit]`.
This allows for generic definitions of circuits that can have an arbitrary shape of input, 
thus easily defining families of circuits.


:::{.example name="Oracles"}

As we saw in section [simulating classical operations], 
a function $$f :\BB^n \to \BB$$ can be transformed into a reversible function 
$$ U_f : Q^{\otimes n+1} \to Q^{\otimes n+1}$$
that maps $$\ket{x}\ket{y} \mapsto \ket{x}\ket{y \oplus f(x)}.$$

In the attached code, these reversible functions are given by the datatype `Oracle`,
that has a `shape` and `circuit`:
```haskell
data Oracle qa = Oracle {
  shape   :: qa, -- ^ The shape of the input
  circuit :: (qa,Qubit) -> Circ (qa,Qubit) -- ^ The circuit oracle
  }
```

We also define a function `buildOracle` that can build $U_f$ given $f$.
For this we make use of the `QShape` datatype, with which we can express the type signature as:
```haskell
buildOracle
  :: QShape ba qa ca
  => qa
  -> (qa -> Circ Qubit)
  -> Oracle qa
```
:::

#### Circuit generation

Quipper includes a powerful circuit generation system, that uses Haskell's compile-time metaprogramming capabilities to produce circuits from classical code.
This can be used for transforming `Bool` based functions into circuits.

For this, Quipper introduces the special syntax `build_circuit`, that is not legal Haskell syntax.
If placed before a boolean function it produces a circuit based on the code of that function.
For example, to define the $\operatorname{XNOR}$ gate:
```haskell
build_circuit
booleanXnor (x, y) = (not x || y) && (x || not y)

xnor :: (Qubit, Qubit) -> Circ Qubit
xnor = unpack template_booleanXnor
```

This is used to define an automatic circuit generator from a truth table given in a CSV file (or, if the filename is missing, from the standard input).
We will use this to pass concrete functions to the defined algorithms.


### stack and `quipperlib` setup 

`stack` is Haskell's most popular package manager [@SnoymanHaskellToolStack2019].
It provides a framework for reproducible builds and an easy way of installing a package dependencies.
It is compatible with Windows, macOS and Linux based OSs.

In order to ease the programming in Quipper, for this work I have bundled the official Quipper code into a `stack`-compatible Haskell package, which is available [on Github](https://github.com/mx-psi/quipper).
Quipper's preprocessor has been manually included in `stack`'s building process so as to be able to use the full Quipper language.

A Makefile is provided to aid in the compilation of the binaries.

The provided binaries are

1. `quantum`, that provides a command-line interface for the simulation and graphical representation of several 
  quantum algorithms.
2. `diagrams`, that produces the circuit diagrams that are used in this document making use of Quipper's libraries.


The following chapters will describe the quantum algorithms in detail, as well as their implementations.
