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
my $nameSpaceTypes = <Perl6::Metamodel::PackageHOW Perl6::Metamodel::GrammarHOW>;


#============================================================
# TraverseNameSpace
#============================================================

#| Traverse name-space for other name-spaces and classes/grammars/roles.
sub TraverseNameSpace(Str:D $packageName, Str:D $nameSpace --> List) {

    my Bool $no-package = False;
    try require ::($packageName);
    if ::($packageName) ~~ Failure {
        $no-package = True
    }

    my $pkg = ::($nameSpace);

    CATCH {
        if $no-package { warn "Cannot load package named $packageName."; }
        warn "Cannot load name space $nameSpace.";
    }

    #say '-:' x 60;
    #say '$pkg::.WHO = ', $pkg::.WHO;
    my $pkg2 = $pkg::.WHO;

    my $symbols = $pkg.HOW.^name (elem) $classTypes ?? ($packageName => $pkg, |$pkg2) !! (|$pkg2);
    #say '$symbols =', $symbols;

    #say '$symbols.map : ', $symbols.map({ $_.key => $_.value.HOW.^name });

    my @classes is List = $symbols
            .grep({ $_.value.HOW.^name (elem) (|$classTypes, |$roleTypes, |$grammarTypes) })
            .map(*.value)
            .unique;

    my @childNameSpaces is List = $symbols
            .grep({ .value.HOW.^name (elem) $nameSpaceTypes })
            .grep({ .key ne 'EXPORT' })
            .map(*.value)
            .unique;

    #say '$classes =', @classes.raku;
    #say '$childNameSpaces =', @childNameSpaces.raku;

    my $res =
            do if @childNameSpaces.elems == 0 { @classes }
            else { flat(@classes, @childNameSpaces.map({ TraverseNameSpace($packageName, $_.raku) })) };

    #say '-' x 120;

    $res.list
}


#============================================================
# ClassData
#============================================================

#| Derive class data.
sub ClassData($class) {
    my $type =
            do if $class.HOW.^name (elem) $roleTypes { 'role' }
            elsif $class.HOW.^name (elem) $grammarTypes { 'grammar' }
            elsif $class.DEFINITE { 'constant' }
            else { 'class' }

    my @methods = do if $type ∈ <class grammar> {
        $class.^method_names.sort;
    } else {
        $class.^methods>>.name.sort
    }

    if $type eq 'grammar' {
        # I am not
        %( :$type,
           :@methods,
           parents => $class.^parents,
           attributes => $class.^attributes.map(*.^name).unique.sort.Array,
           roles => $class.^roles.map({ $_.^name }).unique.sort.Array)
    } else {
        %( :$type,
           attributes => $class.^attributes.sort,
           :@methods,
           parents => $class.^parents,
           roles => $class.^roles.map({ $_.^name }).unique.sort.Array)
    }
}


#============================================================
# ClassDataToPlantUML
#============================================================

#| Generate PlantUML code from the class/grammar/role data.
sub ClassDataToPlantUML($class is copy, Bool :$attributes = True, Bool :$methods = True) {

    my %classData = ClassData($class);

    if Routine ∈ %classData<parents> {
        $class = $class.name.subst('-', '_'):g;
        %classData<type> = 'routine';
    }

    my $annot =
            do if %classData<type> eq 'role' { '<<role>>' }
            elsif %classData<type> eq 'grammar' { '<<grammar>>' }
            elsif %classData<type> eq 'routine' { '<<routine>>' }
            elsif %classData<type> eq 'constant' { '<<constant>>' }
            else { '' }

    my Str $plantUML = '';

    $plantUML = 'class ' ~ $class.raku ~ ' ' ~ $annot ~ ' {' ~ "\n";

    if $attributes and %classData<type> ∉ <constant routine> {
        for |%classData<attributes> -> $a {
            $plantUML = $plantUML ~ '  {field} ' ~ $a ~ "\n";
        }
    }

    if $methods and %classData<type> ∉ <constant routine> {
        for |%classData<methods> -> $m {
            $plantUML = $plantUML ~ '  {method} ' ~ $m ~ "\n";
        }
    }

    $plantUML = $plantUML ~ '}' ~ "\n";

    for |%classData<parents> -> $p {
        $plantUML = $plantUML ~ $class.raku ~ ' --|> ' ~ $p.raku ~ "\n"
    }

    for |%classData<roles> -> $r {
        $plantUML = $plantUML ~ $class.raku ~ ' --|> ' ~ $r ~ "\n"
    }

    $plantUML = $plantUML ~ "\n";

    return $plantUML;
}

