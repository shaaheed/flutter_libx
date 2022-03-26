extension ListExtension<T> on List<T> {
  T? firstOrDefault(bool Function(T item) test) {
    var results = where(test);
    return results.isNotEmpty ? results.first : null;
  }
}
