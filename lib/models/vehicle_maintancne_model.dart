class VehicleMaintenance {
  int? maintenanceId;
  final DateTime maintenanceDate;
  final String maintenanceType;
  final String maintenanceDescription;
  final String maintenanceVehicleId;
  final String maintenanceVehicleName; // New property

  VehicleMaintenance({
    this.maintenanceId,
    required this.maintenanceDate,
    required this.maintenanceType,
    required this.maintenanceDescription,
    required this.maintenanceVehicleId,
    required this.maintenanceVehicleName, // Initialize the property in the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'maintenance_id': maintenanceId,
      'maintenance_date': maintenanceDate.millisecondsSinceEpoch,
      'maintenance_type': maintenanceType,
      'maintenance_description': maintenanceDescription,
      'maintenance_vehicle_id': maintenanceVehicleId,
      'maintenance_vehicle_Name':
          maintenanceVehicleName, // Add the vehicleName to the map
    };
  }
}
