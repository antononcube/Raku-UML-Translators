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

### Usage examples

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

-----

## Raku session

### UML for ad hoc classes

```perl6
use UML::Translators;
module MyPackageClass {
  role A { method a1 {} }
  class B does A { has $!b0; method b1 {} }
  class C does A is B { has $!c0; method c1 {} }
}
to-uml-spec('MyPackageClass')
```
```
# @startuml
# class MyPackageClass::A <<role>> {
#   {method} a1
# }
# 
# 
# class MyPackageClass::C  {
#   {field} $!b0
#   {field} $!c0
#   {method} BUILDALL
#   {method} a1
#   {method} c1
# }
# MyPackageClass::C --|> MyPackageClass::B
# MyPackageClass::C --|> MyPackageClass::A
# 
# 
# class MyPackageClass::B  {
#   {field} $!b0
#   {method} BUILDALL
#   {method} a1
#   {method} b1
# }
# MyPackageClass::B --|> MyPackageClass::A
# 
# 
# @enduml
```

### UML for packages

Get PlantUML code for the package
['Chemistry::Stoichiometry'](https://raku.land/cpan:ANTONOV/Chemistry::Stoichiometry):

```perl6
say to-uml-spec('Chemistry::Stoichiometry'):!methods:!attributes
```
```
# @startuml
# class Chemistry::Stoichiometry::ResourceAccess  {
# }
# 
# 
# class Chemistry::Stoichiometry::Grammar <<grammar>> {
# }
# Chemistry::Stoichiometry::Grammar --|> Grammar
# Chemistry::Stoichiometry::Grammar --|> Match
# Chemistry::Stoichiometry::Grammar --|> Capture
# Chemistry::Stoichiometry::Grammar --|> Chemistry::Stoichiometry::Grammar::ChemicalElement
# Chemistry::Stoichiometry::Grammar --|> Chemistry::Stoichiometry::Grammar::ChemicalEquation
# Chemistry::Stoichiometry::Grammar --|> NQPMatchRole
# 
# 
# class Chemistry::Stoichiometry::Actions::EquationMatrix  {
# }
# 
# 
# class Chemistry::Stoichiometry::Actions::EquationBalance  {
# }
# Chemistry::Stoichiometry::Actions::EquationBalance --|> Chemistry::Stoichiometry::Actions::EquationMatrix
# 
# 
# class Chemistry::Stoichiometry::Actions::MolecularMass  {
# }
# 
# 
# class Chemistry::Stoichiometry::Actions::WL::System  {
# }
# 
# 
# @enduml
```

Get WL UML graph spec for the package [AAp1]:

```perl6
say to-uml-spec('Chemistry::Stoichiometry', format => 'wluml'):!methods:!attributes
```
```
# UMLClassGraph[
# "Parents" -> Flatten[{"Chemistry::Stoichiometry::Grammar" \[DirectedEdge] "Grammar", "Chemistry::Stoichiometry::Grammar" \[DirectedEdge] "Match", "Chemistry::Stoichiometry::Grammar" \[DirectedEdge] "Capture", "Chemistry::Stoichiometry::Grammar" \[DirectedEdge] "Chemistry::Stoichiometry::Grammar::ChemicalElement", "Chemistry::Stoichiometry::Grammar" \[DirectedEdge] "Chemistry::Stoichiometry::Grammar::ChemicalEquation", "Chemistry::Stoichiometry::Grammar" \[DirectedEdge] "NQPMatchRole", "Chemistry::Stoichiometry::Actions::EquationBalance" \[DirectedEdge] "Chemistry::Stoichiometry::Actions::EquationMatrix"}],
# "RegularMethods" -> Flatten[{}],
# "Abstract" -> Flatten[{"Chemistry::Stoichiometry::Grammar::ChemicalElement", "Chemistry::Stoichiometry::Grammar::ChemicalEquation", "NQPMatchRole"}],
# "EntityColumn" -> False, VertexLabelStyle -> "Text", ImageSize -> Large, GraphLayout -> "CircularEmbedding"]
```

### Classes in a name space

Get the classes, roles, subs, and constants of a namespace:

```perl6
.say for namespace-types('ML::TriesWithFrequencies', :how-pairs).sort(*.key)
```
```
# ML::TriesWithFrequencies::LeafProbabilitiesGatherer => Perl6::Metamodel::ClassHOW
# ML::TriesWithFrequencies::ParetoBasedRemover => Perl6::Metamodel::ClassHOW
# ML::TriesWithFrequencies::PathsGatherer => Perl6::Metamodel::ClassHOW
# ML::TriesWithFrequencies::RegexBasedRemover => Perl6::Metamodel::ClassHOW
# ML::TriesWithFrequencies::ThresholdBasedRemover => Perl6::Metamodel::ClassHOW
# ML::TriesWithFrequencies::Trie => Perl6::Metamodel::ClassHOW
# ML::TriesWithFrequencies::TrieTraverse => Perl6::Metamodel::ParametricRoleGroupHOW
# ML::TriesWithFrequencies::Trieish => Perl6::Metamodel::ParametricRoleGroupHOW
# TRIEROOT => Str
# TRIEVALUE => Str
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

