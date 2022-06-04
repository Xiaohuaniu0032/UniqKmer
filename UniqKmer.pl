use strict;
use warnings;
use Data::Dumper;

my ($infile,$kmer,$outdir) = @ARGV;


# check header uniqness
print "Step1: check header uniqness\n";
my %header;
open IN, "$infile" or die;
while (<IN>){
	chomp;
	if (/^>/){
		$header{$_} += 1;
	}
}
close IN;

my $uniq_flag = 0;
foreach my $h (keys %header){
	my $v = $header{$h};
	if ($v > 1){
		$uniq_flag = 1;
		last;
	}
}

if ($uniq_flag == 1){
	die "$infile fasta file has Dup headers\n";
}else{
	print "Step1: uniq header check PASS\n";
}


# read ref fasta
my %fa;
my $header;

open IN, "$infile" or die;
while (<IN>){
	chomp;
	next if (/^$/);
	if (/^\>/){
		# header
		$header = $_;
	}else{
		push @{$fa{$header}}, $_;
	}
}
close IN;

#print(Dumper(\%fa));


# get all kmer
my $new_fa = "$outdir/processed.fa";
my %new_fa;
open O, ">$new_fa" or die;
foreach my $ref (keys %fa){
	my @seq = @{$fa{$ref}};
	my $seq = join("", @seq);
	print O "$ref\n$seq\n";
	$new_fa{$ref} = $seq;
}
close O;

# get all kmer
my %kmer;
foreach my $ref (keys %new_fa){
	my $seq = $new_fa{$ref};
	#print "$seq\n";
	my $len = length($seq);
	my $last_idx = $len - $kmer + 1; # 1-based
	my $last_idx_zero_based = $last_idx - 1;
	for my $i (0..$last_idx_zero_based){
		#print "$i\n";
		my $sub_seq = substr($seq,$i,$kmer);
		#print "$sub_seq\n";
		$kmer{$sub_seq} += 1;
	}
}

# ouput each genome's uniq kmer info

my $uniq_file = "$outdir/uniqness\.$kmer\.txt";
open OMER, ">$uniq_file" or die;
print OMER "ref\tpos\tseq\ttimes\tflag\n";

my %uniq_count;
my %ununiq_count;
foreach my $ref (keys %new_fa){
	my $seq = $new_fa{$ref};
	my $len = length($seq);
	my $last_idx = $len - $kmer + 1; # 1-based
	my $last_idx_zero_based = $last_idx - 1;
	for my $i (0..$last_idx_zero_based){
		my $sub_seq = substr($seq,$i,$kmer);
		my $times = $kmer{$sub_seq};
		if ($times == 1){
			# uniq
			print OMER "$ref\t$i\t$sub_seq\t$times\tUNIQ\n";
			$uniq_count{$ref} += 1;
		}else{
			print OMER "$ref\t$i\t$sub_seq\t$times\tNot-UNIQ\n";
			$ununiq_count{$ref} += 1;
		}
	}
}
close OMER;

my $kmer_stat = "$outdir/kmer_stat.txt";
open STAT, ">$kmer_stat" or die;
print STAT "ref\tUNIQ_count\tunUNIQ_count\n";
foreach my $ref (keys %uniq_count){
	my $count = $uniq_count{$ref};
	my $not_count = $ununiq_count{$ref};
	print STAT "$ref\t$count\t$not_count\n";
}
close STAT;

print "\n";
print "Output files:\n\t1)processed.fa\n\t2)uniqness.25.txt\n\t3)kmer_stat.txt\n";


