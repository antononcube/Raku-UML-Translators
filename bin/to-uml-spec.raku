#!/usr/bin/env perl6

use UML::Translators;

#| Main program
sub MAIN(Str $packageName, Str :$type = "class", Bool :$attributes = True, Bool :$methods = True, Bool :$conciseGrammarClasses = True) {

    my Str $res = to-plant-uml($packageName, :$type, :$attributes, :$methods, :$conciseGrammarClasses);

    say $res;
}