int: n;


%Decision variables 

set of int: N = 1..n;
array[1..n] of var 1..n: order;
array[1..n-1] of var 1..n-1: differences;
array[1..n] of var 1..n: posn;
array[1..n-1] of var 1..n-1: dposn;


% Constraints
include "alldifferent.mzn";
include "inverse.mzn";


constraint(all_different(order));
constraint(alldifferent(differences));
constraint(forall(i in 2..n)  (differences[i-1] = abs(order[i] - order[i -1])));

constraint(inverse(order, posn));
constraint(inverse(differences, dposn));

output ["order = \(order);\ndiffs = \(differences);\nposn  = \(posn);\ndposn = \(dposn);"];
solve satisfy;


