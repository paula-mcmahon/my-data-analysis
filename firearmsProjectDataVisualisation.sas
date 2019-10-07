/* ST662 Project

   DATA VISUALISATION
   
   Paula McMahon, 17185602 */

/* Read the dataset into SAS */

proc import out=ST662.firearm1a
		datafile = "/folders/myfolders/ST662/nics-firearm-background-checks.csv"
		dbms = csv replace;
	getnames = yes;
run;

/* Reduce the dataset for now. Only leave permit, handgun, long_gun, multiple, totals */
data ST662.firearm2a;
	set ST662.firearm1a;
	drop permit_recheck other admin prepawn_handgun prepawn_long_gun prepawn_other redemption_handgun 
	redemption_long_gun redemption_other returned_handgun returned_long_gun returned_other 
	rentals_handgun rentals_long_gun private_sale_handgun private_sale_long_gun private_sale_other 
	return_to_seller_handgun return_to_seller_long_gun return_to_seller_other TotalDiff TotalPercentageDiff; 
run;

/* This code produces a panel for each state, plotting date vs totals per state */
proc sgpanel data=ST662.firearm2a;
	panelby state;
    series x=month y=totals;
run;

proc sql;
	create table ST662.firearm3a as
	select *, Datepart(month) format=DDMMYY10. as date
	from ST662.firearm2a;
	proc sgplot data=ST662.firearm3a;
	series x=date y=totals /markers group=state;     
run;


/* Plotting the more interesting state trends. Plotting twice 
so as not to overload the graphs */
ods graphics / reset;
ods listing close;
ods listing gpath = '/folders/myfolders/' image_dpi=200;
ods graphics on / reset=all noborder width=8in height=7in imagename="state_trend1";
proc sgplot data=ST662.firearm3a(where=(state='California' or state='Indiana' or
	       state='Kentucky'));
	title h=14pt "States with the most interesting trends over time";
	xaxis type=time;
	series x=date y=totals / group=state lineattrs=(thickness=2);
run;
ods listing close; 

/* 2nd plot */
ods graphics / reset;
ods listing close;
ods listing gpath = '/folders/myfolders/' image_dpi=200;
ods graphics on / reset=all noborder width=8in height=7in imagename="state_trend2";
proc sgplot data=ST662.firearm3a(where=(state='North Carolina' or state='Texas'));
	title h=14pt "States with the most interesting trends over time";
	xaxis type=time;
	series x=date y=totals / group=state lineattrs=(thickness=2);
run;
ods listing close;

/* 2a plot */
ods graphics / reset;
ods listing close;
ods listing gpath = '/folders/myfolders/' image_dpi=200;
ods graphics on / reset=all noborder width=8in height=7in imagename="state_trend2a";
proc sgplot data=ST662.firearm3a(where=(state='North Carolina' or state='California' or state='Kentucky'));
	title h=14pt "States with the most interesting trends over time";
	xaxis type=time;
	series x=date y=totals / group=state lineattrs=(thickness=2);
run;
ods listing close;

/* 3rd plot to show spikes in response to mass shootings? */
ods graphics / reset;
ods listing close;
ods listing gpath = '/folders/myfolders/' image_dpi=200;
ods graphics on / reset=all noborder width=8in height=7in imagename="state_trend3";
proc sgplot data=ST662.firearm3a(where=(state='Connecticut' or state='Florida'));
	title h=14pt "Spikes in trend due to mass shootings?";
	xaxis type=time;
	series x=date y=totals / group=state lineattrs=(thickness=2);
run;
ods listing close;

/* 4th plot to show the erratic trends of the smaller states */
ods graphics / reset;
ods listing close;
ods listing gpath = '/folders/myfolders/' image_dpi=200;
ods graphics on / reset=all noborder width=8in height=7in imagename="state_trend4";
proc sgplot data=ST662.firearm3a(where=(state='Mariana Islands' or state='Guam' 
or state='Virgin Islands' or state='District of Columbia'));
	title h=14pt "States with the most interesting trends over time";
	xaxis type=time;
	series x=date y=totals / group=state lineattrs=(thickness=2);
run;
ods listing close;


/* Sort by the state variable and sum the figures in each of the 5 columns.
This will give a permit total per state, handgun total per state etc.
Later, we will plot the states with the highest totals of permit, handgun, long_gun etc. */
proc sort data=ST662.firearm3a;
	by state;
run;
proc means data=ST662.firearm3a sum;
	by state;
	var permit handgun long_gun multiple totals;
	output out=ST662.firearm4a sum(permit)=permit_by_state
	                           sum(handgun)=handgun_by_state
	                           sum(long_gun)=long_gun_by_state
	                           sum(multiple)=multiple_by_state
	                           sum(totals)=totals_by_state;
run;
proc sort data=ST662.firearm4a;
	by state;
run;

/* Show the table with these figures */
proc print data=ST662.firearm4a;
	var state permit_by_state handgun_by_state long_gun_by_state multiple_by_state totals_by_state;
run;


/* PERMIT PLOT - sort by the permit total variable and print a PNG file */
proc sort data=ST662.firearm4a;
	by permit_by_state;
run;
ods graphics / reset;
ods listing close;
ods listing gpath = '/folders/myfolders/' image_dpi=200;
ods graphics on / reset=all noborder width=8in height=7in imagename="permit_totals";
proc sgplot data=ST662.firearm4a(where=(state='Kentucky' or state='Illinois'
	or state='California' or state='North Carolina' or state='Michigan' or state='Indiana'));
	title h=14pt "Top 6 states for PERMIT checks (Nov 1998 - Feb 2018)";
	yaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="Number of permit background checks" 
	display=(noline noticks) grid;
	xaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="State" discreteorder=data;
 	vbar state / response=permit_by_state fillattrs=(color=red) datalabel dataskin=gloss;
