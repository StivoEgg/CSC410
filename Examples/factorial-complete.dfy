function fact(n: nat): nat
{
	if n <= 1 then 1
		else n * fact(n - 1) 
}


method computeFactorial(n: int) returns (f: int)
	requires n >= 1
  ensures f == fact(n)
{
  var i := 0;
	f := n;  
  while i < n - 1
		invariant 0 <= i < n
		invariant f * fact(n - i - 1) == fact(n)
	{
		i := i + 1;
		f := f * (n - i);
	}
}
