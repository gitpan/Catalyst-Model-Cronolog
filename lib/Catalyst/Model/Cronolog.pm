# $Id: Cronolog.pm 5 2007-01-22 05:28:39Z daisuke $
#
# Copyright (c) 2007 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package Catalyst::Model::Cronolog;
use strict;
use base 'Catalyst::Model';
use Carp qw(croak);
use Class::C3;
use IO::Handle;
our $VERSION = '0.01';

sub new
{
    my ($self, $c, $arguments) = @_;

    $self = $self->next::method(@_);
    $self->{cronolog_handle} = $self->create_cronolog_handle($c);

    $self->config->{template} or die "template required for Cronolog model";
    return $self;
}

sub create_cronolog_handle
{
    my ($self, $c) = @_;

    my $config = $self->config;
    my $cmd    = "|$config->{cronolog} $config->{template}";
    if ($c && $c->log->is_debug) {
        $c->log->debug("Executing $cmd");
    }
    open(my $fh, $cmd) or
        croak("Failed to open pipe for cronolog: $!");
    $fh->autoflush(1);
    return $fh;
}

sub create
{
    my ($self, $message, $opts) = @_;
    $opts ||= {};

    if ($message !~ /\n$/) {
        $message =~ s/$/\n/;
    }
    my $fh = $self->{cronolog_handle};
    if (! $fh || $fh->eof) {
        $fh = $self->create_cronolog_handle();
        $self->{cronolog_handle} = $fh;
    }

    print $fh ($message);
}

1;

__END__

=head1 NAME

Catalyst::Model::Cronolog - Cronolog Model Class

=head1 SYNOPSIS

  ./script/myapp_create.pl model Cronolog Cronolog

  package MyApp::Model::Cronolog;
  use strict;
  use warnings;
  use base qw(Catalyst::Model::Cronolog);

  __PACKAGE__->config(
    cronolog => "/path/to/cronolog",
    template => "path/to/log/%Y/%m/mylog.log"
  );

  # In your app..

  $c->model('Cronolog')->create("Line to log");

=head1 DESCRIPTION

This is a simple model that allows you easy data store by means for cronolog.
See http://cronolog.org for details on how cronolog works.

C::M::Cronolog wraps cronolog so that you can keep writing data to files 
without having to rotate and/or otherwise manipulate the files.

=head1 CONFIGURATION

You must set the following parameters in your model config:

=head2 cronolog

Specifies the path to the cronolog executable. This is typically 
/usr/local/sbin/cronolog in a unix-like system

=head2 template

Specifies the template name for cronolog to use.

=head1 AUTHOR

Copyright (c) 2007 Daisuke Maki E<lt>daisuke@endeworks.jpE<gt>
All rights reserved.

=cut