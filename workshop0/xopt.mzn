var int: x;

constraint x >= 0;
constraint x <= 10;
constraint x mod 4 = 0;


output ["x=", show(x)];
solve minimize (x - 7) * (x - 7);


