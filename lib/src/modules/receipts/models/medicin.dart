class Medicine {
  final String? id;
  final String name;
  final String observations;
  final int quantity;
  final bool isAdministered;

  const Medicine({
    this.id,
    required this.name,
    required this.observations,
    required this.quantity,
    this.isAdministered = false,
  });

  Medicine copyWith({
    String? id,
    String? name,
    String? observations,
    int? quantity,
    bool? isAdministered,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      observations: observations ?? this.observations,
      quantity: quantity ?? this.quantity,
      isAdministered: isAdministered ?? this.isAdministered,
    );
  }
}
