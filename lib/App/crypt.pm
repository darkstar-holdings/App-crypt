package App::crypt;

use App::Cmd::Setup -app;

our $VERSION = '0.0.1';

sub config {
  my $app = shift;
  $app->{'config'} ||= _init_config();
}

sub _init_config {
  my $app = shift;
  
  my $openssl_version_string = '';

  unless ( $openssl_version_string = `openssl version` ) {
     exit 1;
  }

  $openssl_version_string =~ m/^(\w+)/;

  return {
    openssl_type => lc ($1 || '')
  }
}

1;

__END__
=encoding utf-8

=head1 NAME

App::crypt - An openssl wrapper to encrypt and decrypt files.

=head1 DESCRIPTION

This is a Quality of Life (QoL) openssl command wrapper that
handles all my standard file/directory encryption/decryption
needs.

=head1 AUTHOR

David Betz E<lt>hashref@gmail.comE<gt>

=head1 COPYRIGHT

This software is copyright (c) 2021 by David Betz
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
