method Abs(x: int) returns (y: int)
  // Add a precondition here so that the method verifies.
  requires x == -1
  // Don't change the postconditions.
  ensures 0 <= y
  ensures 0 <= x ==> y == x
  ensures x < 0 ==> y == -x
{
  y:= x + 2;
}
method Abs2(x: int) returns (y: int)
  // Add a precondition here so that the method verifies.
  // Not possible to verify with the given implementation.
  requires x == -1
  // Don't change the postconditions.
  ensures 0 <= y
  ensures 0 <= x ==> y == x
  ensures x < 0 ==> y == -x
{
  y:= x + 1;
}
