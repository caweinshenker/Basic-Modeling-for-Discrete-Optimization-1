% Beauty Trap
% Perform the most seductive dance

enum LEGS = {spin, leap, waltz, curtsey, prep, stand};
enum ARMS = {beckon, out, up, wrapped, neutral};
enum FACE = {smile, wink, batt, think, glow, blank};

int: maxlen;
set of int: STEP = 1..maxlen;
array[LEGS] of int: maxlegs;
array[ARMS] of int: maxarms;
array[FACE] of int: maxface;
constraint assert(maxlegs[stand] >= maxlen, "maxlegs[stand] smaller than maxlen");
constraint assert(maxarms[neutral] >= maxlen, "maxarms[neutral] smaller than maxlen");
constraint assert(maxface[blank] >= maxlen, "maxface[blank] smaller than maxlen");
array[LEGS,ARMS] of int: dance_value;
array[ARMS,FACE] of int: entice_value;
constraint assert(dance_value[stand,neutral] = 0, "incorrect dance_value array");
constraint assert(entice_value[neutral,blank] = 0, "incorrect entice_value array");
int: boredom; % how bored each step make the viewer

var STEP: len;
array[STEP] of var LEGS: legs;
array[STEP] of var ARMS: arms;
array[STEP] of var FACE: face;



% Decision vars
var int: power = sum(i in 1..len) (dance_value[legs[i], arms[i]] + entice_value[arms[i], face[i]]) - (boredom * len);

% Constraints

% constraint (forall(legMove in LEGS)  ((sum(i in 1..maxlen)(legs[i] = legMove)) < maxlegs[legMove]));
% constraint (forall(armMove in ARMS)  ((sum(i in 1..maxlen)(arms[i] = armMove)) < maxarms[armMove]));
% constraint (forall(faceMove in FACE) ((sum(i in 1..maxlen)(face[i] = faceMove)) < maxface[faceMove]));


constraint(forall(i in len+1..maxlen) (legs[i] = stand /\ arms[i] = neutral /\ face[i] = blank));

constraint(forall(i in 1..len)   (legs[i] = leap -> i > 1 /\ legs[i-1] = prep));
constraint(forall(i in 1..len-1) (legs[i] = spin -> legs[i+1] in {curtsey, prep, stand}));
constraint(forall(i in 1..len-1) (legs[i] = leap -> legs[i+1] in {spin, waltz, stand}));
constraint(forall(i in 1..len-3) ((legs[i] = waltz /\  legs[i+1] = waltz /\  legs[i+2] = waltz) -> legs[i+3] != waltz));
constraint(forall(i in 1..len-1) (legs[i] = curtsey -> legs[i+1] != prep));
constraint(forall(i, j in 1..len where i > j) (legs[i] = waltz /\ legs[j] = curtsey -> exists(k in i+1..j-1) (legs[k] = stand)));

constraint(forall(i in 2..len-1) (arms[i] = beckon -> i != 1 /\ arms[i-1] in {out, up}));
constraint(forall(i in 1..len) (arms[i] = wrapped -> i = 1 \/ arms[i-1] in {beckon, neutral}));
constraint(forall(i in 1..len-1) (arms[i] = arms[i+1] -> arms[i] = neutral));

constraint(forall(i in 1..len-1) (face[i] = face[i+1] -> face[i] = blank));
constraint(forall(i in 1..len-1) (face[i] in {smile, batt} -> face[i+1] != think));



% Solve
output ["len = ", show(len), ";\n" ++
        "legs = ", show(legs), ";\n" ++
        "arms = ", show(arms), ";\n" ++
        "face = ", show(face), ";\n" ++
        "obj = ", show(power),";"];
solve maximize power;