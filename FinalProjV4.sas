/* Generated Code (IMPORT) */
/* Source File: cirrhosisCLEANED.csv */
/* Source Path: /home/u59237268/Survival_Analysis */
/* Code generated on: 5/4/23, 9:26 PM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u59237268/Survival_Analysis/cirrhosisCLEANED.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

data WORK.IMPORT_yrs;
	set WORK.IMPORT;
	yrs = (age)/365;
run;

proc lifereg data=WORK.IMPORT plots=probplot;
model age*event(0)= alb alkphos ascitesyes bili chol cu hepmegyes plat ptt rxD_penicillamine
      sgot spidersyes stage trig EDORERD EEANDNTE EEDT / dist=weibull ;
run;


proc phreg data=WORK.IMPORT_yrs plots(overlay)=survival ;
		model yrs*event(0)= alb alkphos ascitesyes bili chol cu hepmegyes plat ptt rxD_penicillamine
      sexmale sgot spidersyes stage trig EDORERD EEANDNTE EEDT / selection=stepwise;
run;

proc phreg data=WORK.IMPORT_yrs plots(overlay)=survival;
  model yrs*event(0)= alb alkphos ascitesyes bili chol cu hepmegyes plat ptt rxD_penicillamine
        sexmale sgot spidersyes stage trig EDORERD EEANDNTE EEDT / selection=stepwise;
  output out=Outp xbeta = Xb resmart = Mart resdev = Dev;
  ASSESS PH / RESAMPLE;
  Baseline Out = Base Lower = lcl Upper = ucl;
run;


title "Cirrhosis Stuydy";

proc sgplot data=Outp;
  yaxis grid label="Martingale Residuals";
  xaxis label="Linear Predictor";
  refline 0 / axis=y;
  scatter y=Mart x=Xb / markerattrs=(symbol=circlefilled size=6);
  LOESS x=Xb y=Mart / lineattrs=(color=red thickness=5);
run;

title "Cirrhosis Study";

proc sgplot data=Outp;
  yaxis grid label="Martingale Residuals";
  xaxis label="Copper (CU)";
  refline 0 / axis=y;
  scatter y=Mart x=cu / markerattrs=(symbol=circlefilled size=6);
  LOESS x=cu y=Mart / lineattrs=(color=red thickness=5);
run;

%macro plot_residuals(covariate);
    title "Cirrhosis Study - &covariate";
    proc sgplot data=Outp;
        yaxis grid label="Deviance Residuals";
        xaxis label="&covariate";
        refline 0 / axis=y;
        scatter y=Dev x=&covariate / markerattrs=(symbol=circlefilled size=6);
        LOESS x=&covariate y=Dev / lineattrs=(color=red thickness=5);
    run;
%mend;

%plot_residuals(alb);
%plot_residuals(alkphos);
%plot_residuals(ascitesyes);
%plot_residuals(bili);
%plot_residuals(chol);
%plot_residuals(cu);
%plot_residuals(hepmegyes);
%plot_residuals(plat);
%plot_residuals(ptt);
%plot_residuals(RxD_penicillamine);
%plot_residuals(sexmale);
%plot_residuals(sgot);
%plot_residuals(spidersyes);
%plot_residuals(stage);
%plot_residuals(trig);
%plot_residuals(EDORERD);
%plot_residuals(EEANDNTE);

