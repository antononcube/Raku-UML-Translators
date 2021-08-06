# Raku UML::Translators

This repository has the code of a Raku package 
that provides functions to translate code into Unified Modeling Language (UML) specifications
and vice versa.

Currently, the package only translates Object-Oriented Programming (OOP) Raku code into 
[PlantUML](https://plantuml.com). 

A fully fledged version of this package would translate:
- C++. Java, Kotlin, Raku code into UML specs
- UML specs into C++, Java, Kotlin, Raku code

## Installation

### From PAUSE

```shell
zef install UML::Translators
```

### From GitHub

```
zef install https://github.com/antononcube/Raku-UML-Translators.git 
```

## Examples

### OS command line terminal

```shell
to-uml-spec --/method --/attributes "Lingua::NumericWordForms"
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
say to-uml("Lingua::NumericWordForms"):!methods:!attributes
```

## References

[WK1] Wikipedia entry, 
["Unified Modeling Language"](https://en.wikipedia.org/wiki/Unified_Modeling_Language).

[WK2] Wikipedia entry,
["PlantUML"](https://en.wikipedia.org/wiki/PlantUML).

[UMLD1] https://www.uml-diagrams.org

[PUML1] https://plantuml.com

[PUML2] http://www.plantuml.com/plantuml/

[ES1] Eugene Steinberg, Vojtech Krasa,
[PlantUML integration IntelliJ IDEA plugin](https://plugins.jetbrains.com/plugin/7017-plantuml-integration),
[JetBrains Plugins Marketplace](https://plugins.jetbrains.com)
