class SqlColumn {
  String name;
  bool insert;
  bool update;
  bool? unique;
  bool? nullable;
  String? sqlType;
  dynamic Function() value;

  SqlColumn(
      {required this.name,
      required this.insert,
      required this.update,
      required this.value,
      this.nullable,
      this.sqlType,
      this.unique});
}
