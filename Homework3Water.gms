$ontext
CEE 6410 - Water Resources Systems Analysis
Example 2.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)
Modifies Example to add a labor constraint

THE PROBLEM:

An aqueduct has excess capacity to supply water to industrial users in the summer months. Available water is:

June: 14,000 acre-feet (acft)

July: 18,000 acft

August: 6,000 acft

A maximum of 10,000 acres of new land can be developed for irrigation. Two crops, hay and grain, are to be grown.
Each crop requires monthly water deliveries (acft/acre) and provides a net return ($/acre) as follows:

Crop    June water (acft/acre)  July water (acft/acre)  August water (acft/acre)    Net return ($/acre)
Hay         2                           1                       1                           100
Grain       1                           2                       0                           120

Objective: determine the optimal acreage of hay and grain to maximize total net return,subject to water availability
constraints and the land limit.
$offtext

* 1. DEFINE the SETS
SETS crop crops growing /Hay, Grain/
     res resources /Land, June, July, August/;

* 2. DEFINE input data
PARAMETERS
   c(crop) Objective function coefficients ($ per plant)
         /Hay 100,
         Grain 120/
   b(res) Right hand constraint values (per resource)
          /Land 10000
          June 14000,
           July  18000,
           August  6000/;

TABLE A(crop,res) Left hand side constraint coefficients
                 Land   June    July   August
 Hay               1      2      1       1
 Grain             1      1      2       0;


* 3. DEFINE the variables
VARIABLES X(crop) crops watered (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(res) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(crop, c(crop)*X(crop));
RES_CONSTRAIN(res) ..    SUM(crop, A(crop,res)*X(crop)) =L= b(res);


* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;


* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANTING USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
