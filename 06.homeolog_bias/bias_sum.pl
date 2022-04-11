#!/usr/bin/perl -w
use strict;
use warnings;

die "USAGE:\n $0 <gene_expression> <Length file> <Homolog_expression file> <summary file>" unless (@ARGV==4);
open (EXP, "<$ARGV[0]")||die "$!";
open (LEN,"<$ARGV[1]")||die "$!";
open (HOM,"<$ARGV[2]")||die "$!";
open (OUT, ">$ARGV[3]")||die "$!";

my %isoform;
while(<EXP>){
      chomp $_;
my @items=split/\t/,$_;
my $name=shift @items;
my $items=join "\t",@items;
   $isoform{$name}=$items;
   @items=();
 }
 close EXP;

my %len;
while(<LEN>){
	chomp $_;
my ($gene,$len)=split/\t/,$_;
   $len{$gene}=$len;
}
close LEN;

my @items;
my $i=1;
while(<HOM>){
chomp $_;
	my ($spt,$spc)=split/\t/,$_;
         print OUT "$spt\t$spc\t$isoform{$spt}\t$isoform{$spc}\t$len{$spt}\t$len{$spc}\n";
 }
   close HOM;
   close OUT;

   #sub log2 {
   #my $n = shift;
   #return log($n)/log(2);
   #}

