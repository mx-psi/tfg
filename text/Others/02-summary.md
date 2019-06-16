# Summary {.unnumbered}

<!--
scrartcl:
Breve resumen del trabajo realizado. Se incluirán seguidamente al menos cinco palabras
clave que definan el trabajo a criterio del autor.
-->

\section*{Brief summary}

In this document, we develop the theoretical fundamentals of quantum computation and put some of these ideas into practice. 

In the first part, a theoretical outlook to quantum and classical computation is given.
First, the Hilbert space formalism for quantum physics, the Turing machine and the uniform circuit model are described, giving an unified framework for describing computation classically, probabilistically and quantumly.
The basic properties of these models are studied.

Then, several key complexity classes are described, such as $\mathsf{P}, \mathsf{NP}, \mathsf{BPP}, \mathsf{BQP}$ and $\mathsf{QMA}$. The main properties of the complexity classes as well as the known unrelativized relations between these classes are described and summarized.

In the second part, the purely functional quantum programming language Quipper is described, together with the necessary functional programming concepts drawn from Haskell needed, such as monads or generalized typeclasses.

Finally, three main quantum algorithms together with their subroutines are described: the Deutsch-Jozsa algorithm, Shor's algorithm and Grover's algorithm.
Their formal justification is given and they are described in the Quipper programming language.
If possible, a simulation of their execution is given.

**Keywords:** Theoretical computer science, quantum computation, quantum algorithms, functional programming, search problems

\section*{Resumen extendido en español}

Si bien el campo de la computación cuántica es altamente interdisciplinar y necesita en todos sus aspectos de informática y matemáticas, a grandes rasgos puede distinguirse una parte con un enfoque más teórico y **matemático** en los capítulos **1** a **4** y una parte con una orientación más aplicada e **informática** en los capítulos **5** a **8**.

La parte matemática describe el modelo de estados puros para la computación cuántica y utiliza el modelo de familias de circuitos uniformes para describir de forma unificada diversos resultados de complejidad que permiten hacer un análisis teórico de las capacidades de los algoritmos cuánticos. En concreto:

**Capítulo 1**: En este capítulo se procede al desarrollo matemático de los principios de la mecánica cuántica.
  En el modelo de física cuántica de *estados puros* en dimensión finita, 
  un *qubit* es el espacio proyectivo asociado a un espacio de Hilbert de 2 dimensiones con una base computacional ortonormal 
  fijada. Estos qubits u otros espacios de estados pueden combinarse en un espacio de estados compuesto
  mediante el producto tensorial de los espacios 
  de los subestados. 
  
  Las operaciones válidas que transforman estos espacios de estados son las operaciones *unitarias*: aplicaciones 
  lineales que en dimensión finita se caracterizan porque su inversa viene dada por su transpuesta conjugada.
  Estas operaciones son la base de la computación cuántica, y se conocen como *puertas cuánticas*.
  Algunas puertas cuánticas relevantes para la computación cuántica son la puerta de Hadamard, las puertas de cambio 
  de fase o la puerta NOT controlada. Podemos dar su descripción en términos de matrices unitarias.
  
  No todas las operaciones clásicas pueden generalizarse de forma satisfactoria al ámbito cuántico;
  el *teorema de no-clonado* impide ciertas operaciones en el ámbito cuántico que sí son factibles de forma clásica.
  Además, la operación de *medición* nos da para cada estado cuántico una distribución de probabilidad sobre los 
  posibles estados de la base computacional.

**Capítulo 2**: En este capítulo se describe y estudia el modelo clásico de computación.
  Uno de los enfoques fundamentales de la informática teórica es el estudio de los *problemas de decisión* y su 
  relación con el concepto de los lenguajes formados por palabras de un alfabeto dado.
  Las transformaciones válidas en el ámbito clásico tradicionalmente se describen con el *modelo de máquina de 
  Turing clásica*, pero, para tener una descripción unificada con el caso cuántico, recurrimos a los circuitos.
  El *modelo de circuitos uniforme*, que puede verse como la descripción de un morfismo en una categoría monoidal en 
  términos de un conjunto de morfismos básicos llamados *puertas*, puede demostrarse como equivalente al modelo de 
  máquina de Turing clásica en términos de computabilidad y complejidad eficiente.
  
  A partir de estos dos modelos podemos definir *clases de complejidad* deterministas y no deterministas como 
  $\mathsf{P}, \mathsf{P}/\poly, \mathsf{NP}$ y $\mathsf{PSPACE}$: conjuntos de problemas de decisión que son 
  resolubles mediante la utilización de una cierta cantidad de recursos en un cierto tipo de máquina.
  El uso polinomial del tiempo puede verse como un uso eficiente de recursos y por tanto estas clases pueden darnos 
  información sobre si un cierto problema es o no eficiente.
  
  Las relaciones entre estas clases, como que $\mathsf{P} \subseteq \mathsf{NP} \subseteq \mathsf{PSPACE}$ nos 
  aportan cotas inferiores y superiores de la dificultad de resolver ciertos problemas.
  Otras relaciones, como el problema de $\mathsf{P}$ vs. $\mathsf{NP}$ permanecen sin resolver y nos ayudarían a 
  comprender estos problemas.
  En concreto, la clase $\mathsf{NP}$ puede verse como una clase de problemas para los cuales puede demostrarse 
  su resolución para un cierto caso dando un *certificado*.

