import '../../services/repository.service.dart';
import '../../models/model.dart';
import '../../blocs/bloc.dart';
import '../../blocs/event.dart';

abstract class ListBloc<T extends Model<T>> extends Bloc<Event> {
  int _limit = 10;
  int _offset = 0;
  // int _total = 0;
  bool _hasMore = false;
  List<T> _items = [];

  RepositoryService<T>? createRepository() => null;

  Future<void> load({
    Object? arguments,
  }) async {
    var repo = createRepository();
    if (repo != null) {
      var list = await repo.list(
        offset: offset,
        limit: limit,
        arguments: arguments,
      );
      addItems(list);
      forward();
    }
    return Future.value();
  }

  void forward() {
    _offset = _offset + _limit;
  }

  void reset() {
    _limit = 10;
    _offset = 0;
    // _total = 0;
    _hasMore = false;
    _items = [];
  }

  bool get hasMore => _hasMore;

  int get limit => _limit;

  int get offset => _offset;

  List<T> get items => _items;

  void addItems(List<T>? items) {
    if (_offset == 0 && (items == null || items.isEmpty)) {
      addEvent(EmptyEvent());
    } else if (items != null || items!.isNotEmpty) {
      _hasMore = _limit == items.length;
      _items.addAll(items);
    }
    addEvent(DataEvent<List<T>>(data: _items));
  }

  void updateItem(T? item) {
    if (item != null && _items.isNotEmpty) {
      int index = _items.indexWhere((_item) => _item.id == item.id);
      if (index != -1) {
        _items[index] = item;
        addEvent(DataEvent<List<T>>(data: items));
      }
    }
  }

  void addItem(T? item) {
    if (item != null) {
      _items.add(item);
      addEvent(DataEvent<List<T>>(data: items));
    }
  }

  void deleteItem(T? item) {
    if (item != null && _items.isNotEmpty) {
      int index = _items.indexWhere((_item) => _item.id == item.id);
      if (index != -1) {
        _items.removeAt(index);
      }
      addEvent(DataEvent<List<T>>(data: items));
    }
  }
}
