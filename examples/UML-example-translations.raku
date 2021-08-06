#!/usr/bin/env perl6

use lib './lib';
use lib '.';
use UML::Translators;

say get-namespace-classes( "Lingua::NumericWordForms" ).raku;

say to-plant-uml( "Lingua::NumericWordForms" ):!methods:!attributes;