**Capítulo 3**: En este capítulo se describe y estudia el modelo probabilístico de computación.
Análogamente al modelo descrito en el capítulo 1 para la computación cuántica, puede definirse un modelo de computación probabilística compatible con el formalismo del modelo de circuitos uniformes, utilizando en este caso espacios vectoriales reales como espacio de estados.
Las aplicaciones válidas en este caso son un subconjunto de las *aplicaciones estocásticas* (aquellas cuyas entradas pueden calcularse de forma eficiente clásicamente). Además, estas aplicaciones pueden descomponerse siempre en una parte clásica y un generador de bits aleatorios con un sesgo dado.
A partir de estos podemos definir algoritmos probabilísticos que resuelvan un cierto problema.

Para incrementar la probabilidad de éxito de uno de estos algoritmos pueden utilizarse las *cotas de Chernoff*.
Estos algoritmos junto con los resultados anteriores permiten definir clases de problemas resolubles de forma eficiente en el caso probabilístico como $\mathsf{BPP}$, en el cual los algoritmos deben tener una probabilidad de éxito acotada.
Aunque se cree que los algoritmos probabilísticos no proporcionan una ventaja asintótica en la práctica, 
damos un *ejemplo de lenguaje $\mathsf{BPP}$* para el cual no se conoce un algoritmo clásico eficiente.
*La clase $\mathsf{PP}$* no requiere esta cota en la probabilidad, y la inclusión $\mathsf{NP} \subseteq \mathsf{PP}$ justifica que esta no se establezca como una clase cuyos problemas puedan resolverse de forma eficiente.
Además, podemos generalizar la clase $\mathsf{NP}$ a la clase $\mathsf{MA}$.
Estas clases dan lugar a una jerarquía de clases clásicas y probabilísticas que nos proporciona información sobre las capacidades de ambos modelos.
Existen diversos problemas abiertos en este campo.

**Capítulo 4**: En este capítulo se describe y estudia el modelo cuántico de computación.
La computación cuántica puede describirse en términos de familias de circuitos cuánticos uniformes, 
cuyas puertas son aplicaciones unitarias junto con la operación de preparación de qubits y la posibilidad de ignorar el resultado de un qubit.

Existen conjuntos finitos de puertas cuánticas (*conjuntos universales de puertas cuánticas*) que permiten aproximar cualquier otra puerta. El *teorema de Solovay-Kitaev*, para el que esbozamos la demostración, nos indica que además esta aproximación puede hacerse de forma eficiente.
El modelo cuántico generaliza al modelo clásico y probabilístico mediante el uso de la computación reversible: un proceso por el cual podemos transformar cualquier operación clásica en una operación cuántica que la generaliza en un cierto sentido.

La computación cuántica no proporciona ventajas en términos de computabilidad, pero sí lo hace potencialmente en términos de complejidad. Análogas a las clases $\mathsf{BPP}$, $\mathsf{PP}$  y $\mathsf{MA}$ podemos definir las clases $\mathsf{BQP}$, $\mathsf{PQP}$ y $\mathsf{QMA}$. El resultado $\mathsf{PQP} = \mathsf{PP}$ nos permite establecer la relación $\mathsf{BQP} \subseteq \mathsf{QMA} \subseteq \mathsf{PP}$, que nos da una cota superior clásica a las bondades de la computación cuántica. Esta cota es débil en el sentido de que creemos que $\mathsf{BQP} \neq \mathsf{QMA}$.
Puede establecerse así una jerarquía completa de clases definidas en los capítulos 2 a 4.

****

La parte informática desarrolla varios algoritmos concretos en el modelo definido en los capítulos 1 a 4, tanto de forma téorica como de forma aplicada en el lenguaje Quipper. Trata los siguientes contenidos:

**Capítulo 5**: En este capítulo se discuten brevemente los lenguajes de programación cuánticas y se justifica la elección del lenguaje de programación funcional puro Quipper, embebido en Haskell.
Quipper necesita de varios conceptos de la programación funcional tomados de Haskell, como es el caso de las mónadas, un concepto tomado de la teoría de categorías que nos permite tratar de forma pura con contexto computacionales.

Además, Quipper hace uso de las clases de tipos generalizadas de Haskell y de sus capacidades para metaprogramación en tiempo de compilación.
El modelo subyacente a Quipper es un modelo mixto, que combina los circuitos clásicos y los circuitos cuánticos en un único lenguaje de descripción.
Este lenguaje distingue entre parámetros y valores; los primeros son conocidos a la hora de generar un circuito mientras que los segundos se conocen sólo durante su ejecución.

