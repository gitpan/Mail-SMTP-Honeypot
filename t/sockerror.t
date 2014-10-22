# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.
# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..5\n"; }
END {print "not ok 1\n" unless $loaded;}

#use diagnostics;

use Mail::SMTP::Honeypot;
*sockerror = \&Mail::SMTP::Honeypot::sockerror;

use POSIX qw(EINTR EWOULDBLOCK);

$loaded = 1;
print "ok 1\n";
######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

$test = 2;

sub ok {
  print "ok $test\n";
  ++$test;
}

if (0) {
umask 027;
foreach my $dir (qw(tmp)) {
  if (-d $dir) {         # clean up previous test runs
    opendir(T,$dir);
    @_ = grep($_ ne '.' && $_ ne '..', readdir(T));
    closedir T;
    foreach(@_) {
      unlink "$dir/$_";
    }
    rmdir $dir or die "COULD NOT REMOVE $dir DIRECTORY\n";
  }
  unlink $dir if -e $dir;       # remove files of this name as well
}

my $dir = './tmp';
mkdir $dir;
} # if 0

sub next_sec {
  my ($then) = @_;
  $then = time unless $then;
  my $now;
# wait for epoch
  do { select(undef,undef,undef,0.1); $now = time }
        while ( $then >= $now );
  $now;
}

## test 2
print "did not recognize EINTR\nnot "
	unless sockerror(EINTR) == 0;
&ok;

## test 3
print "did not recognize EWOULDBLOCK\nnot "
	unless sockerror(EWOULDBLOCK) == 0;
&ok;

## test 4
print "did not recognize valid error\nnot "
	unless sockerror(99);
&ok;

## test 5
print "faulty return on NOERROR\nnot "
	if sockerror(0);
&ok;