#============================================================
# ClassDataToWLGraphUML
#============================================================

#| Generate WL graph UML code from the class/grammar/role data.
sub ClassDataToWLGraphUML($class is copy, Bool :$attributes = True, Bool :$methods = True) {

    my %classData = ClassData($class);

    if Routine ∈ %classData<parents> {
        $class = $class.name.subst('-', '_'):g;
        %classData<type> = 'routine';
    }

    my $annot =
            do if %classData<type> eq 'role' { '<<role>>' }
            elsif %classData<type> eq 'grammar' { '<<grammar>>' }
            elsif %classData<type> eq 'routine' { '<<routine>>' }
            elsif %classData<type> eq 'constant' { '<<constant>>' }
            else { '' }

    my Str %umlSpecParts;

    if $attributes and %classData<type> ∉ <constant routine> {
        %umlSpecParts<attributes> = '"' ~ $class.raku ~ '" -> {' ~ %classData<attributes>.map({ '"' ~ $_ ~ '"' }).join(', ') ~ '}';
        %umlSpecParts<attributes> .= subst('""', '"'):g;
    }

    if $methods and %classData<type> ∉ <constant routine> {
        %umlSpecParts<methods> = '"' ~ $class.raku ~ '" -> {' ~ %classData<methods>.map({ '"' ~ $_ ~ '"' }).join(', ') ~ '}';
        %umlSpecParts<methods> .= subst('""', '"'):g;
    }

    %umlSpecParts<parents> ~= [|%classData<parents>, |%classData<roles>].map({ '"' ~ $class.raku ~ '"' ~ ' \[DirectedEdge] ' ~ '"' ~ $_.raku ~ '"' }).join(', ');
    %umlSpecParts<parents> .= subst('""', '"'):g;

    %umlSpecParts<abstract> ~= %classData<roles>.unique.map({ '"' ~ $_.raku ~ '"' }).join(', ');
    %umlSpecParts<abstract> .= subst('""', '"'):g;

    return %umlSpecParts;
}


#============================================================
# to-plant-uml-spec
#============================================================

#| Get classes and roles of a namespace or a list of namespaces.
proto namespace-types($packageNames, Bool :$how-pairs = False) is export {*}

#| Get classes of a single namespace
multi namespace-types(Str $packageName, Bool :$how-pairs) {
    namespace-types([$packageName], :$how-pairs)
}

#| Get classes of a many namespaces
multi namespace-types(Positional $packageNames, Bool :$how-pairs) {
    my $res = flat($packageNames.map({ TraverseNameSpace($_, $_) }));
    if $how-pairs {
        return $res.map({
            given $_ {
                when Str { $_ => $_.^name }
                when Numeric { $_.Str => $_.^name }
                when Sub { $_.name => $_.^name }
                when Callable { $_.name => $_.^name }
                default { $_.^name => $_.HOW.^name }
            }
        });
    }
    return $res;
}


#============================================================
# to-plant-uml-spec
#============================================================

#| Translation to PlantUML proto
proto to-plant-uml-spec($packageNames, Str :$type = "class", Bool :$attributes = True, Bool :$methods = True,
                   Bool :$conciseGrammarClasses = True) is export {*}

#| Translation to PlantUML single package name
multi to-plant-uml-spec(Str $packageName, Str :$type = "class", Bool :$attributes = True, Bool :$methods = True,
                   Bool :$conciseGrammarClasses = True) {
    to-plant-uml-spec([$packageName], :$type, :$attributes, :$methods, :$conciseGrammarClasses)
}

