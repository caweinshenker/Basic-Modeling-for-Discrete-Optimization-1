array[int] of int: readings;
int: start;
int: n = length(readings);
set of int: TIME0 = 0..n;
set of int: TIME = 1..n;
array[TIME0] of var 25..30: temp;

constraint temp[0] = start;
constraint forall(t in TIME) (temp[t] = (temp[t-1] + readings[t]) div 2  + adjust[choice[t]]);

enum ACTION = {heat, strongly_heat, cool, strongly_cool, do_nothing};
array[ACTION] of int: adjust = [+1, +4, -2, -5, 0];
array[ACTION] of int: costs = [1, 5, 3, 9, 0];


% Decision variables
array[TIME] of var ACTION: choice;
var int: cost = sum(t in TIME)(costs[choice[t]]);


output ["temp = ", show(temp), "\n",
        "choice = ", show(choice), "\n",
        "cost = ", show(cost), "\n"];

solve minimize cost;








