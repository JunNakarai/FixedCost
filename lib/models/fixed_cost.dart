class FixedCost {
  String name;
  int amount;

  FixedCost({required this.name, required this.amount});

  factory FixedCost.fromJson(Map<String, dynamic> json) {
    return FixedCost(
      name: json['name'] ?? '',
      amount: json['amount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}
