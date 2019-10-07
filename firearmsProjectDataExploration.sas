/* ST662 Project

   DATA EXPLORATION

   Paula McMahon, 17185602 */


/* This file shows some of the data exploration undertaken in the early part
of the project. 

Read the dataset into SAS */
proc import out=ST662.firearm1
		datafile = "/folders/myfolders/ST662/nics-firearm-background-checks.csv"
		dbms = csv replace;
	getnames = yes;
	datarow = 2;
run;

/* Screen data for missing values */
proc univariate data=ST662.firearm1 plots;
	var month permit permit_recheck handgun long_gun other multiple admin prepawn_handgun 
prepawn_long_gun prepawn_other redemption_handgun redemption_long_gun redemption_other 
returned_handgun returned_long_gun returned_other rentals_handgun rentals_long_gun 
private_sale_handgun private_sale_long_gun private_sale_other return_to_seller_handgun 
return_to_seller_long_gun return_to_seller_other totals;
run;
/* Essentially this output will show that we have missing values for variables ranging
from 0% (totals), 0.15% (long_gun), 0.16% (handgun), 0.18% (permit), 0% (multiple)
up to the highest values like 89.22% (permit_recheck), 91.38% (rentals_long_gun) */


/* This section of code is checking if all of the numeric values per row
add up to the number in the totals column */
data ST662.firearm2;
	set ST662.firearm1;
	sum_totals = sum(of _numeric_)-month -totals;
	if (sum_totals eq totals) then equal=1; else equal=0;
run;
proc freq data=ST662.firearm2;
	tables equal / nocum nopercent ;
run;

/* Reduce the dataset for now i.e. remove some of the columns we are not concerned with analysing */
data ST662.firearm3;
	set ST662.firearm2;
	drop permit permit_recheck handgun long_gun other multiple admin prepawn_handgun prepawn_long_gun 
	prepawn_other redemption_handgun redemption_long_gun redemption_other returned_handgun 
	returned_long_gun returned_other rentals_handgun rentals_long_gun private_sale_handgun 
	private_sale_long_gun private_sale_other return_to_seller_handgun return_to_seller_long_gun 
	return_to_seller_other; 
run;

/* This creates a table with the month column in a new format (date) */
proc sql;
	create table ST662.firearm4 as
	select *, Datepart(month) format=DDMMYY10. as date
	from ST662.firearm3;
	proc sgplot data=ST662.firearm4;
	series x=date y=totals /markers group=state;     
run;

/* Sort by state and month */
proc sort data=ST662.firearm4;
	by state date;
run;

/* This will superimpose all state graphs */
proc sgplot data=ST662.firearm4;
	xaxis type=time;
	series x=date y=totals / group=state ;
run;

/* Reducing the dataset in order to the plot the more interesting state trends */
data ST662.firearm5;
	set ST662.firearm4;
	where (state='California'or state='Indiana' or
	       state='Kentucky' or state='North Carolina' or
	       state='Texas' or state='Utah');
run;

/* This will superimpose all remaining state graphs */
proc sgplot data=ST662.firearm5;
	xaxis type=time;
	series x=date y=totals / group=state;
run;


/* Go back to first dataset. Essentially we want to show what each row contributes to the
"totals" column. This will help us to focus our analysis on the columns that contribute
the most. To do this, add up all of the categories for prepawn, redemption, returned, 
rentals, private, return_to_seller. Do this only for rows that are complete.
Set complete1 to 1 for rows that are complete */
data ST662.firearm1;
	set ST662.firearm1;
	if cmiss(of _all_) then complete1=0; else complete1=1;
run;

/* Combine the categories */
data ST662.firearm6;
	set ST662.firearm1;
	if complete1=1 then
	do;
	permit_combined        = permit + permit_recheck;
	prepawn_combined       = prepawn_handgun + prepawn_long_gun + prepawn_other;
	redemption_combined    = redemption_handgun + redemption_long_gun + redemption_other;
	returned_combined      = returned_handgun + returned_long_gun + returned_other;
	rentals_combined       = rentals_handgun + rentals_long_gun;
	private_combined       = private_sale_handgun + private_sale_long_gun + private_sale_other;
	return_seller_combined = return_to_seller_handgun + return_to_seller_long_gun + return_to_seller_other;
	end;
run;

/*
proc print data=ST662.firearm6;
	var month state permit_combined handgun long_gun other multiple admin prepawn_combined redemption_combined 
	returned_combined rentals_combined private_combined return_seller_combined totals;
run;
*/

/* Calculate percentage values for complete rows only */
data ST662.firearm6;
	set ST662.firearm6;
	if complete1=1 then
	do;
	permit_pct        = permit_combined/totals * 100;
	handgun_pct       = handgun/totals * 100;
	long_gun_pct      = long_gun/totals * 100;
	other_pct         = other/totals * 100;
	multiple_pct      = multiple/totals * 100;
	admin_pct         = admin/totals * 100;
	prepawn_pct       = prepawn_combined/totals * 100;
	redemption_pct    = redemption_combined/totals * 100;
	returned_pct      = returned_combined/totals * 100;
	rentals_pct       = rentals_combined/totals * 100;
	private_pct       = private_combined/totals * 100;
	return_seller_pct = return_seller_combined/totals * 100;
	end;
run;

/* Print out this new table */
/*
proc print data=ST662.firearm6;
	var state permit_pct handgun_pct long_gun_pct other_pct multiple_pct admin_pct prepawn_pct 
	redemption_pct returned_pct rentals_pct private_pct return_seller_pct;
run;
*/

/* sort by the state variable */
proc sort data=ST662.firearm6;
	by state;
run;

/* Calculate the mean of each "percentage contrib to totals" column */
proc means data=ST662.firearm6 mean;
	by state;
	var permit_pct handgun_pct long_gun_pct other_pct multiple_pct admin_pct prepawn_pct 
	redemption_pct returned_pct rentals_pct private_pct return_seller_pct;
	output out=ST662.firearm7 mean(permit_pct)=permit_pct_mean mean(handgun_pct)=handgun_pct_mean
	mean(long_gun_pct)=long_gun_pct_mean mean(other_pct)=other_pct_mean
	mean(multiple_pct)=multiple_pct_mean mean(admin_pct)=admin_pct_mean
	mean(prepawn_pct)=prepawn_pct_mean mean(redemption_pct)=redemption_pct_mean
	mean(returned_pct)=returned_pct_mean mean(rentals_pct)=rentals_pct_mean
	mean(private_pct)=private_pct_mean mean(return_seller_pct)=return_seller_pct_mean;
run;

/* Output the table of the means */
proc print data=ST662.firearm7;
	var state permit_pct_mean handgun_pct_mean long_gun_pct_mean other_pct_mean multiple_pct_mean 
	admin_pct_mean prepawn_pct_mean redemption_pct_mean returned_pct_mean rentals_pct_mean 
	private_pct_mean return_seller_pct_mean;
run;