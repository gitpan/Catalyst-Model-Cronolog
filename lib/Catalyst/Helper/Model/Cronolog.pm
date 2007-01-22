# $Id: Cronolog.pm 5 2007-01-22 05:28:39Z daisuke $

package Catalyst::Helper::Model::Cronolog;
use strict;
use warnings;
use File::Find::Rule;

sub mk_compclass
{
    my ($self, $helper, $cronolog, $template) = @_;

    $helper->{cronolog} = $cronolog || do {
        print STDERR "Searching for cronolog...\n";
        my @files = File::Find::Rule
            ->file()
            ->name('cronolog')
            ->executable()
            ->in(qw(/usr/local/sbin /usr/local/bin /usr/sbin /usr/bin/));
        $files[0];
    };
    $helper->{cronolog_template} = $template;

    $helper->render_file('mainclass', $helper->{file});
}

=head1 NAME

Catalyst::Helper::Model::Cronolog - Helper for Cronolog Models

=head1 SYNOPSIS

   script/myapp_create.pl model Cronolog Cronolog
   script/myapp_create.pl model Cronolog Cronolog /path/to/cronlog cronolog_template

=head1 DESCRIPTION

Helper for Cronolog Models.

=head1 METHODS

=head2 mk_compclass

Composes the main model class.

=head1 SEE ALSO

L<Catalyst>, L<Catalyst::Model>

=head1 AUTHOR

Copyright (c) 2007 Daisuke Maki E<lt>daisuke@endeworks.jpE<gt>
All rights reserved.

=cut

1;

__DATA__

=begin pod_to_ignore

__mainclass__
package [% class %];
use strict;
use warnings;
use base qw(Catalyst::Model::Cronolog);

__PACKAGE__->config(
    cronolog => '[% cronolog %]',
    template => '[% cronolog_template %]'
);

=head1 NAME

[% class %] - Cronolog Model Calss

=head1 SYNOPSIS

See L<[% app %]>

=head1 DESCRIPTION

Cronolog Model Class

=head1 AUTHOR

[% author %]

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

1;
