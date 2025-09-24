$ontext
CEE 6410 - Water Resources Systems Analysis
Example 2.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)
Modifies Example to add a labor constraint

THE PROBLEM:

A factory builds two types of cars: Trucks and Sedans.
Each car consumes several components (resources). The data are:

Seasonal resource inputs or profit  Trucks (per car)    Sedans (per car)    Resource availability
Vehicles (units)                        1                   1                   10,000
Fuel tanks (units)                      2                   1                   14,000
Rows of seats (units)                   1                   2                   18,000
Four-wheel drive systems (units)        1                   0                   6,000
Profit per car ($)  100 110 

Determine the optimal production quantities of Trucks and Sedans to maximize total profit subject to the component availability constraints.


THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program
$offtext

* 1. DEFINE the SETS
SETS cars Cars built /Trucks, Sedans/
     mats Car Materials /Vehicles, Fuel_tanks, Rows_of_seats, Four-wheel_drive_systems/;

* 2. DEFINE input data
PARAMETERS
    d(cars) Objective function coefficients ($ per Car)
            /Trucks 100,
            Sedans 110/
    e(mats) Right hand constraint values (per reasource)
            /Vehicles 10000,
            Fuel_tanks 14000,
            Rows_of_seats 18000,
            Four-wheel_drive_systems 6000/;

TABLE B(cars, mats) Left hand side constraint coefficients
                 Vehicles    Fuel_tanks   Rows_of_seats     Four-wheel_drive_systems
 Trucks             1           2               1                       1
 Sedans             1           1               2                       0

* 3. DEFINE the variables
VARIABLES X(cars) Cars made (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   MATS_CONSTRAINT(mats) Material Constraints;

PROFIT..                 VPROFIT =E= SUM(cars, d(cars)*X(cars));
MATS_CONSTRAINT(mats) ..    SUM(cars, B(cars,mats)*X(cars)) =L= e(mats);


* 5. DEFINE the MODEL from the EQUATIONS
MODEL Production /PROFIT, MATS_CONSTRAINT/;
*Altnerative way to write (include all previously defined equations)
*MODEL Production /ALL/;


* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE Production USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
