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

array[COURT] of var HORSE union {0}: rider2horse;
array[HORSE] of var COURT union {0}: horse2rider;

var int: obj = sum(i in COURT where rider2horse[i] != 0)(enjoy[i, rider2horse[i]]) - (100 * violations);

var int: violations = sum(i, j in HORSE where speed[i] > speed[j] /\     
                         (not (
                         (horse2rider[i] = 0 \/
                         (horse2rider[i] = 0 /\ horse2rider[j] = 0) \/
                         ability[horse2rider[i]] >= ability[horse2rider[j]])))) (1); 
                   
                                                         
% Constraints

include "alldifferent_except_0.mzn";

constraint (alldifferent_except_0(rider2horse));


% The emperor enjoys his ride most
constraint (forall(i in 2..n where rider2horse[i] != 0) (enjoy[emperor, rider2horse[emperor]] > enjoy[i, rider2horse[i]]));

% Ride until no horses left or no court members left, whichever comes first
constraint (sum(i in COURT) (rider2horse[i] > 0) = min(n, m));

% Channeling constraint
constraint (forall(i in COURT, j in HORSE) (rider2horse[i] = j <-> horse2rider[j] = i));

% If a court member holds a higher rank than another, then either 
% (a) the beauty of their horse can be no less than that assigned to the other, 
% (b) the lower rank member does not ride, or
% (c) both court members do not ride.
constraint (forall(i, j in COURT where rank[i] > rank[j])
             (rider2horse[j] = 0 \/
             (rider2horse[i] = 0 /\ rider2horse[j] = 0) \/ 
             (beauty[rider2horse[i]] >= beauty[rider2horse[j]])));

% Riders must have non-negative enjoyment
constraint (forall(i in COURT where rider2horse[i] != 0) (enjoy[i, rider2horse[i]] >= 0));
         
% Solve
output ["horse = \(rider2horse);\nobj = \(obj);"];
%output ["horse = \(rider2horse);\nrider = \(horse2rider);\nobj = \(obj);\nviolations = \(violations)"];

solve maximize obj;







































 