El lenguaje se ha integrado como paquete en el sistema `stack`, en el que se han implementado la descripción de los circuitos de capítulos posteriores.
En este capítulo describimos también la lectura de funciones clásicas y su transformación a circuitos cuánticos.

**Capítulo 6:** En primer lugar, en este capítulo se describe el modelo simplificado de complejidad de consultas (*query complexity*) en el que se realizará el análisis de eficiencia de los algoritmos presentados.
Este modelo mide la complejidad de un algoritmo en función del número de consultas que hace a una cadena de caracteres dada mediante un *oráculo*.

Bajo este enfoque puede discutirse el problema de Deutsch, uno de los primeros problemas para los cuales se describió un algoritmo cuántico (el algoritmo de Deutsch-Jozsa)que superaba en el modelo de complejidad de consultas la eficiente de cualquier algoritmo clásico. 

En la práctica la ventaja es sólo respecto del caso clásico, puesto que en el caso probabilístico es asintóticamente equivalente al caso probabilístico en función del conjunto de puertas cuánticas utilizado.
Este algoritmo se ha implementado en Quipper y puede encontrarse en el código adjunto.

**Capítulo 7:** En este capítulo se describe el algoritmo de Shor.
El problema de la factorización de enteros es un problema muy relevante de forma práctica, ya que su resolución limita severamente las capacidades de algunos sistemas de encriptación actuales.
Su problema de decisión asociado está en $\mathsf{NP}$ pero no se conoce ningún algoritmo polinómico clásico o probabilístico. El algoritmo de Shor resuelve este problema en tiempo cuántico polinómico, colocándolo en $\mathsf{BQP}$.

Para hacerlo necesitamos la transformada cuántica de Fourier: un algoritmo que aplica la transformada discreta de Fourier al vector de coordenadas de un estado cuántico. Es más eficiente que cualquier algoritmo clásico conocido pero su aplicabilidad es limitada ya que no podemos recuperar fácilmente la salida; tendríamos que realizar mediciones que no nos dan estas coordenadas (*amplitudes*).
Puede describirse fácilmente en Quipper de forma recursiva.

Una de las aplicaciones más importantes es la resolución del problema de estimación de los autovalores de un operador unitario, conocido como el *algoritmo de estimación de fase cuántico*.
Este algoritmo puede describirse también de forma sencilla en Quipper, utilizando operadores que combinan operaciones monádicas.

Este algoritmo puede aplicarse en el problema de hallar el orden de un elemento del grupo de las unidades de los enteros módulo un $N$ dado, que puede implementarse en Quipper gracias a sus capacidades para lidiar con enteros de forma cuántica.

Finalmente, el problema de factorización de enteros puede reducirse de forma probabilísticaal de hallar el orden de una unidad, con lo que podemos definir finalmente el algoritmo de Shor.
La parte cuántica de este algoritmo no puede ejecutarse de forma factible en la práctica, por lo que discutimos 
la implementación de la estimación de recursos para obtener la factorización e implementamos la parte clásica.

**Capítulo 8:** En este último capítulo se discute desde la perspectiva de la complejidad de consultas el problema de búsqueda no estructurada en un conjunto de palabras.
El algoritmo más eficiente en el caso clásico y probabilístico es lineal, pero en el caso cuántico podemos encontrar un algoritmo que proporciona una ventaja cuadrática: el *algoritmo de Grover*.

Este algoritmo tiene una interpretación geométrica como la aplicación de un giro en un plano del espacio de estados que trata el algoritmo, lo que nos permite justificar su funcionamiento.
Puede implementarse de forma sencilla en Quipper, mediante la lectura de oráculos descrita anteriormente y la aplicación de operaciones de combinación monádica.
Además, este algoritmo es óptimo asintóticamente en el modelo de complejidad de consultas.

Para la ejecución del algoritmo necesitamos saber el número de soluciones, que puede obtener también de forma eficiente con el *algoritmo de conteo cuántico*.
Este algoritmo es una aplicación directa del algoritmo de estimación de fase.
Los requerimientos en términos de la dimensión del espacio de estados impiden su simulación directa, pero podemos estimar el número de recursos necesarios.

**Palabras clave:** informática teórica, computación cuántica, algoritmos cuánticos, programación funcional, problemas de búsqueda

***

Además de este texto, se incluye el código desarrollado para la simulación de los algoritmos de Grover y Deutsch-Jozsa y la estimación de recursos de los algoritmos de Shor y de conteo cuántico, así como la generación de los diagramas presentes en el texto.
Una descripción del código, sus tests y documentación puede hallarse en el apéndice suplementario, así como en los ficheros `LEEME.md` (en español) y `README.md` (en inglés).
