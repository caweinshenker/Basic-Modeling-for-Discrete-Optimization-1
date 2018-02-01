var 1..9: B;
var 0..9: E;
var 0..9: A;
var 0..9: N;
var 0..9: S;
var 1..9: C;
var 0..9: R;
var 0..9: Y;
var 0..9: I;
var 0..9: G;

include "alldifferent.mzn";
constraint alldifferent([B,E,A,S,C,R,Y,I,N,G]);


constraint
        2 * (10000 * B + 1000 * E + 100 * A + 10 * N + S)
        = 100000 * C + 10000 * R + 1000 * Y + 100 * I + 10 * N + G;
  


solve satisfy;