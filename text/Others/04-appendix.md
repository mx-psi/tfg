# Appendices {.unnumbered}

## Code {.unnumbered}

The source files that generate this document are available at [`github.com/mx-psi/tfg`](https://github.com/mx-psi/tfg).

The official page for the Quipper language is [`mathstat.dal.ca/~selinger/quipper`](https://www.mathstat.dal.ca/~selinger/quipper/).
It is bundled as a `stack`-compatible package at [`github.com/mx-psi/quipper`](https://github.com/mx-psi/quipper).
This repository also includes a `stack` template with a ready to use project for implementing quantum algorithms in Quipper.

The code associated with this document is available at [`github.com/mx-psi/quantum-algorithms`](https://github.com/mx-psi/quantum-algorithms).
Its documentation can be generated using `make docs`.


### Code description {.unnumbered}

What follows is a formatted copy of the file `README.md`,
available with the attached code.

#### Dependencies

All dependencies are managed by `stack`. For installing `stack` on Unix
OSs `make install-deps` can be run. On Windows, a binary is provided on
<https://docs.haskellstack.org/en/stable/README/>.

The first time there is an attempt to build the binary all dependencies
will be installed by `stack`, including GHC Haskell compiler, so this
may take some time.

#### Building

**Important note:** The building process has only been tested on Linux
distributions. In order to run the program on Windows, the `stack.yaml`
file MUST be edited so that the preprocessor works. In particular,
`quipper/convert_template.sh` should be replaced by
`quipper/convert_template.bat`.

------------------------------------------------------------------------

`make build` will build the associated binaries and copy them to the
`bin` folder.

The first time there is an attempt to build the binary all dependencies
will be installed by `stack`, including GHC Haskell compiler, so this
may take some time.

Binaries created on my computer (running Linux Mint 18.1) are attached.

#### Running the binaries

The previous process creates two binaries, Both binaries include help
instructions by running them with the option `--help`.

The first one, `quantum`, implements a command-line interface for
running several quantum algorithms. Each algorithm is associated with a
subcommand.

Some algorithms take an oracle as input, defined by its truth table.
This can be passed as an argument or, if called without this argument,
the oracle will be read from standard input.

The syntax for oracles is a subset of csv files. Each line is expected
to have an input value, represented by a string of `0` and `1`, and
separated by a comma, an output value, represented by a single bit.

For example, the NOT logical operation can be given as

    0,1
    1,0

Some examples of oracles are included in the `oracles` folder.

The second binary, `diagrams`, generates the diagrams used in the document.
The option `--gen-all` generates a selection of the diagrams used,
while providing a circuit in the form of a truth table with the option `--circuit` generates a circuit diagram for that specific circuit.

#### Documentation

The documentation, generated with Haddock, is available in the `docs`
folder. It can be rebuilt by using `make docs`.

Note that the process for building the documentation requires the manual
preprocessing of the code files and thus can not directly be done using
`stack`.

#### Testing

The code includes a test suite with both unit tests and property-based
testing. It can be run using `make tests`.

Note that due to the nature of the implemented algorithms, it is
possible (yet unlikely) that some of these tests fail (this is indicated
in the output log).

#### Code organization

The code is organized as follows

1.  the `oracles` folder includes examples of oracles written in the
    syntax accepted by several algorithms.
2.  the `quipper` folder includes preprocessing scripts that were taken
    from the Quipper project to allow for the compilation.
3.  the `src` folder contains the code. It has several subfolders

    -   the `apps` subfolder has a folder per binary and includes the
        main program,
    -   the `lib` subfolder contains files common to both binaries,
        defining the algorithms (in the `Algorithms` subfolder), as well
        as several auxiliary files.
    -   the `test` subfolder includes the testing suite code.

4.  the `docs` folder includes the generated documentation.
5.  the `package.yaml` and `stack.yaml` files define the dependencies
    and compilation steps.

\newpage

## Acknowledgements {.unnumbered}

Professor Serafín Moral Callejón has helped me greatly with his corrections and advice in writing this document, allowing me to clarify my thoughts when writing this document, and teaching me how to write clearly in a mathematical style. I am also thankful to him and more generally to the Department of Computer Science and Artificial Intelligence at the University of Granada for allowing me to pursue this project with a collaboration grant.

Professor Peter Selinger has assisted me in the bundling of Quipper as a `stack` project by updating his maintained packages and answering my doubts via e-mail. I am also grateful for his work and others developing Quipper, which has allowed me to better understand quantum computers.

I would also like to thank the LibreIM organizers and attendants, for attending to my seminar on the topic and providing useful feedback. Thank you to Antonio, Mario, David, Guillermo, Sofía, José Alberto, Dani, José Manuel, Blanca and Violeta.

Lastly, a special thank you to Mario Román for his help in understanding the categorical perspective on quantum circuits and to José María Martín for his advice on the design and style of this document.

