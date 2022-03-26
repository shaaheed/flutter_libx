import '../../services/ioc.service.dart';
import 'package:rxdart/rxdart.dart';

abstract class Bloc<TEvent> {
  final _controller = BehaviorSubject<TEvent>();

  Stream<TEvent> get stream => _controller.stream;

  void addEvent(TEvent event) {
    _controller.sink.add(event);
  }

  T get<T extends Object>() {
    return IocService.get<T>();
  }

  void dispose() {
    _controller.close();
  }
}
