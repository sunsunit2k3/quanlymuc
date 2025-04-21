class Item {
  String name;
  String value;
  double price;
  bool isMonitoring;
  bool isInCart;
  Item({
    required this.name,
    required this.value,
    required this.price,
    this.isMonitoring = false,
    this.isInCart = false,
  });
  Item copyWith({
    String? name,
    String? value,
    bool? isMonitoring,
    bool? isInCart,
    double? price,
  }) {
    return Item(
      name: name ?? this.name,
      value: value ?? this.value,
      isMonitoring: isMonitoring ?? this.isMonitoring,
      isInCart: isInCart ?? this.isInCart,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'isMonitoring': isMonitoring,
      'price': price,
      'isInCart': isInCart,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String,
      value: json['value'] as String,
      isMonitoring: json['isMonitoring'] as bool? ?? false,
      price: json['price'] as double,
      isInCart: json['isInCart'] as bool? ?? false,
    );
  }
}
