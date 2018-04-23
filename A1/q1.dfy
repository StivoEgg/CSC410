predicate sorted(a:array<int>, begin:int, end:int)
    reads a;
    requires a != null
    requires 0<= begin <= end < a.Length
{
  forall i, j :: (i >= 0 && begin <= i <= j <= end) ==> a[i] <= a[j]
}

method insertSort(a : array<int>)
  modifies a;
  requires a != null
  requires a.Length >= 1
  ensures sorted(a, 0, a.Length - 1)
{
  var i := 1;
  while (i < a.Length)
    invariant 1 <= i <= a.Length
    invariant sorted(a, 0, i - 1)
    decreases a.Length - i
  {
    var j := i;
    var value := a[i];
    a[i] := a[i-1];
    while (j > 0 && a[j-1] > value)
       invariant forall k :: j <= k <= i - 1 ==> value < a[k]
       invariant sorted(a, 0, i)
       decreases j
    {
      a[j] := a[j-1];
      j := j - 1;
    }
    a[j] := value;
    i := i + 1;
  }
}