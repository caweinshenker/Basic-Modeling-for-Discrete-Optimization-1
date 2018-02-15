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

var int: obj = sum(i in COURT)(if rider2horse[i] != 0 then enjoy[i, rider2horse[i]] else 0 endif) - 100 * violations;
var int: violations = sum(i, j in HORSE where speed[i] > speed[j]) 
                         (ability[horse2rider[i]] < beauty[rider2horse[j]] /\ 
                          rider2horse[i] != 0 /\ 
                          rider2horse[j] != 0); 

% %If one horse is faster than another
% constraint (forall(i, j in HORSE) (speed[i] > speed[j] -> 
%               ability[horse2rider[i]] >= ability[horse2rider[j]] \/ % Faster horse rider has greater ability
%               (horse2rider[i] = 0 /\ horse2rider[j] = 0) \/         % Neither court member rides
%               (horse2rider[j] = 0 )                                 %  
%              ));
         



% Constraints

include "alldifferent_except_0.mzn";

constraint (alldifferent_except_0(rider2horse));
constraint (alldifferent_except_0(horse2rider));

% 1
% The emperor enjoys his ride most
constraint (forall(i in 2..n where rider2horse[i] != 0) (enjoy[emperor, rider2horse[emperor]] > enjoy[i, rider2horse[i]]));

% 2
% Ride until no horses left or no court members left, whichever comes first
constraint (forall(i in 1..min(n, m)) (rider2horse[i] > 0));
constraint (forall(i in min(n,m)+1..n) (rider2horse[i] = 0));

% 3
% If a court member holds a higher rank than another, then either 
% (a) the beauty of their horse can be no less than that assigned to the other, 
% (b) the lower rank member does not ride, or
% (c) both court members do not ride.
constraint (forall(i, j in 1..n where rank[i] > rank[j])
             (beauty[rider2horse[i]] >= beauty[rider2horse[j]] \/
             rider2horse[j] = 0 \/
             (rider2horse[i] = 0 /\ rider2horse[j] = 0)));


% Either a court member enjoys the ride or they do not ride at all
constraint (forall(i in COURT where rider2horse[i] != 0) (enjoy[i, rider2horse[i]] >= 0));
         
% Solve
output ["horse = \(rider2horse);\nrider = \(horse2rider);\nobj = \(obj);"];

solve maximize obj;







































 



