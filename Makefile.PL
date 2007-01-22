#!perl
use strict;
use inc::Module::Install;

name("Catalyst-Model-Cronolog");
all_from("lib/Catalyst/Model/Cronolog.pm");
license("perl");

build_requires("Test::More");
requires("Catalyst::Devel");

WriteAll;
