#### March 22, 2014

#!/usr/bin/perl
use strict;
use warnings;
use Carp;
use v5.10;

# CONFIG ##################################################################
my $CHECKLIST = !(defined $ARGV[0]) ? './checklist' : $ARGV[0];
my $URL = 'http://steamcommunity.com/market/search?q=appid%3A730+';
my $POP_THRESH = 1;
my $SCAM_THRESH = 1;
my $WAIT_TIME = 1;
my $MODE = 1;
my $WALLET = 100;
###########################################################################

(open CHECKLIST, "<$CHECKLIST") or croak "Failed to open checklist.\n";

while(<CHECKLIST>)
{
	my @string = split(/\s/, $_);
	my %item = (
		'class'		=>	$string[0],
		'gun'		=>	$string[1],
		'skin'		=>	$string[2],
		'stattrak'	=>	$string[3],
		'quality'	=>	$string[4],
		'sellprice'	=>	$string[5],
		'currentprice'	=>	''
	);

	# Gets current price ##############################################
	if($item{'stattrak'} eq 'no')
	{
		$item{'currentprice'} = `curl -s $URL.$item{'gun'}.'+'.$item{'skin'}.'+'.$item{'quality'} | grep USD | head -n 1 | sed "s/&#36;//g;s/\\s//g;s/<.*//g;s/USD//g";`
	}else{
		$item{'currentprice'} = ($item{'gun'} eq 'awp') ? `curl -s $URL.$item{'gun'}.'+'.$item{'skin'}.'+owner+stattrak+reward+'.$item{'quality'} | grep USD | head -n 1 | sed "s/&#36;//g;s/\\s//g;s/<.*//g;s/USD//g"` : `curl -s $URL.$item{'gun'}.'+'.$item{'skin'}.'+owner+stattrak+'.$item{'quality'} | grep USD | head -n 1 | sed "s/&#36;//g;s/\\s//g;s/<.*//g;s/USD//g"`;
	}
	###################################################################
	
	if($item{'currentprice'} eq '')
	{}elsif($item{'class'} eq 'pop')
	{
		my $baseline = ($item{'sellprice'}/1.15) - $POP_THRESH;
		if($item{'currentprice'} <= $baseline and $item{'currentprice'} <= $WALLET)
		{
			my $profit = $baseline + $POP_THRESH - $item{'currentprice'};
			$profit = sprintf("%.2f", $profit);
			say "##############################################################################";
			say "############################       D E A L       #############################";
			say "############################      F O U N D      #############################";
			say "##############################################################################";
			say "//////////////////////////////////////////////////////////////////////////////";
			print "CLASS: $item{'class'}\nGUN: $item{'gun'}\nSKIN: $item{'skin'}\nSTATTRAK: $item{'stattrak'}\nQUALITY: $item{'quality'}\nSELL: $item{'sellprice'}\nCURRENT: $item{'currentprice'}\nPROFIT: $profit\n";
			if($MODE == 0){}else{
				(open TEMP, '>.temp') or croak "Failed to open temp.\n";
				print TEMP "CLASS: $item{'class'}\nGUN: $item{'gun'}\nSKIN: $item{'skin'}\nSTATTRAK: $item{'stattrak'}\nQUALITY: $item{'quality'}\nSELL: $item{'sellprice'}\nCURRENT: $item{'currentprice'}\nPROFIT: $profit";
				system("mail -s 'steamdeals' NUMBER\@txt.bell.ca \< ./.temp");
			}
			print "Notified.\n";
		}
	}elsif($item{'class'} eq 'scam')
	{
		my $baseline = ($item{'sellprice'}/1.15) - $SCAM_THRESH;
		if($item{'currentprice'} <= $baseline and $item{'currentprice'} <= $WALLET)
		{
			my $profit = $baseline + $SCAM_THRESH - $item{'currentprice'};
			$profit = sprintf("%.2f", $profit);
			say "##############################################################################";
			say "############################       D E A L       #############################";
			say "############################      F O U N D      #############################";
			say "##############################################################################";
			say "//////////////////////////////////////////////////////////////////////////////";
			print "CLASS: $item{'class'}\nGUN: $item{'gun'}\nSKIN: $item{'skin'}\nSTATTRAK: $item{'stattrak'}\nQUALITY: $item{'quality'}\nSELL: $item{'sellprice'}\nCURRENT: $item{'currentprice'}\nPROFIT: $profit\n";
			if($MODE == 0){}else{
				(open TEMP, '>.temp') or croak "Failed to open temp.\n";
				print TEMP "CLASS: $item{'class'}\nGUN: $item{'gun'}\nSKIN: $item{'skin'}\nSTATTRAK: $item{'stattrak'}\nQUALITY: $item{'quality'}\nSELL: $item{'sellprice'}\nCURRENT: $item{'currentprice'}\nPROFIT: $profit";
				system("mail -s 'steamdeals' NUMBER\@txt.bell.ca \< ./.temp");
			}
			print "Notified.\n";
		}
	}
	print "Checked $item{'gun'} $item{'skin'} $item{'stattrak'} $item{'quality'}\n";
	sleep($WAIT_TIME);
}
