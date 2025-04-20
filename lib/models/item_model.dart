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

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value, 'isMonitoring': isMonitoring};
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String,
      value: json['value'] as String,
      isMonitoring: json['isMonitoring'] as bool? ?? false,
    );
  }
}
