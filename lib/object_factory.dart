class ObjectFactory<T> {
  late T _state;
  late T Function() _createFactory;

  ObjectFactory(T Function() createFactory) {
    _createFactory = createFactory;
  }

  T getCurrent() => _state;

  T createNew() {
    _state = null as T;
    _state = _createFactory.call();
    return _state;
  }

  dispose() {
    _state = null as T;
  }
}
