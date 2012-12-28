#!/usr/local/bin/perl
### shatterproof.pl ###############################################################################
#
 
### HISTORY #######################################################################################
# Version       Date            Coder   	Comments
# 1.0           2012/03/19      sgovind      	Versioning start point
# 1.1		2012/04/03	sgovind		moved code into shatterproof.pm

### INCLUDES ######################################################################################
use warnings;
use strict;

#push (@INC, '/u/sgovind/BoutrosLab/Algorithm Development/ChromothripsisDetector/trunk/Shatterproof-0.001/lib');
#require '/u/sgovind/BoutrosLab/Algorithm Development/ChromothripsisDetector/trunk/Shatterproof-0.001/lib';

use Shatterproof;

### MAIN PROGRAM ##################################################################################
Shatterproof::run(\@ARGV);