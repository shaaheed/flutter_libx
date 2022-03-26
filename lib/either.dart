class Either<TLeft, TRight> {
  TLeft left;
  TRight? right;

  Either(
    this.left, {
    this.right,
  });
}
