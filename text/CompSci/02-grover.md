\newpage

# Grover's algorithm

In this section we present *Grover's algorithm*, a quantum algorithm that can be used to solve search and minimization problems, providing polynomial speedup in the query complexity setting with respect to the best possible classical algorithm.

The chapter is organized as follows: first we present the general problem Grover's algorithm attempts to solve and why it can be potentially useful.

Then, we describe the classical algorithm  and the quantum Grover's algorithm and prove that it is asymptotically optimal in the query complexity setting.

Lastly, we show how to implement this algorithm in the programming language Quipper.

## Search problems

The general problem Grover's algorithm attempts to solve is a *search problem*.
It is a very general problem with many potential applications.

:::{.problem name="Search"}

Search a string that has a certain property.

- **Input:**  A function $f:\BB^n \to \BB$.
- **Output:** A string $x$ such that $f(x) = 1$.
:::

As a possible application, consider a language $L \in \mathsf{NP}$, and fix a word $x \in \BB^n$ (if we allow randomness, we can consider $L \in \mathsf{MA}$ and proceed similarly).

Recalling [@prop:npverifier] consider as $f : \BB^{p(n)} \to \BB$ the function associated with the verifier $V$.
Then, if we have an algorithm to solve the search problem we can decide whether $x \overset{?}{\in} L$.
Given the wide variety of problems of practical usefulness in $\mathsf{NP}$[TODO citar], this is an important and useful application of such problem.

As a more practical application, one can consider a search on a database.
In this case the function would indicate whether there has been a match or not for each item in the database.

Notice that we allow for potentially more than one matching string.
A simple restriction is to allow for exactly one possible string.

:::{.problem name="Search with one answer"}

Search the only string that has a certain property.

- **Input:**  A function $f:\BB^n \to \BB$ such that $|f^{-1}(1)| = 1$.
- **Output:** The string $x$ such that $f(x) = 1$.
:::

We will first focus on this simpler version of the problem and later generalize the solution to allow for multiple answer.

## The classical case

In the query complexity setting we are not interested in the time it takes to compute $f$ but rather in the number of queries necessary to provide an answer. 

In the classical case, there is a trivial algorithm that provides an answer: simply check for every possible input until a match is found. The query complexity of this algorithm is $O(N) = O(2^n)$.

Even if $f$ takes unit time to compute this algorithm is not efficient for solving the search problem associated with an $\mathsf{NP}$ language since it would take at least exponential time on the size of word being decided.

Furthermore, this algorithm is clearly optimal in the classical setting: in the worst case the last input checked is the matching one and thus $\Omega(N)$ queries are needed.



## Grover's algorithm

## Optimality

## Applications and generalizations
