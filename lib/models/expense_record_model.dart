class ExpenseRecord {
  final int? id;
  final DateTime date;
  final double amount;
  final String category;
  final String description;
  final String vehicleId;
  final String vehicleName;

  ExpenseRecord({
    this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.description,
    required this.vehicleId,
    required this.vehicleName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'category': category,
      'description': description,
      'vehicle_id': vehicleId,
      'vehicle_name': vehicleName,
    };
  }
}
