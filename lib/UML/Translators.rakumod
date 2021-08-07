use v6;

#============================================================
# Meta types
#============================================================

#| Meta types for classes
my $classTypes = <Perl6::Metamodel::ClassHOW>;

#| Meta types for grammars
my $grammarTypes = <Perl6::Metamodel::GrammarHOW>;

#| Meta types for roles
my $roleTypes = <Perl6::Metamodel::CurriedRoleHOW Perl6::Metamodel::ConcreteRoleHOW Perl6::Metamodel::RolePunning Perl6::Metamodel::RoleContainer Perl6::Metamodel::ParametricRoleGroupHOW>;

#| Meta types for packages / name-spaces
my $nameSpaceTypes = <Perl6::Metamodel::PackageHOW>;


#============================================================
# TraverseNameSpace
#============================================================

#| Traverse name-space for other name-spaces and classes/grammars/roles.
sub TraverseNameSpace(Str:D $packageName, Str:D $nameSpace) {

    require ::($packageName);
    my $pkg = ::($nameSpace);

    #say '$pkg::.WHO = ', $pkg::.WHO;
    my $pkg2 = $pkg::.WHO;

    my $symbols = (|$pkg2);
    #say '$symbols =', $symbols;

    #say $symbols.map({ $_.key => $_.value.HOW.^name });

    my @classes = $symbols
            .grep({ $_.value.HOW.^name (elem) (|$classTypes, |$roleTypes, |$grammarTypes) })
            .map(*.value)
            .unique;

    my @childNameSpaces = $symbols
            .grep({ .value.HOW.^name (elem) $nameSpaceTypes })
            .grep({ .key ne 'EXPORT' })
            .map(*.value)
            .unique;

    #say '$classes =', @classes.raku;
    #say '$childNameSpaces =', @childNameSpaces.raku;

    if @childNameSpaces.elems == 0 { @classes }
    else { flat @classes, @childNameSpaces.map({ TraverseNameSpace($packageName, $_.raku) }) }
}


#============================================================
# ClassData
#============================================================

#| Derive class data.
sub ClassData($class) {
    my $type =
            do if $class.HOW.^name (elem) $roleTypes { 'role' }
            elsif $class.HOW.^name (elem) $grammarTypes { 'grammar' }
            else { 'class' }

    %( :$type, attributes => $class.^attributes>>.^name, methods => $class.^methods>>.name, parents => $class.^parents, roles => $class.^roles.map( { $_.^name } ))
}


#============================================================
# ClassDataToPlantUML
#============================================================

#| Generate PlantUML code from the class/grammar/role data.
sub ClassDataToPlantUML($class, Bool :$attributes = True, Bool :$methods = True) {

    my %classData = ClassData($class);

    my $annot =
            do if %classData<type> eq 'role' { '<<role>>' }
            elsif %classData<type> eq 'grammar' { '<<grammar>>' }
            else { '' }

    my Str $plantUML = '';

    $plantUML = 'class ' ~ $class.raku ~ ' ' ~ $annot ~ ' {' ~ "\n";



    if $attributes {
        for |%classData<attributes> -> $a {
            $plantUML = $plantUML ~ '  {field} ' ~ $a.^name ~ "\n";
        }
    }

    if $methods {
        for |%classData<methods> -> $m {
            $plantUML = $plantUML ~ '  {method} ' ~ $m.raku ~ "\n";
        }
    }

    $plantUML = $plantUML ~ '}' ~ "\n";

    for |%classData<parents> -> $p {
        $plantUML = $plantUML ~ $class.raku ~ " --|> " ~ $p.raku ~ "\n"
    }

    for |%classData<roles> -> $r {
        $plantUML = $plantUML ~ $class.raku ~ " --|> " ~ $r.raku ~ "\n"
    }

    $plantUML = $plantUML ~ "\n";

    $plantUML
}

#============================================================
# to-plant-uml
#============================================================

#| Get namespace proto
proto get-namespace-classes( $packageNames ) is export {*}

#| Get classes of a single namespace
multi get-namespace-classes(Str $packageName ) {
    get-namespace-classes( [$packageName] )
}

#| Get classes of a many namespaces
multi get-namespace-classes(Positional $packageNames) {
    flat( $packageNames.map({ TraverseNameSpace($_, $_) }) );
}


#============================================================
# to-plant-uml
#============================================================

#| Translation to PlantUML proto
proto to-plant-uml( $packageNames, Str :$type = "class", Bool :$attributes = True, Bool :$methods = True, Bool :$conciseGrammarClasses = True) is export {*}

#| Translation to PlantUML single package name
multi to-plant-uml(Str $packageName, Str :$type = "class", Bool :$attributes = True, Bool :$methods = True, Bool :$conciseGrammarClasses = True) {
    to-plant-uml( [$packageName], :$type, :$attributes, :$methods, :$conciseGrammarClasses )
}

#| Translation to PlantUML multiple package names
multi to-plant-uml(Positional $packageNames, Str :$type = "class", Bool :$attributes = True, Bool :$methods = True, Bool :$conciseGrammarClasses = True) {

    my @classes = flat( $packageNames.map({ TraverseNameSpace($_, $_) }) );

#        for @classes -> $cl {
#            say '=' x 30;
#            say $cl.raku;
#            say ClassData( $cl );
#        }

    my $res = @classes.map({ ClassDataToPlantUML($_, :$attributes, :$methods) }).join("\n");

    $res = "@startuml\n" ~ $res ~ "\n@enduml";

    $res;
}


#============================================================
# to-uml
#============================================================

#| Proto of the main translation function
proto to-uml($packageNames, Str :$format = 'PlantUML', Str :$type = 'class', Bool :$attributes = True, Bool :$methods = True, Bool :$conciseGrammarClasses = True) is export {*};

#| Main translation function
multi to-uml($packageNames, Str :$format = 'PlantUML', Str :$type = 'class', Bool :$attributes = True, Bool :$methods = True, Bool :$conciseGrammarClasses = True) {
    to-plant-uml( $packageNames, :$type, :$attributes, :$methods, :$conciseGrammarClasses )
}
