# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

###################################################################################################
use strict;

use File::Path qw(remove_tree);
use File::Compare;
use File::Basename;

use Test::More tests => 2;
use Test::Exception;
use Test::Deep;

use Shatterproof;

my $dir = dirname(__FILE__);

my $config_file_path = "$dir/test_config.pl";
my $output_directory = "$dir/output/";

$tp53_mutation_found = 0;

#populate 	input file arrays
my @trans_files;
$trans_files[0] = "$dir/spt/testing_trans_1.spt";
$trans_files[1] = "$dir/spt/testing_trans_2.spt";

my @cnv_files;
$cnv_files[0] = "$dir/spc/testing_cnv_1.spc";
$cnv_files[1] = "$dir/spc/testing_cnv_2.spc";


#create output directory
mkdir ("$output_directory",0770) unless (-d "$output_directory");

##### Test loading config file ################################################
ok(Shatterproof::load_config_file($config_file_path),'load_config_file');
###############################################################################

#run analyze cnv
($genome_cnv_data_hash_ref, $chromosome_copy_number_count_hash_ref, $chromosome_cnv_breakpoints_hash_ref) = Shatterproof::analyze_cnv_data($output_directory, \@cnv_files, $bin_size, \$tp53_mutation_found);

#run analyze trans
($genome_trans_data_hash_ref, $chromosome_translocation_count_hash_ref, $genome_trans_breakpoints_hash_ref) = Shatterproof::analyze_trans_data($output_directory, \@trans_files, $bin_size, \$tp53_mutation_found);


$genome_mutation_density_hash_ref = Shatterproof::calculate_genome_localization($output_directory, $chromosome_copy_number_count_hash_ref, $chromosome_translocation_count_hash_ref);


($suspect_regions_array_ref, $likely_regions_array_ref, $genome_cnv_data_windows_hash_ref, $genome_trans_data_windows_hash_ref, $genome_mutation_data_windows_hash_ref) = Shatterproof::calculate_chromosome_localization($output_directory, $genome_cnv_data_hash_ref, $genome_trans_data_hash_ref, $bin_size, $localization_window_size);

##### test analyze_likely_regions ######################################
Shatterproof::analyze_likely_regions($output_directory, $likely_regions_array_ref, $genome_mutation_density_hash_ref, $genome_cnv_data_hash_ref, $genome_trans_data_hash_ref, $bin_size, $localization_window_size);

#check output file
my $test_file;
my $ref_file;
open ($test_file, "$dir/output/suspect_regions/likely_regions.log");
open ($ref_file, "$dir/ref/likely_regions.log.ref");
ok(compare($test_file, $ref_file)==0, 'analyze_likely_regions-1');
close($test_file);
close($ref_file);
###############################################################################

#delete output directory
remove_tree("$dir/output");
