int: n;

array[1..n] of var 0..3: x;
constraint x[1] = 0;
constraint x[n] = 3;
constraint forall(i in 2..n-1) (x[i - 1] + x[i] <= 3); 
constraint forall(i in 2..n-1) (x[i] + x[i + 1] <= 3);
constraint forall([x[i] >= 2 | i in 1..n where (i mod 3 = 0)]);

output [show(sum(x)), "=", show(x)];

solve maximize sum(x);