run;
ods listing close; 


/* HANDGUN PLOT - sort by the handgun total variable and print a PNG file */
proc sort data=ST662.firearm4a;
	by handgun_by_state;
run;
ods graphics / reset;
ods listing close;
ods listing gpath = '/folders/myfolders/' image_dpi=200;
ods graphics on / reset=all noborder width=8in height=7in imagename="handgun_totals";
proc sgplot data=ST662.firearm4a(where=(state='Texas' or state='Florida'
	or state='California' or state='Ohio' or state='Tennessee' or state='Virginia'));
	title h=14pt "Top 6 states for HANDGUN checks (Nov 1998 - Feb 2018)";
	yaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="Number of handgun background checks" 
	display=(noline noticks) grid;
	xaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="State" discreteorder=data;
 	vbar state / response=handgun_by_state fillattrs=(color=blue) datalabel dataskin=gloss;
run;
ods listing close;


/* LONG_GUN PLOT - sort by the long_gun total variable and print a PNG file */
proc sort data=ST662.firearm4a;
	by long_gun_by_state;
run;
ods graphics / reset;
ods listing close;
ods listing gpath = '/folders/myfolders/' image_dpi=200;
ods graphics on / reset=all noborder width=8in height=7in imagename="long_gun_totals";
proc sgplot data=ST662.firearm4a(where=(state='Pennsylvania' or state='Texas'
	or state='California' or state='Florida' or state='Ohio' or state='Missouri'));
	title h=14pt "Top 6 states for LONG GUN checks (Nov 1998 - Feb 2018)";
	yaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="Number of long gun background checks" 
	display=(noline noticks) grid;
	xaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="State" discreteorder=data;
 	vbar state / response=long_gun_by_state fillattrs=(color=green) datalabel dataskin=gloss;
run;
ods listing close;


/* MULPIPLE PLOT - sort by the multiple total variable and print a PNG file */
proc sort data=ST662.firearm4a;
	by multiple_by_state;
run;
ods graphics / reset;
ods listing close;
ods listing gpath = '/folders/myfolders/' image_dpi=200;
ods graphics on / reset=all noborder width=8in height=7in imagename="multiple_totals";
proc sgplot data=ST662.firearm4a(where=(state='Texas' or state='Colorado'
	or state='Florida' or state='California' or state='Ohio' or state='Oklahoma'));
	title h=14pt "Top 6 states for MULTIPLE checks (Nov 1998 - Feb 2018)";
	yaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="Number of multiple background checks" 
	display=(noline noticks) grid;
	xaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="State" discreteorder=data;
 	vbar state / response=multiple_by_state fillattrs=(color=yellow) datalabel dataskin=gloss;
run;
ods listing close;


/* TOTALS PLOT - sort by the totals variable and print a PNG file */
proc sort data=ST662.firearm4a;
	by totals_by_state;
run;
ods graphics / reset;
ods listing close;
ods listing gpath = '/folders/myfolders/' image_dpi=200;
ods graphics on / reset=all noborder width=8in height=7in imagename="all_totals";
proc sgplot data=ST662.firearm4a(where=(state='Kentucky' or state='Texas'
	or state='California' or state='Illinois' or state='Pennsylvania' or state='Florida'));
	title h=14pt "Top 6 states for TOTAL checks (Nov 1998 - Feb 2018)";
	yaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="Number of total background checks" 
	display=(noline noticks) grid;
	xaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="State" discreteorder=data;
 	vbar state / response=totals_by_state fillattrs=(color=purple) datalabel dataskin=gloss;
run;
ods listing close;


/* Reduce the dataset further - just to data from 1999 and 2017 */
data ST662.firearm4a;
	set ST662.firearm3a; 
	where (month >= '01JAN2017:00:00:00'dt and month <= '31DEC2017:00:00:00'dt) or 
	      (month >= '01JAN1999:00:00:00'dt and month <= '31DEC1999:00:00:00'dt);
run;

proc sort data=ST662.firearm4a;
	by month;
run;

/* Need to reformat the "month" column so we can extract the year we want */
data ST662.firearm5a;
	set ST662.firearm4a;
	newMonth = datepart(month);
	format newMonth date9.;
	Year = year(newMonth);
	Month1 = month(newMonth);
run;

proc sort data=ST662.firearm5a;
	by Month1 Year;
run;

/* sum by month and by year e.g. sum totals for Jan 1999, Jan 2017, Feb 1999, Feb 2017 etc. */
proc means data=ST662.firearm5a sum;
	by Month1 Year;
	var totals;
	output out=ST662.firearm6a sum(totals)=totalsPerYr;
run;

/* Print this new table */
proc print data=ST662.firearm6a;
	var Month1 Year totalsPerYr;
run;

/* 1999 vs 2017 PLOT - print a PNG file */
ods graphics / reset;
ods listing close;
ods listing gpath = '/folders/myfolders/' image_dpi=200;
ods graphics on / reset=all noborder width=8in height=7in imagename="1999_2017totals";
proc sgplot data=ST662.firearm6a;
	title h=13pt "Comparing monthly checks for the years 1999 vs 2017";
	yaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="Number of total background checks" 
	grid display=(noline);
	xaxis labelattrs=(size=14pt) valueattrs=(size=12pt) label="Month";
 	vbar Month1 / response=totalsPerYr group=Year dataskin=gloss;
run;
ods listing close;
