#### March 22, 2014

#!/usr/bin/perl
use strict;
use warnings;
use Carp;

my $readable = $ARGV[0];
my $runable = $ARGV[1];

(open READABLE, "<$readable") or croak "Failed to open readable: $!";
(open RUNABLE, ">$runable") or croak "Failed to open runable: $!";

while(<READABLE>)
{
	if($_ =~ /[a-b]/)
	{
		print RUNABLE $_;
	}else{
	}
}
