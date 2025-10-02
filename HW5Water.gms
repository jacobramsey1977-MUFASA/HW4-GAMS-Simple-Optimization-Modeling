$ontext
CEE 6410 - Water Resources Systems Analysis
Example 2.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)
Modifies Example to add a labor constraint

THE PROBLEM:

A reservoir is designed to provide water for hydropower and irrigation.
Water releases must also satisfy a minimum flow requirement in the river each month.

The reservoir has a capacity of 9 units.

Initial storage is 5 units, and ending storage must be at least 5 units.

Monthly inflows (units) are given as:

       Month   Inflow   
         1       2      
         2       1
         3       2      
         4       2
         5       3      
         6       2
 
Hydropower turbines can pass a maximum of 4 units per month.

At least 1 unit per month must flow to the river at point A (hydro + spill).

Any water not used for hydropower or irrigation is spilled.

       Month   Hydropower benefit   Irrigation benefit  
         1            1.6                   1.0
         2            1.7                   1.2
         3            1.8                   1.5 
         4            2.0                   2.0
         5            2.1                   2.2     
         6            2.0                   2.2
Objective: determine the optimal monthly allocations of water to hydropower, irrigation,
and spill, in order to maximize the total economic benefit, subject to reservoir storage
limits, turbine capacity, and minimum river flow requirements.

$offtext

* 1. DEFINE the SETS
SETS Spatial Points of interest in system /ReservoirStorage, Turbine, Spillway, FlowAtA, Irrigation/
     Month Time periods /Month1, Month2, Month3, Month4, Month5, Month6/;

* 2. DEFINE input data


PARAMETERS
   HydroBenefits(Month) Objective function coefficients
         /Month1 1.6,
         Month2 1.7,
         Month3 1.8,
         Month4 1.9,
         Month5 2.0,
         Month6 2.0/
   IrrigationBenefits(Month) Right hand constraint values 
        /Month1 1.0,
        Month2 1.2,
        Month3 1.9,
        Month4 2.0,
        Month5 2.2,
        Month6 2.2/
    ReservoirInflow(Month)
        /Month1 2,
        Month2 2,
        Month3 3,
        Month4 4,
        Month5 3,
        Month6 2/;
        
ALIAS(Month,NextMonth);

SET Next(Month,NextMonth)  "Defines consecutive months"
/Month1.Month2
 Month2.Month3
 Month3.Month4
 Month4.Month5
 Month5.Month6/;


* 3. DEFINE the variables
VARIABLES X(Spatial,Month) Decisions of volume per location per month (arbitary) except storage which is the volume
          VPROFIT  Objective function value of total profit ($)
          VStorage The final Reservoir Storage;

* Non-negativity constraints
POSITIVE VARIABLES X, VStorage;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   TURBINECAPACITY(Month) Upper limit of turbine releases
   MINFLOWATA(Month) Minimum flow at point A
   RESERVOIRMASSBALANCE(Month,NextMonth) Reservoir Mass Balance
   FINALSTORAGE Last Month of Storage
   RESERVOIRCAPACITY(Month) Max storage
   CHANGEINSTORAGE Change in storage must be equal to or greater than the starting storage
   INITIALSTORAGE Starting storage in reservoir
   MASSBALANCEATC(Month) Mass balance at junction C;

PROFIT..                 VPROFIT =E= SUM(Month, HydroBenefits(Month)*X("Turbine",Month)+IrrigationBenefits(Month)*X("Irrigation", Month));

TURBINECAPACITY(Month)..    X("Turbine", month) =L= 4;

MINFLOWATA(Month)..    X("FlowAtA",month) =G= 1;

RESERVOIRMASSBALANCE(Month,NextMonth)$(Next(Month,NextMonth)).. X("ReservoirStorage", Month) + ReservoirInflow(Month) - X("Turbine", Month) - X("Spillway", Month) =E= X("ReservoirStorage", NextMonth);

FINALSTORAGE..  X("ReservoirStorage", "Month6") + ReservoirInflow("Month6") - X("Turbine", "Month6") - X("Spillway", "Month6") =E= VStorage;

RESERVOIRCAPACITY(Month).. X("ReservoirStorage",Month) =L= 9;

CHANGEINSTORAGE.. X("ReservoirStorage","Month6") =G= 5;

INITIALSTORAGE.. X("ReservoirStorage", "Month1") =E= 5;

MASSBALANCEATC(Month).. X("Spillway", Month) + X("Turbine",Month) =G= X("FlowAtA", Month) + X("Irrigation", Month)

* 5. DEFINE the MODEL from the EQUATIONS
MODEL FlowManagement /ALL/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;


* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE FlowManagement USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
