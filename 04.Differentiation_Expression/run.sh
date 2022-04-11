#!/bin/bash
./PtR -m Trinity_trans_PH.gene.counts.matrix -s sample3.txt --order_columns_by_samples_file --log2 --sample_cor_matrix 
run_DE_analysis.pl --matrix Trinity_trans_PH.gene.counts.matrix --samples_file sample3.txt --method edgeR --output edgeR_trans_PH_gene 
cd edgeR_trans_PH_gene
analyze_diff_expr.pl --matrix ../Trinity_trans_PH.gene.TMM.EXPR.matrix --samples ../sample3.txt -P 1e-3 -C 2 --max_genes_clust 20000 --order_columns_by_samples_file
 ../PtR -m diffExpr.P1e-3_C2.matrix.log2.centered.dat -s ../sample3.txt --gene_dist euclidean --sample_dist euclidean --heatmap --order_columns_by_samples_file --heatmap_scale_limits "-4,4" 
define_clusters_by_cutting_tree.pl --Ptree 60 -R diffExpr.P1e-3_C2.matrix.RData --no_column_reordering
cd ../
 ./PtR -m Trinity_trans_PH.isoform.counts.matrix -s sample3.txt --order_columns_by_samples_file --log2 --sample_cor_matrix 
 run_DE_analysis.pl --matrix Trinity_trans_PH.isoform.counts.matrix --samples_file sample3.txt --method edgeR --output edgeR_trans_PH_isoform 
cd edgeR_trans_PH_isoform
 analyze_diff_expr.pl --matrix ../Trinity_trans_PH.isoform.TMM.EXPR.matrix --samples ../sample3.txt -P 1e-3 -C 2 --max_genes_clust 20000 --order_columns_by_samples_file
 ../PtR -m diffExpr.P1e-3_C2.matrix.log2.centered.dat -s ../sample3.txt --gene_dist euclidean --sample_dist euclidean --heatmap --order_columns_by_samples_file --heatmap_scale_limits "-4,4" 
define_clusters_by_cutting_tree.pl --Ptree 60 -R diffExpr.P1e-3_C2.matrix.RData --no_column_reordering
cd ../
