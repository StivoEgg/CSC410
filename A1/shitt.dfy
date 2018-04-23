method copy_neg (a: array<int>, b: array<int>)
  returns (r: nat)
  requires a != null && b != null && a != b
  requires a.Length <= b.Length
  modifies b
  ensures 0 <= r <= a.Length
  ensures forall x | x in a[..] :: x < 0 <==> x in b[..r]
{
  r := 0;
  var i := 0;
  while i < a.Length
    invariant 0 <= r <= i <= a.Length
    invariant forall x | x in b[..r] :: x < 0
    invariant forall x | x in a[..i] && x < 0 :: x in b[..r]
  {
    if a[i] < 0 {
      b[r] := a[i];
      assert forall x | x in b[..r] :: x < 0;
      r := r + 1;
    }
    i := i + 1;
  }
}
