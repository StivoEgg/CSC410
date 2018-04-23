function method unpair(i: nat) : (nat, nat)
requires i >= 0;
decreases i;
{
     if i <= 0 then
        (0, 0)
     else
        var (x,y) := unpair(i - 1);
        if y == 0 then
            (0, x+1)
        else
            (x+1, y-1)
}

function method cantor(x: int, y: int) : (nat)
requires x >=0 && y>= 0;
ensures unpair(cantor(x,y)) == (x,y);
{
    (1/2) * (x + y) * (x + y + 1) + x
}

function abs(x: int)  : int
ensures abs(x) >= 0;
{
   if x < 0
      then -x
   else
      x
}

function method pick(i: nat): nat 
{
    var (x, y) := unpair(i);
    x+i*y
}
method catchTheSpy(a: nat, b: nat) 
{
    var i := 0;
    while a + i * b != pick(i)
    { 
        i := i + 1; 
    }
}