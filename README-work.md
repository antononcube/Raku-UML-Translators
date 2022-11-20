# Raku UML::Translators

## In brief

This repository is for a Raku package for the translations of code into 
[Unified Modeling Language (UML)](https://en.wikipedia.org/wiki/Unified_Modeling_Language) 
specifications and vice versa.

Currently, the package only translates Object-Oriented Programming (OOP) Raku code into: 

- The Domain Specific Language (DSL) of [PlantUML](https://plantuml.com)

- Argument specification of the UML class diagram function [`UMLClassGraph`](https://github.com/antononcube/MathematicaForPrediction/blob/master/Misc/UMLDiagramGeneration.m)
  of the Mathematica / Wolfram Language (WL) package [AAp1] 

### Future plans

A fully fledged version of this package would translate:
- C++, Java, Kotlin, or Raku code into UML specs
- UML specs into C++, Java, Kotlin, or Raku code

Currently, only UML specs are generated to PlantUML's DSL and a much poorer WL DSL.
Ideally, subsequent versions of this package would be able to use UML specifications
encoded in XML and JSON.

------ 

## Installation

### From zef's ecosystem

```shell
zef install UML::Translators
```

### From GitHub

```
zef install https://github.com/antononcube/Raku-UML-Translators.git 
```

------ 

## Command Line Interface (CLI)

```shell
to-uml-spec --help
```

### Usage examples

Using the script [`to-uml-spec`](bin/to-uml-spec):

```shell
to-uml-spec --/methods --/attributes "ML::Clustering"
```

With this shell command we generate a Plant UML spec for the package 
["Chemistry::Stoichiometry"](https://raku.land/cpan:ANTONOV/Chemistry::Stoichiometry)
and create the UML diagram image with a local PlantUML JAR file (downloaded from [PUML1]):

```
to-uml-spec --/methods --/attributes 'Chemistry::Stoichiometry' | java -jar ~/Downloads/plantuml-1.2022.5.jar -pipe -tjpg > /tmp/myuml.jpg
```

-----

## Raku session

### UML for ad hoc classes

```perl6
use UML::Translators;
module MyPackageClass {
  role A { method a1 {} }
  role B { method b1 {} }
  class C does A { has $!c-var; method c1 {} }
  class D does B is C { has $!d-var; method d1 {} }
}
to-uml-spec('MyPackageClass')
```

### UML for packages

Get PlantUML code for the package
['Chemistry::Stoichiometry'](https://raku.land/cpan:ANTONOV/Chemistry::Stoichiometry):

```perl6
say to-uml-spec('Chemistry::Stoichiometry'):!methods:!attributes
```

Get WL UML graph spec for the package [AAp1]:

```perl6
say to-uml-spec('Chemistry::Stoichiometry', format => 'wluml'):!methods:!attributes
```

### Classes in a name space

Get the classes, roles, subs, and constants of a namespace:

```perl6
.say for namespace-types('ML::TriesWithFrequencies', :how-pairs).sort(*.key)
```

------ 

## Potential problems

### Mermaid JS

The package can export class diagrams in the 
[Mermaid-JS format](https://mermaid-js.github.io/mermaid/#/classDiagram).
Unfortunately, currently (November 2022) Mermaid-JS does not support colon characters in class names.
Hence, colons are replaced with underscores.

Also, currently (November 2022) class specs in Mermaid-JS cannot be empty. I.e. the Mermaid JS code
generated here ***will not*** produce a diagram:

```shell
to-uml-spec --/methods --/attributes "ML::Clustering" --format=mermaid  
```

(Because of the empty definition `ML_Clustering_KMeans {  }`.)

This command should produce Mermaid JS code that will produce diagram:

```
to-uml-spec --/methods --/attributes "ML::Clustering" --format=mermaid  
```

------ 

## References

[AA1] Anton Antonov, et al.,
["Find programmatically all classes, grammars, and roles in a Raku package"](https://stackoverflow.com/q/68622047/14163984),
(2021),
[StackOverflow](https://stackoverflow.com).

[AAp1] Anton Antonov,
["UML Diagram Generation Mathematica package"](https://github.com/antononcube/MathematicaForPrediction/blob/master/Misc/UMLDiagramGeneration.m),
(2016),
[MathematicaForPrediction at GitHub/antononcube](https://github.com/antononcube).

[ES1] Eugene Steinberg and Vojtech Krasa, 
[PlantUML integration IntelliJ IDEA plugin](https://plugins.jetbrains.com/plugin/7017-plantuml-integration), 
[JetBrains Plugins Marketplace](https://plugins.jetbrains.com).

[GV1] [graphviz.org](https://graphviz.org).

[PUML1] [plantuml.com](https://plantuml.com).

[PUML2] [PlantUML online demo server](http://www.plantuml.com/plantuml).

[UMLD1] [uml-diagrams.org](https://www.uml-diagrams.org).

[WK1] Wikipedia entry, ["Graphviz"](https://en.wikipedia.org/wiki/Graphviz).

[WK2] Wikipedia entry, ["PlantUML"](https://en.wikipedia.org/wiki/PlantUML).

[WK3] Wikipedia entry, ["Unified Modeling Language"](https://en.wikipedia.org/wiki/Unified_Modeling_Language).

