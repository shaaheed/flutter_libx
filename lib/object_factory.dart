class ObjectFactory<T> {
  T? _state;
  T Function()? _createFactory;

  ObjectFactory(T Function() createFactory) {
    _createFactory = createFactory;
  }

  T? getCurrent() => _state;

  T? createNew() {
    _state = _createFactory?.call();
    return _state;
  }

  dispose() {}
}
