#!/usr/bin/env perl6

use UML::Translators;

# subset lib_type of Any where Str|False;

#| Make a UML diagram for a specified package.
sub MAIN(Str $packageName,                     #= Package name.
         Str :$type = "class",                 #= Type of the of the UML diagram.
         Str :I($path) = '',                   #= Using include path to find libraries.
         Bool :$attributes = True,             #= Should the class attributes be included in the UML diagrams or not?
         Bool :$methods = True,                #= Should the class methods be included in the UML diagrams or not?
         Bool :$conciseGrammarClasses = True   #= Should grammar classes be given concise names or not?
         ) {

    # If there is a library argument
    if $path.chars > 0 {
        given $path {
            when $_.IO.d   { CompUnit::RepositoryRegistry.use-repository(CompUnit::Repository::FileSystem.new(prefix => $path)) }
            when $_.IO.f   { note "$path if file not a directory." }
            when ! $_.IO.e { note "Unknown directory '$path'." }
        }
    }

    # Call the main function
    my Str $res = to-plant-uml($packageName, :$type, :$attributes, :$methods, :$conciseGrammarClasses);

    # Result
    say $res;
}