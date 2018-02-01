var int: x;

constraint x >= 1;
constraint x <= 10;

solve satisfy;

output [show(x)];

