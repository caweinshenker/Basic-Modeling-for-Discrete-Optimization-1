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
var set of NEGOTIATOR: party;
var int: minhonor;


% Constraints
constraint(card(party) >= l);
constraint(card(party) <= u);
constraint sum(i, j in party where i < j)(joint[i, j]) >= m;
constraint minhonor = min([honor[i] | i in NEGOTIATOR where i in party]);
constraint not(dummy in party);


output ["party = \(party);\nobj= \(minhonor);\n"];

solve maximize minhonor;

