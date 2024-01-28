#!/usr/bin/env perl6

use lib './lib';
use lib '.';
use UML::Translators;

# say namespace-types( "Lingua::NumericWordForms" ).raku;

#say to-plant-uml-spec( "Lingua::NumericWordForms" ):!methods:!attributes;
#say to-wl-uml-spec( "Lingua::NumericWordForms" ):!methods:!attributes;

#say namespace-types( "Data::Generators" ).raku;
#say to-plant-uml-spec( "Data::Generators" ):!methods:!attributes;
#say to-wl-uml-spec( "Data::Generators" ):!methods:!attributes;

#say to-plant-uml-spec( "ML::TriesWithFrequencies" ):methods:!attributes;
#say to-wl-uml-spec( "ML::StreamsBlendingRecommender" ):methods:!attributes;
#say to-wl-uml-spec( "ML::StreamsBlendingRecommender", wl-graph-layout => 'SpringEmbedding'):!methods:!attributes;
#say to-uml-spec( "ML::StreamsBlendingRecommender", format => 'plantuml', wl-graph-layout => 'SpringEmbedding'):!methods:!attributes;

#say &to-uml-spec.WHY;

#module MyPackageClass {
#    role A { method a1 {} }
#    class B does A { has $.b0; method b1 {} }
#    class C does A is B { has $.c0; method c1 {} }
#}

module MyPackageClass {
    role A { method a1 {} }
    role B { method a1 {} }
    class C does A { has $!b-var; method b1 {} }
    class D does B is C { has $!c-var; method c1 {} }
}

say to-uml-spec( 'ML::Clustering', format => 'mermaidjs', remove => Whatever):methods:attributes;

say '=' x 60;

#say namespace-types('Data::Reshapers' ).WHAT;
#say namespace-types('Data::Reshapers', :how-pairs).WHAT;
say namespace-types( 'DSL::English::DataQueryWorkflows', :how-pairs).map({ $_.value.Str}).raku;
say ([or] namespace-types( 'DSL::English::DataQueryWorkflows', :how-pairs).map({ $_.value.Str.contains('Role')}));
#.say for namespace-types( 'DSL::English::RecommenderWorkflows' ):how-pairs;
#say to-uml-spec( 'Data::Reshapers' );

#say to-uml-spec('Chemistry::Stoichiometry', removed=><Chemistry::Stoichiometry::Grammar::ChemicalEquation Chemistry::Stoichiometry::Grammar::ChemicalElement>):!methods:!attributes;
#say to-uml-spec('Chemistry::Stoichiometry', removed=><Chemistry::Stoichiometry::Grammar::ChemicalEquation, >):!methods:!attributes;
#say to-uml-spec('Chemistry::Stoichiometry'):!methods:!attributes;
#say to-uml-spec('MyPackageClass'):!methods:!attributes;

#say to-uml-spec('Cro', :!methods, :!attributes).subst(:g, / '}' \h+ \v+ /, '}\n');

#say '=' x 60;
#
#.say for namespace-types( 'ML::TriesWithFrequencies' ):how-pairs;
#
#say '=' x 60;
#
#.say for namespace-types( 'ML::StreamsBlendingRecommender' ):how-pairs;
#
#say '=' x 60;
#
#.say for namespace-types( 'Data::Reshapers' ):how-pairs;
#
#say '=' x 60;
#
#.say for namespace-types( 'Lingua::NumericWordForms' ):how-pairs;

#say namespace-types( "Saiph" ).raku;
#say to-wl-uml-spec( "DSL::English::DataQueryWorkflows" ):!methods:!attributes;