#| Translation to PlantUML multiple package names
multi to-plant-uml-spec(Positional $packageNames, Str :$type = "class", Bool :$attributes = True, Bool :$methods = True,
                   Bool :$conciseGrammarClasses = True) {

    my @classes = flat($packageNames.map({ TraverseNameSpace($_, $_) }));

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
# to-wl-uml-spec
#============================================================

#| Translation to WL UML graph proto
proto to-wl-uml-spec($packageNames,
                      Str :$type = "class",
                      Bool :$attributes = True,
                      Bool :$methods = True,
                      Bool :$conciseGrammarClasses = True,
                      *%args) is export {*}

#| Translation to WL UML graph single package name
multi to-wl-uml-spec(Str $packageName,
                      Str :$type = "class",
                      Bool :$attributes = True,
                      Bool :$methods = True,
                      Bool :$conciseGrammarClasses = True,
                      *%args) {
    to-wl-uml-spec([$packageName], :$type, :$attributes, :$methods, |%args)
}

#| Translation to WL UML graph multiple package names
multi to-wl-uml-spec(Positional $packageNames,
                      Str :$type = "class",
                      Bool :$attributes = True,
                      Bool :$methods = True,
                      Bool :$conciseGrammarClasses = True,
                      Str :$function-name = 'UMLClassGraph',
                      :$image-size = 'Large',
                      :$graph-layout is copy = Whatever) {

    # Process graph-layout
    if $graph-layout.isa(Whatever) { $graph-layout = 'Automatic'; }

    if not $graph-layout ~~ Str {
        die "The value of the argument graph-layout is expected to be a string or Whatever.";
    }

    if ! ( $graph-layout eq 'Automatic' || (so $graph-layout ~~ rx/ ^^ [ \"  .*  \" | '{' .* '}' ] $$ /) ) {
        $graph-layout =  '"' ~ $graph-layout ~ '"';
    }

    # Get dependencies
    my @classes = flat($packageNames.map({ TraverseNameSpace($_, $_) }));

    my @res = @classes.map({ ClassDataToWLGraphUML($_, :$attributes, :$methods) });

    # UML for WL
    my $res = $function-name ~ '[' ~ "\n" ~
            '"Parents" -> Flatten[{' ~ @res.map({ $_<parents> }).grep({ $_ }).join(', ') ~ '}],' ~ "\n" ~
            '"RegularMethods" -> Flatten[{' ~ @res.map({ $_<methods> }).grep({ $_ }).join(', ') ~ '}],' ~ "\n" ~
            '"Abstract" -> ' ~ 'Flatten[{' ~ @res.map({ $_<abstract> }).grep({ $_ }).Array.unique.join(', ') ~ '}],' ~
            "\n" ~
            '"EntityColumn" -> False, VertexLabelStyle -> "Text", ImageSize -> ' ~ $image-size.Str ~ ', GraphLayout -> ' ~ $graph-layout ~ ']';

    # Result
    $res;
}

#============================================================
# to-uml
#============================================================

#| Main translation function
#| $packageNames Package names to find UML spec for.
#| :$format Format for UML spec, one of 'PlantUML', 'WL-UML-Graph', or Whatever.
#| :$type UML diagram type. (Only 'class' is currently implemented.)
#| :$attributes Should the class attributes be included in the UML diagrams or not?
#| :$methods Should the class methods be included in the UML diagrams or not?
#| :$conciseGrammarClasses Should concise grammar classes be given in concise form or not?
sub to-uml-spec($packageNames,
                :$format is copy = Whatever,
                Str :$type = 'class',
                Bool :$attributes = True,
                Bool :$methods = True,
                Bool :$conciseGrammarClasses = True,
                Bool :$compact = False,
                *%args) is export {

    if $format.isa(Whatever) { $format = 'PlantUML' }

    my $res;
    if $format.lc ∈ <plantuml plant-uml plant> {
        $res = to-plant-uml-spec($packageNames, :$type, :$attributes, :$methods, :$conciseGrammarClasses);
    } elsif $format ∈ <wl wluml wl-uml wlumlgraph wl-uml-graph mathematica> {
        $res = to-wl-uml-spec($packageNames, :$type, :$attributes, :$methods, :$conciseGrammarClasses, |%args)
    } else {
        die "Uknown format $format. The value of the arugment format is expected to be one of 'Plant', 'PlantUML', 'WL', 'WLUML', or Whatever.";
    }

    if $compact {
        $res = $res.subst(:g, / \v+ /, "\n").subst(:g, / '{' \v+ '}' /, '{}');
    }
    return $res;
}
