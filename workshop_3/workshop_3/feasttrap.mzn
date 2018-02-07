% Beauty Trap
% Create the most magnificient feast 
enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umame, bland};
enum TEMP = {hot, cold, warm};
%int: ndish;
%set of int: DISH = 1..ndish;
%set of int: TASTE = 1..6;
%int: spicy = 1; int: sour = 2; int: salty = 3; int: sweet = 4; int: umame = 5; int: bland = 6;
%set of int: TEMP = 1..3;
%int: hot = 1; int: cold = 2; int: warm = 3;


array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

int: len; % length of banquet
set of int: COURSE = 1..len;

array[COURSE] of var DISH: dish;


% Decision variables
var int: magnificence =  sum(d in dish)(value[d]) +
                         sum(i in 1..(len - 1))(TASTE[dish[i]] != TASTE[dish[i+1]]) + 
                         sum(i in 1..(len - 1))(TEMP[dish[i]] != TEMP[dish[i+1]]) + 
                         sum(i in 1..(len - 1))(heavy[dish[i]] != heavy[dish[i+1]]);


% Constraints
include "alldifferent.mzn";
constraint alldifferent(dish);
constraint (forall(i in 1..(len - 1)) (not (TASTE[dish[i]] = TASTE[dish[i+1]]))); % No flavor twice in a row
constraint TASTE[dish[1]] = salty; %salty first
constraint TASTE[dish[len]] = sweet; %sweet last
constraint (forall(i in 1..(len - 1) where TASTE[dish[i]] = spicy) (TASTE[dish[i+1]] = bland \/ TASTE[dish[i+1]] = sweet)); %salty -> bland or sweet
constraint (forall(i in 1..(len - 1) where TASTE[dish[i]] = sour) (TASTE[dish[i+1]] = bland \/ TASTE[dish[i+1]] = umame)); % sour -> bland or umame
constraint (forall(i in 1..(len - 1) where TASTE[dish[i]] = sweet) (TASTE[dish[i+1]] != spicy /\ TASTE[dish[i+1]] != umame)); % sweet -> not spicy and not umame
constraint (forall(i, j in 1..len where i < j  /\ TEMP[dish[i]] = hot /\ TEMP[dish[j]] = cold) (
                   exists (k in i+1..j-1) (TEMP[dish[k]] = warm))); % warm dish between hot and cold
constraint (forall(i in 1..(len - 2) where heavy[dish[i]]  /\ heavy[dish[i+1]]) (not heavy[dish[i+2]])); %No two heavy dishes in a row



% Solve
output ["DISH = ", show(dish), "\n",
        "obj = ", show(magnificence)];

solve maximize magnificence