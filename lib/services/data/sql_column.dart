class SqlColumn {
  String name;
  bool insert;
  bool update;
  dynamic Function() value;

  SqlColumn(this.name, this.insert, this.update, this.value);
}
