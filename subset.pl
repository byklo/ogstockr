#!/usr/bin/perl
use strict;
use warnings;
use Carp;

my $wallet = 23;

my $readable = $ARGV[0];
my $runable = $ARGV[1];

(open READABLE, "<$readable") or croak "Failed to open readable: $!";
(open RUNABLE, ">$runable") or croak "Failed to open runable: $!";

while(<READABLE>)
{
	if($_ =~ /[a-b]/)
	{
		my @check = split(' ', $_);
		if($check[5] < $wallet)
		{
			print RUNABLE $_;
		}else{}
	}
}
