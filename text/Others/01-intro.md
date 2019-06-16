\chapter*{Introduction}

<!--Antecedentes-->

In the 1920s, quantum physics sparked a revolution in the field of physics, which prompted the creation of all kinds of technologies. A decade later, Alan Turing first proposed the *Turing machine model*, giving birth to the field of theoretical computer science.

It was not until the 1980s that the idea of quantum computation, combining this two disciplines, was first proposed, were they were first suggested as a way to efficiently simulate physical phenomena (@FeynmanSimulatingphysicscomputers1982).

This combination of the principles of quantum physics with the ideas of computation allowed for a more general model of computers that entailed a radical paradigm shift from the previous way of doing computation.
It was in this decade when the first theoretical results and algorithms were first discovered.

On the one hand, algorithms such as Shor's algorithm (@ShorAlgorithmsquantumcomputation1994) or Grover's algorithm (@Groverfastquantummechanical1996), which solved problems asymptotically faster than any probabilistic algorithm known at the time generated an intense research program into the development of quantum algorithms and the research of quantum systems' properties.

On the other hand, results such as The *no-cloning theorem*, first stated in 1982 (@Wootterssinglequantumcannot1982), or the optimality of Grover's algorithm were results that hinted at the limits of quantum computation and how its capacities were harder to implement than it was first thought.

Today, quantum computation is a young yet thriving field that has seen its first experimental success with real quantum computers and that has both a more theoretical side from the field of complexity theory and a more applied one when it comes to the design and implementation of quantum algorithms.

<!--Descripción del problema-->
<!--Sintetizar el contenido de la memoria-->

This document attempts at giving an overview of some results in quantum computation, as well as implementing some algorithms in a quantum programming language.
Some of these algorithms can be simulated while, for others, an assesment of the needed resources can be given.

The first part, encompassed by chapters 1 to 4, is more theoretical and describes the classical, probabilistic and quantum computation model in detail by the means of the circuit model and the tools of complexity theory.
It also states and proves some results that allow us to understand the relations between those models.

The second part, from chapters 5 to 8, describes the fundamentals for programming in the Quipper programming language, (@GreenIntroductionQuantumProgramming2013), and describes several key quantum algorithms and subroutines, giving a formal justification of their effectiveness as well as a description of their circuit families using Quipper. The code is also available in the attached document and can be generated as an executable to try out some of the algorithms and obtain a graphical representation of others.

<!--Técnicas y áreas matemática y conceptos informáticos utilizados-->

For the development of this document practical and theoretical results from the areas of geometry and linear algebra, computation models, probability and functional programming have been needed.

The main sources used for the writing of this document were @NielsenQuantumComputationQuantum2010, @Kayeintroductionquantumcomputing2007, @AroraComputationalComplexityModern2009 and @GreenIntroductionQuantumProgramming2013.
The sources used for each section and chapter are quoted within the text.


\section*{Main goals and results achieved}

<!--Objetivos inicialmente previstos-->

The initial goals of the bachelors' thesis were

1. to establish a theoretical and mathematical study of quantum models and quantum complexity classes, as well as their relation to classical and probabilistic models,
2. to study the quantum programming languages available, their capabilities, and to choose one of them and
3. to describe, develop some quantum algorithms in this programming language, as well as to make a theoretical study of these.

<!--Objetivos alcanzados-->

The first two  were completely successful.
For the latter, the Quipper programming language was chosen both because of the closeness of its underlying model as well as its succintness and expressiveness within the functional programming realm.

The third goal was partially successful.
Several quantum algorithms were effectively implemented in the Quipper programming language, yet some of them could not be executed since the simulation was unfeasible for the available computational resources.

To make up for this, in these algorithms a graphical depiction of these algorithms as well as an assesment of the necessary resources for their execution were stated.

<!--Aspectos formativos previos utilizados-->

For the achievement of these goals I have needed to make use of results relating to: Hilbert spaces and geometry, computational models, probability and statistics and functional programming and software design.
