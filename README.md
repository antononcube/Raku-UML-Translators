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

### From PAUSE

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
> to-uml-spec --help
Usage:
  to-uml-spec [--type=<Str>] [-I=<Str>] [--attributes] [--methods] [--conciseGrammarClasses] [--format=<Str>] <packageName> -- Make a UML diagram for a specified package.
  
    <packageName>              Package name.
    --type=<Str>               Type of the UML diagram. [default: 'class']
    -I=<Str>                   Using include path to find libraries. [default: '']
    --attributes               Should the class attributes be included in the UML diagrams or not? [default: True]
    --methods                  Should the class methods be included in the UML diagrams or not? [default: True]
    --conciseGrammarClasses    Should grammar classes be shortened or not? [default: True]
    --format=<Str>             Format of the output, one of 'Plant', 'PlantUML', 'WL', 'WLUML', or 'Whatever'. [default: 'PlantUML']
```

------ 

## Examples

### OS command line terminal

Using the script [`to-uml-spec`](bin/to-uml-spec):

```shell
to-uml-spec --/methods --/attributes "Lingua::NumericWordForms"
```

With this shell command we generate a Plant UML spec for the package 
["Chemistry::Stoichiometry"](https://raku.land/cpan:ANTONOV/Chemistry::Stoichiometry)
and create the UML diagram image with a local PlantUML JAR file (downloaded from [PUML1]):

```shell
to-uml-spec --/methods --/attributes 'Chemistry::Stoichiometry' | java -jar ~/Downloads/plantuml-1.2022.5.jar -pipe -tjpg > /tmp/myuml.jpg
```

### Raku session

Get the classes of a name space:

```perl6
use UML::Translators;
say get-namespace-classes( "Lingua::NumericWordForms" ).raku;
```

Get PlantUML code:

```perl6
use UML::Translators;
say to-uml-spec("Lingua::NumericWordForms"):!methods:!attributes
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

