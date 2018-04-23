method copy_neg (a: array<int>, b: array<int>)
  requires a != null && b != null && a != b
  requires a.Length == b.Length
  modifies b
{
  var i := 0;
  var r := 0;
  ghost var sa := set j | 0 <= j < a.Length :: a[j];
  while i < a.Length
    invariant 0 <= r <= i <= a.Length
    invariant sa == set j | 0 <= j < a.Length :: a[j]
  {
    if a[i] < 0 {
      assert sa == set j | 0 <= j < a.Length :: a[j]; // OK
      b[r] := a[i];
      assert sa == set j | 0 <= j < a.Length :: a[j]; // KO!
      r := r + 1;
    }
    i := i + 1;
  }
}