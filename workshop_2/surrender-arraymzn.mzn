% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

% Decision variables
array[1..u] of var NEGOTIATOR: party;
var int: obj;

% Constraints
constraint forall(i in 1..u-1) (party[i] >= party[i + 1] + (party[i] != dummy));
constraint forall(i in 1..l) (party[i] != dummy);
constraint sum(i, j in 1..u where i < j) (joint[party[i], party[j]]) >= m;
constraint obj = min(i in 1..u where party[i] != dummy)(honor[party[i]]);

%output ["party = \(party);\nobj= \(minhonor);\n"];

solve maximize obj ;

