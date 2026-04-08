function max(a: int, b: int): int
 ensures a >= b ==> max(a, b) == a
 ensures a < b ==> max(a, b) == b
{
    if a >= b then a else b
}
method Testing() {
  // Add assertions to check max here.
  assert max(3, 3) == 3;
  assert max(7, -2) == 7;
  assert max(-1, 100000000000) == 100000000000;
  assert max(-10, -3) == -3;
}
