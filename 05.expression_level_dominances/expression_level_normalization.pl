#!/usr/bin/perl -w
use strict;
use warnings;

die "USAGE:\n $0 <Spt_transcripts_count><Spc_transcripts_count><HY_count><OUT>" unless (@ARGV==4);

open (SPT, "<$ARGV[0]")||die "$!";
open (SPC, "<$ARGV[1]")||die "$!";
open (HY,"<$ARGV[2]")|| die "$!";
open (OUT, ">$ARGV[3]")||die "$!";

my %spt;
while(<SPT>){
	 chomp $_;
	 my @items=split/\t/,$_;
	 my $transcript=shift @items;
	 my $items=join "\t",@items;
	    $spt{$transcript}=$items;
}
 close SPT;
my %spc;
while(<SPC>){
	 chomp $_;
	 my @items=split/\t/,$_;
	 my $transcript=shift @items;
	 my $items=join "\t",@items;
	    $spc{$transcript}=$items;
}
 close SPC;
#PH scaling factor 12.76274756	13.04156126	10.97573228	10.18388966	10.76793655	16.45419665	10.03957417	9.010368197
#SPT scaling factor 15.62485239	15.98495917	16.85078981	15.26085915	14.30421497	10.54854961
#SPC scaling factor 16.59906818	17.77369141	16.08473794	17.78215218	13.39084995	15.6694913

while(<HY>){
	chomp $_;
         my $line=$_;
	 my @line=split/\t/,$line;
	 my @items1=split/\t/,$spt{$line[0]};
	 my @items2=split/\t/,$spc{$line[1]};
         my $HY;
	 my $Spt1;my $Spt2;my $Spc1;my $Spc2;

            if($ARGV[2]=~/T1/){
                    my $hy1=$line[2]/(12.76*$line[6]*0.001) + $line[4]/(12.76*$line[7]*0.001);
	            my $HY1=sprintf "%.2f",$hy1;
                    my $hy2=$line[3]/(13.04*$line[6]*0.001) + $line[5]/(13.04*$line[7]*0.001);
	            my $HY2=sprintf "%.2f",$hy2;
                       $Spt1=$items1[0]/(15.62*$line[6]*0.001);
                       $Spt2=$items1[1]/(15.98*$line[6]*0.001);
                       $Spc1=$items2[0]/(16.60*$line[7]*0.001);
                       $Spc2=$items2[1]/(17.77*$line[7]*0.001);
                       $HY=join "\t",($HY1,$HY2);
             }
	     else{
                    if($ARGV[2]=~/T2/){
                          my  $hy1=($line[2]/(10.98*$line[8]*0.001)+$line[5]/(10.98*$line[9]*0.001));
			  my  $HY1=sprintf "%.2f",$hy1;
                          my  $hy2=($line[3]/(10.18*$line[8]*0.001)+$line[6]/(10.18*$line[9]*0.001));
			  my  $HY2=sprintf "%.2f",$hy2;
                          my  $hy3=($line[4]/(10.76*$line[8]*0.001)+$line[7]/(10.76*$line[9]*0.001));
			  my  $HY3=sprintf "%.2f",$hy3;
                              $Spt1=$items1[0]/(16.85*$line[8]*0.001);
                              $Spt2=$items1[1]/(15.26*$line[8]*0.001);
                              $Spc1=$items2[0]/(16.08*$line[9]*0.001);
                              $Spc2=$items2[1]/(17.78*$line[9]*0.001);
                              $HY=join "\t",($HY1,$HY2,$HY3);


                      }
                    if($ARGV[2]=~/T3/){
                          my  $hy1=($line[2]/(16.45*$line[8]*0.001)+$line[5]/(16.45*$line[9]*0.001));
			  my  $HY1=sprintf "%.2f",$hy1;
                          my  $hy2=($line[3]/(10.04*$line[8]*0.001)+$line[6]/(10.04*$line[9]*0.001));
			  my  $HY2=sprintf "%.2f",$hy2;
                          my  $hy3=($line[4]/(9.01*$line[8]*0.001)+$line[7]/(9.01*$line[9]*0.001));
			  my  $HY3=sprintf "%.2f",$hy3;
                              $Spt1=$items1[0]/(14.30*$line[8]*0.001);
                              $Spt2=$items1[1]/(10.55*$line[8]*0.001);
                              $Spc1=$items2[0]/(13.39*$line[9]*0.001);
                              $Spc2=$items2[1]/(15.67*$line[9]*0.001);
			      $HY=join "\t",($HY1,$HY2,$HY3);
                      } 
              }
        my $rpkm_spt1=sprintf "%.2f",$Spt1;
	my $rpkm_spt2=sprintf "%.2f",$Spt2;
	my $rpkm_spc1=sprintf "%.2f",$Spc1;
	my $rpkm_spc2=sprintf "%.2f",$Spc2;
	my $SPT=join "\t",($rpkm_spt1,$rpkm_spt2);
        my $SPC=join "\t",($rpkm_spc1,$rpkm_spc2);  
           print OUT "$line[0]\t$line[1]\t$HY\t$SPT\t$SPC\n";
	    @items1=();
	    @items2=();
            @line=();
}

close HY;
close OUT;

