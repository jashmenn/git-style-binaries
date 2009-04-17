git-style-binaries
==================

Super simple git-style binaries

## Overview 

What that even means. Lets use the wordpress.rb gem:

You have a `bin/wordpress`. This file should contain a simple `require` if you

## Help

    wordpress --help

shows all available subcommands like:

    usage: wordpress [--version] [--help] [--verbose] COMMAND [ARGS]

    The most commonly used wordpress commands are:
       post       Post an article
       list       List articles
       category   Add a category

    See 'wordpress help COMMAND' for more information on a specific command.

For any subcommand, `--help` by default will call `wordpress help COMMAND`

## Global options

If you want to specify global options or global actions you can do the following:

TODO 

## Subcommands

Subcommands should be created as follows:

    $ tree bin/
    bin/
    |-- wordpress
    |-- wordpress-post
    |-- wordpress-list
    |-- wordpress-category

They can be implemented as follows

## Tab completion

Automatic for subcommands and options for any library that uses this

## Colorization

Maybe use a colorization library by default? See man git-add. add in how to get these colors via less on a mac.

## Copyright

Copyright (c) 2009 Nate Murray. See LICENSE for details.
