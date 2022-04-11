#!/usr/bin/perl -w
use strict;
use warnings;

die "USAGE:\n $0 <transcripts_count><transcript_lenth><orth_pairs><OUT>" unless (@ARGV==4);

open (COUNT, "<$ARGV[0]")||die "$!";
open (LEN,"<$ARGV[1]")||die "$!";
open (ORTH,"<$ARGV[2]") or die "$!";
open (OUT, ">$ARGV[3]")||die "$!";
###count file format####
#transcript_id T1_rep1 T1_rep2 T2_rep1 T2_rep2 T2_rep3 T3_rep1 T3_rep2 T3_rep3
###transcript length file
#Transcript_id 123
###ORTH id
#transcript1  transcript2

my %transcript;
while(<COUNT>){
	 chomp $_;
	 my @items=split/\t/,$_;
	 my $transcript=shift @items;
	 my $items=join "\t",@items;
	    $transcript{$transcript}=$items;
}
 close COUNT;

my %len;
while(<LEN>){
 chomp $_;
 my ($transcript,$len)=split/\t/,$_;
     $len{$transcript}=$len;
}

while(<ORTH>){
	chomp $_;
	 my ($spt,$spc)=split/\t/,$_;
	 my $meanRPKM_Spt1;my $meanRPKM_Spc1;my $spt_count;my $spc_count;
	 my @items1=split/\t/,$transcript{$spt};
	 my @items2=split/\t/,$transcript{$spc};
            if($ARGV[2]=~/T1/){
                    $meanRPKM_Spt1=($items1[0]/(12.76*$len{$spt}*0.001)+$items1[1]/(13.04*$len{$spt}*0.001))/2;
	            $meanRPKM_Spc1=($items2[0]/(12.76*$len{$spc}*0.001)+$items2[1]/(13.04*$len{$spc}*0.001))/2;
                    $spt_count=join "\t",@items1[0..1];
                    $spc_count=join "\t",@items2[0..1];
                   
             }
	     else{
                    if($ARGV[2]=~/T2/){
                             $meanRPKM_Spt1=($items1[2]/(10.98*$len{$spt}*0.001)+$items1[3]/(10.18*$len{$spt}*0.001)+ $items1[4]/(10.77*$len{$spt}*0.001))/3;
	                     $meanRPKM_Spc1=($items2[2]/(10.98*$len{$spc}*0.001)+$items2[3]/(10.18*$len{$spc}*0.001)+ $items2[4]/(10.77*$len{$spc}*0.001))/3;
                             $spt_count=join "\t",@items1[2..4];
                             $spc_count=join "\t",@items2[2..4];
                      }
                    if($ARGV[2]=~/T3/){
                             $meanRPKM_Spt1=($items1[5]/(16.45*$len{$spt}*0.001)+$items1[6]/(10.04*$len{$spt}*0.001)+ $items1[7]/(9.01*$len{$spt}*0.001))/3;
	                     $meanRPKM_Spc1=($items2[5]/(16.45*$len{$spc}*0.001)+$items2[6]/(10.04*$len{$spc}*0.001)+ $items2[7]/(9.01*$len{$spc}*0.001))/3;
                             $spt_count=join "\t",@items1[5..7];
                             $spc_count=join "\t",@items2[5..7];
                      }
              }
                           
	my $meanRPKM_Spt=sprintf "%.2f",$meanRPKM_Spt1;
        my $meanRPKM_Spc=sprintf "%.2f",$meanRPKM_Spc1;
        my $heb1=log2($meanRPKM_Spt1/$meanRPKM_Spc1);
        my $heb=sprintf "%.2f",$heb1; 	
           print OUT "$spt\t$spc\t$spt_count\t$spc_count\t$meanRPKM_Spt\t$meanRPKM_Spc\t$len{$spt}\t$len{$spc}\t$heb\n";
	    @items1=();
	    @items2=();
}

close ORTH;
close OUT;

   sub log2 {
   my $n = shift;
   return log($n)/log(2);
   }

