Future<T> tryFuture<T>(Future<T> future) async {
  // future.catchError(() => {});
  var result = await future;
  return result;
}
