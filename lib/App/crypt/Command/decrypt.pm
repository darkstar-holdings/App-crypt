package App::crypt::Command::decrypt;
# ABSTRACT: Decrypts an aes-256-cbc encrypted files

use strict;
use warnings;
use Readonly;

use App::crypt -command;

Readonly my %OPENSSL_BASE_COMMAND => (
  'openssl'  => 'openssl enc -aes-256-cbc -d -md sha512 -pbkdf2 -iter 100000 -salt',
  'libressl' => 'openssl enc -d -aes-256-cbc'
);

sub usage_desc { "crypt decrypt FILE1 [FILE2 ...]" }

sub description {
  return <<~ "EOF";
    Decrypts an 'aes-256-cbc' encrypted file. This command is really just a
    QoL wrapper around the 'openssl' command.
  EOF
}

sub validate_args {
  my ( $self, $opt, $args ) = @_;

  unless (@$args) {
    $self->usage_error("Requires at least one encrypted filename\n");
  }
}

sub execute {
  my ( $self, $opt, $args ) = @_;

  my $openssl_type = $self->app->config->{'openssl_type'};
  unless ( $OPENSSL_BASE_COMMAND{$openssl_type} ) {
    print "Unable to determine openssl command\n";
    exit 1;
  }

  for my $encrypted_filename ( @{$args} ) {
    print 'Decrypting Target Filename ' . $encrypted_filename . "\n";

    unless ( -r $encrypted_filename ) {
      print "Target is not readable. Skipping!\n";
      print '-' x 10 . "\n";
      next;
    }

    if ( -f $encrypted_filename ) {
      ( my $decrypted_filename = $encrypted_filename ) =~ s/.enc$//;

      `$OPENSSL_BASE_COMMAND{$openssl_type} -in $encrypted_filename -out $decrypted_filename`;
    }
    else {
      print "Target is not a 'file' type. Skipping!\n";
      print '-' x 10 . "\n";
    }
  }

}

1;

__END__

=head1 ABSTRACT

Test This.
