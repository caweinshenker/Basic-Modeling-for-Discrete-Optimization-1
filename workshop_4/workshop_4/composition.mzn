int: n;
set of int: N = 1..n;
array[1..n] of var 1..n: ordering;
array[1..n-1] of var 1..n-1: differences;

include "all_different.mzn";
constraint(all_different(ordering));
constraint(forall(i in 2..n)  (differences[i-1] = abs(ordering[i] - ordering[i -1])));
constraint(alldifferent(differences));

%output ["order = \(ordering);\n"];
output [show(ordering[i]) ++ " " | i in 1..n];
output ["\n"];
output [" " ++ show(differences[i]) | i in 1..n-1];
solve satisfy;