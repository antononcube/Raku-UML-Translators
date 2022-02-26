# Raku UML::Translators

This repository has the code of a Raku package 
that provides functions to translate code into Unified Modeling Language (UML) specifications
and vice versa.

Currently, the package only translates Object-Oriented Programming (OOP) Raku code into 
[PlantUML](https://plantuml.com). 

A fully fledged version of this package would translate:
- C++, Java, Kotlin, or Raku code into UML specs
- UML specs into C++, Java, Kotlin, or Raku code

Currently, the UML specs can be generated or given in PlantUML's language.
A fully fledged version of this package would be able to use UML specifications
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

## Arguments

```shell
> to-uml-spec --help
Usage:
  to-uml-spec [--type=<Str>] [-I=<Str>] [--attributes] [--methods] [--conciseGrammarClasses] <packageName> -- Make a UML diagram for a specified package.
  
    <packageName>              Package name.
    --type=<Str>               Type of the UML diagram. [default: 'class']
    -I=<Str>                   Using include path to find libraries. [default: '']
    --attributes               Should the class attributes be included in the UML diagrams or not? [default: True]
    --methods                  Should the class methods be included in the UML diagrams or not? [default: True]
    --conciseGrammarClasses    Should grammar classes be shortened or not? [default: True]
```

------ 

## Examples

### OS command line terminal

Using the script [`to-uml-spec`](bin/to-uml-spec):

```shell
to-uml-spec --/methods --/attributes "Lingua::NumericWordForms"
```

(That script has to be an executable.)

### Raku session

Get the classes of a name space:

```perl6
use UML::Translators;
say get-namespace-classes( "Lingua::NumericWordForms" ).raku;
```

Get PlantUML code:

```perl6
use UML::Translators;
say to-uml("Lingua::NumericWordForms"):!methods:!attributes
```

------ 

## References

[WK1] Wikipedia entry, 
["Unified Modeling Language"](https://en.wikipedia.org/wiki/Unified_Modeling_Language).

[WK2] Wikipedia entry,
["PlantUML"](https://en.wikipedia.org/wiki/PlantUML).

[UMLD1] [uml-diagrams.org](https://www.uml-diagrams.org).

[PUML1] [plantuml.com](https://plantuml.com).

[PUML2] [PlantUML online demo server](http://www.plantuml.com/plantuml).

[ES1] Eugene Steinberg and Vojtech Krasa,
[PlantUML integration IntelliJ IDEA plugin](https://plugins.jetbrains.com/plugin/7017-plantuml-integration),
[JetBrains Plugins Marketplace](https://plugins.jetbrains.com).
