#!/usr/bin/perl -w
use strict;
use warnings;
use Statistics::PointEstimation;
use Statistics::TTest;
die "USEAGE:\n $0 <IN> <sumary> <add_file> <eld_spc> <eld_spt> <transgressive_down> <transgressive_up> <no change>" unless (@ARGV==8);
open (IN, "<$ARGV[0]")||die "$!";
open (SUM, ">$ARGV[1]")||die "$!";
open (ADD, ">$ARGV[2]")||die "$!";
open (EDL1, ">$ARGV[3]")||die "$!";
open (EDL2,">$ARGV[4]")||die "$!";
open (TGD,">$ARGV[5]")||die "$!";
open (TGU,">$ARGV[6]")||die "$!";
open (NG, ">$ARGV[7]")||die "$!";
#SPT_id SPC_id HY1 HY2 Spt1 Spt2 Spc1 Spc2
my $p1=0;my $p2=0;my $p3=0; my $p4=0; my $p5=0; my $p6 = 0; my $p7=0; my $p8=0; my $p9=0; my $p10=0;my $p11=0;my $p12=0;my $p13=0;
while(<IN>){
	chomp $_;
        my @line=split/\t/,$_;
	my @hy=@line[2..4];
	my $hy_mean=($hy[0]+$hy[1]+$hy[2])/3;
	my @spt=@line[5..6];
	my $spt_mean=($spt[0]+$spt[1])/2;
	my @spc=@line[7..8];
	my $spc_mean=($spc[0]+$spc[1])/2;
        my $ttest1 = new Statistics::TTest;
        my $ttest2 = new Statistics::TTest;
        my $ttest3 = new Statistics::TTest;
           $ttest1->set_significance(95);
           $ttest2->set_significance(95);
           $ttest3->set_significance(95);
           $ttest1->load_data(\@hy,\@spt);
           $ttest2->load_data(\@hy,\@spc);
           $ttest3->load_data(\@spt,\@spc);
	my $res1 = "$ttest1->{null_hypothesis}";
        my $res2 = "$ttest2->{null_hypothesis}";
	my $res3 = "$ttest3->{null_hypothesis}";
	    if($res1 eq "rejected" && $res2 eq "rejected" && $res3 eq "rejected" && $spt_mean < $hy_mean && $hy_mean < $spc_mean){
		   $p1++;
                   print ADD "$line[0]\t$line[1]\n";
	    }
	    elsif($res1 eq "rejected" && $res2 eq "rejected" && $res3 eq "rejected" && $spt_mean > $hy_mean && $hy_mean > $spc_mean){
		    $p12++;
                    print ADD "$line[0]\t$line[1]\n";
            }
	    elsif($res1 eq "rejected" && $res2 eq "not rejected" && $res3 eq "rejected" && $spt_mean < $hy_mean){
		    $p2++;
                    print EDL1 ">$line[0]\t$line[1]\n";
	    }
	    elsif($res1 eq "rejected" && $res2 eq "not rejected" && $res3 eq "rejected" && $spt_mean > $hy_mean){
		    $p11++;
                    print EDL1 ">$line[0]\t$line[1]\n";
	    }
	    elsif($res1 eq "not rejected" && $res2 eq "rejected" && $res3 eq "rejected" && $spt_mean > $spc_mean){
		    $p4++;
                    print EDL2">$line[0]\t$line[1]\n";
            }
	    elsif($res1 eq "not rejected" && $res2 eq "rejected" && $res3 eq "rejected" && $spt_mean < $spc_mean){
		    $p9++;
                    print EDL2 ">$line[0]\t$line[1]\n";
	    }
	    elsif($res1 eq "rejected" && $res2 eq  "rejected" && $res3 eq "rejected" &&  $spt_mean >$hy_mean && $spc_mean > $spt_mean && $spc_mean > $hy_mean){
		    $p3++;
                    print TGD ">$line[0]\t$line[1]\n";
	    }
	    elsif($res1 eq "rejected" && $res2 eq  "rejected" && $res3 eq "not rejected"  &&  $spt_mean >$hy_mean && $spc_mean > $hy_mean){
		    $p7++;
                    print TGD ">$line[0]\t$line[1]\n";
	    }
	    elsif($res1 eq "rejected" && $res2 eq  "rejected" && $res3 eq "rejected"  &&  $spt_mean >  $hy_mean && $spc_mean > $hy_mean && $spt_mean > $spc_mean){
		    $p10++;
                    print TGD ">$line[0]\t$line[1]\n";
	    }
	    elsif($res1 eq "rejected" && $res2 eq  "rejected" && $res3 eq "rejected"  &&  $spt_mean  < $hy_mean && $spc_mean <  $hy_mean && $spt_mean < $spc_mean){
		    $p5++;
                    print TGU ">$line[0]\t$line[1]\n";
	    }
	    elsif($res1 eq "rejected" && $res2 eq  "rejected" && $res3 eq "rejected"  &&  $spt_mean  < $hy_mean && $spc_mean <  $hy_mean && $spt_mean > $spc_mean){
		    $p6++;
                    print TGU ">$line[0]\t$line[1]\n";
	    }

	    elsif($res1 eq "rejected" && $res2 eq  "rejected" && $res3 eq "not rejected"  &&  $spt_mean  < $hy_mean && $spc_mean <  $hy_mean){
		    $p8++;
                    print TGU ">$line[0]\t$line[1]\n";
	    }
	    elsif($res1 eq "not rejected" && $res2 eq  "not rejected" && $res3 eq "not rejected"){
		    $p13++;
                     print NG ">$line[0]\t$line[1]\n";
	   }

	   @line=();
	   @hy=();
	   @spt=();
	   @spc=();
}
close IN;
print SUM "Additivity: $p1\t$p12\nSpc-expression domiance: $p2\t$p11\nSpt-expression dominance: $p4\t$p9\nTransgressive downregulation:$p3\t$p7\t$p10\nTransgressive upregulation:$p5\t$p6\t$p8\nnot changed:$p13\n";
close SUM;
close ADD;
close EDL1;
close EDL2;
close TGD;
close TGU;
close NG;

