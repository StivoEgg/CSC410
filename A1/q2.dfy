predicate sorted(a:array<int>, begin:int, end:int)
    reads a;
    requires a != null
    requires 0<= begin <= end < a.Length
{
  forall i, j :: (i >= 0 && begin <= i <= j <= end) ==> a[i] <= a[j]
}

lemma partitioned(a:array<int>, i:int, j:int, k:int, l:int)
    requires a != null
    requires 0<= i <= j <= l < a.Length
    requires 0<= i <= k <= l < a.Length
    requires j >= k
    requires sorted(a, i, j) && sorted(a, k, l)
    ensures sorted(a, i, k)
{
    assert sorted(a, i, k);
}

method stoogeSort(a : array<int>, left : int, right : int)
    modifies a
    requires a != null;
    requires a.Length > 0
    requires 0 <= left <= right < a.Length
    decreases right - left
    ensures sorted(a, left, left + (right - left + 1) / 3)
    ensures sorted(a, left + (right - left + 1) / 3, right - (right - left + 1) / 3)
    ensures sorted(a, right - (right - left + 1) / 3, right)
    ensures sorted(a, left, right)
{
    if (a[left] > a[right]) {
        // swap a[left] and a[right]
        var tmp := a[left];
        a[left] := a[right];
        a[right] := tmp;
    }
    if (left + 1 >= right) {
        return;
    }

    var k := (right - left + 1) / 3;

    stoogeSort(a,left, right - k); // First two-thirds
    assert sorted(a,left, right - k);
    assert forall i, j :: 
        (left <= i <= left + k - 1 && left + k <= j <= right - k) ==> a[i] <= a[j];
    
    // assert that every element in the second one-third is greater
    // than everyone in the first one-third


    stoogeSort(a, left + k, right); // Last two-thirds
    assert sorted(a,left + k, right);
    assert sorted(a, right - k, right);
    assert forall i, j :: 
        (left + k  <= i <= right - k + 1 && right - k + 1 <= j <= right) ==> a[i] <= a[j];
    
    // assert that every element in the first one-third is 
    // the same as before stoogeSorting the last two-thirds

    // assert that every element in the last one-third is greater
    // than everyone in the first one-third

    stoogeSort(a,left, right - k); // First two-thirds again
    assert sorted(a,left, right - k);
    assert sorted(a, right - k + 1, right);
    assert sorted(a,left, right);
}