package App::crypt::Command::encrypt;
# ABSTRACT: Encrypts files or directories with a aes-256-cbc cipher

use App::crypt -command;

use strict;
use warnings;
use Readonly;

Readonly my %OPENSSL_BASE_COMMAND => (
  'openssl'  => 'openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt',
  'libressl' => 'openssl enc -e -aes-256-cbc -salt'
);

sub usage_desc { "crypt encrypt FILE1 [FILE2 ...]" }

sub description {
  return <<~ "EOF";
    Encrypts a file with 'aes-256-cbc' encryption. This command is really just a
    QoL wrapper around the 'openssl' command.
  EOF
}

sub validate_args {
  my ( $self, $opt, $args ) = @_;

  unless (@$args) {
    $self->usage_error("Requires at least one filename\n");
  }
}

sub execute {
  my ( $self, $opt, $args ) = @_;

  my $openssl_type = $self->app->config->{'openssl_type'};
  unless ( $OPENSSL_BASE_COMMAND{$openssl_type} ) {
    print "Unable to determine openssl command\n";
    exit 1;
  }

  for my $filename_or_directory ( @{$args} ) {
    print 'Encrypting Target ' . $filename_or_directory . "\n";

    unless ( -r $filename_or_directory ) {
      print "Target is not readable. Skipping!\n";
      print '-' x 10 . "\n";
      next;
    }

    if ( -d $filename_or_directory ) {
      print "Target is a directory... archiving and encrypting\n";

      my $encrypted_directory = join '.', $filename_or_directory, 'tar', 'gz', 'enc';
      `tar czf - $filename_or_directory | $OPENSSL_BASE_COMMAND{$openssl_type} -out $encrypted_directory`;
    }
    elsif ( -f $filename_or_directory ) {
      print "Target is a file... encrypting\n";

      my $encrypted_filename = join '.', $filename_or_directory, 'enc';
      `$OPENSSL_BASE_COMMAND{$openssl_type} -in $filename_or_directory -out $encrypted_filename`;
    }
    else {
      print "Target is not a 'file' or 'directory' type. Skipping!\n";
    }
  }

}

1;
