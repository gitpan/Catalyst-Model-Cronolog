#!perl
use strict;
use warnings;
use Test::More (tests => 2);

BEGIN
{
    use_ok("Catalyst::Model::Cronolog");
    use_ok("Catalyst::Helper::Model::Cronolog");
}

1;