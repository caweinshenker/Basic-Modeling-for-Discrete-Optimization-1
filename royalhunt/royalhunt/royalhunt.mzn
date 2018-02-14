int: n; % number of court members
set of int: COURT = 1..n;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;

int: m; % number of horses
set of int: HORSE = 1..m;
array[HORSE] of int: beauty;
array[HORSE] of int: speed;

array[COURT,HORSE] of int: enjoy;


% Decision vars

array[COURT] of var int: rider2horse;
array[HORSE] of var int: horse2rider;
var int: obj = sum(i in COURT)(enjoy[i, rider2horse[i]]) - 100 * violations;
var int: violations = sum(i, j in COURT where i < j /\ rank[i] > rank[j]) 
                         (beauty[rider2horse[i]] < beauty[rider2horse[j]] \/ rider2horse[j] > 0); 
                          


% Constraints

include "inverse.mzn";
include "alldifferent.mzn";

constraint (alldifferent(rider2horse));
constraint (alldifferent(horse2rider));
%constraint (inverse(rider2horse, horse2rider));

constraint (forall(i in 2..n) (enjoy[1, rider2horse[1]] > enjoy[i, rider2horse[i]]));
constraint (forall(i in 1..min(n, m)) (rider2horse[i] > 0));
constraint (forall(i in min(n,m)+1..max(n,m)) (rider2horse[i] = 0));

constraint (forall(i, j in HORSE where i < j) (speed[i] > speed[j] -> 
              (horse2rider[i] > n /\ horse2rider[j] > n) \/
              (horse2rider[j] > n ) \/ 
              ability[horse2rider[i]] >= ability[horse2rider[j]]));
         
         
% Solve

output ["horse = \(rider2horse);\nobj = \(obj);"];

solve maximize obj;







































 



