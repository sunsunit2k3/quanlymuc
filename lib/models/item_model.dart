class Item {
  String name;
  String value;
  bool isMonitoring;
  Item({required this.name, required this.value, this.isMonitoring = false});
  Item copyWith({String? name, String? value, bool? isMonitoring}) {
    return Item(
      name: name ?? this.name,
      value: value ?? this.value,
      isMonitoring: isMonitoring ?? this.isMonitoring,
    );
  }
}
