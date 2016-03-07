// ==========================================================================

// SOC 4650/5650 - Lab 08

// ==========================================================================

// standard opening options

version 14
log close _all
graph drop _all
clear all
set more off
set linesize 80

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// change directory

if "`c(os)'" == "MacOSX" {
	cd "/Users/`c(username)'/Documents/Working"
}

else if "`c(os)'" == "Windows" {
	cd "C:\Users\`c(username)'\Documents\Working"	
}


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// log process

log using lab08.txt, text replace

// ==========================================================================

/* 
file name - lab08.do

project name - SOC 4650/5650 - Intro to GISc - Spring 2016
                                                                                 
purpose - replicate the Stata portion of lab 08
	                                                                               
created - 07 Mar 2016

updated - 07 Mar 2016
                                                                                
author - CHRIS
*/                                                                              

// ==========================================================================
                                                                                 
/* 
full description - 
This do-file replicates the Stata portion of Lab 08, which exports data
from Stata to Excel in preparation for mapping in ArcGIS.
*/

/* 
updates - 

*/

// ==========================================================================

/* 
superordinates  - 
This do-file requires that the dataset KCDumping.dta be downloaded from
Blackboard and present in your working directory.
*/

/* 
subordinates - 

*/

// ==========================================================================
// ==========================================================================
// ==========================================================================

// 1. open Kansas City 3-1-1 Data
use KCDumping.dta

// 2. export data
export excel kcdumping.xlsx, firstrow(variables) replace

// ==========================================================================
// ==========================================================================
// ==========================================================================

// standard closing options

log close _all
graph drop _all
set more on

// ==========================================================================

exit
