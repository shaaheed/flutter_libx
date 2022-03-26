class Event {}

class LoadingEvent extends Event {}

class DataEvent<T> extends Event {
  final T data;
  DataEvent({required this.data});
}

class ListItemAddedEvent<T> extends Event {
  final T item;
  ListItemAddedEvent(this.item);
}

class ListItemUpdatedEvent<T> extends Event {
  final T item;
  ListItemUpdatedEvent(this.item);
}

class ListItemDeletedEvent<T> extends Event {
  final T item;
  ListItemDeletedEvent(this.item);
}

class EmptyEvent extends Event {
  final String? message;
  EmptyEvent({this.message});
}

class ErrorEvent extends Event {
  final String? message;
  ErrorEvent({this.message});
}
