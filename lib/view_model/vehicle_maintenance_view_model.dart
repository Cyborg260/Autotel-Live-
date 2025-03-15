import 'package:flutter/foundation.dart';
import 'package:trackerapp/models/database_helper.dart';
import 'package:trackerapp/models/vehicle_maintancne_model.dart';

class VehicleMaintenanceViewModel extends ChangeNotifier {
  List<VehicleMaintenance> _maintenanceList = [];
  bool _isLoading = false;

  List<VehicleMaintenance> get maintenanceList => _maintenanceList;
  bool get isLoading => _isLoading;

  Future<void> fetchVehicleMaintenanceList(String vehicleId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _maintenanceList = await DatabaseHelper.getVehicleMaintenances(vehicleId);

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      // Handle error
      print('Sch error is' + error.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVehicleMaintenance(VehicleMaintenance maintenance) async {
    try {
      await DatabaseHelper.insertVehicleMaintenance(maintenance);
      // Fetch updated maintenance list after successful insertion
      await fetchVehicleMaintenanceList(maintenance.maintenanceVehicleId);
    } catch (error) {
      // Handle error
    }
  }

  Future<void> updateVehicleMaintenance(VehicleMaintenance maintenance) async {
    try {
      await DatabaseHelper.updateVehicleMaintenance(maintenance);
      // Fetch updated maintenance list after successful update
      await fetchVehicleMaintenanceList(maintenance.maintenanceVehicleId);
    } catch (error) {
      // Handle error
    }
  }

  Future<void> deleteVehicleMaintenance(
      String maintenanceId, String vehicleId) async {
    try {
      await DatabaseHelper.deleteVehicleMaintenance(maintenanceId);
      // Fetch updated maintenance list after successful deletion
      await fetchVehicleMaintenanceList(vehicleId);
    } catch (error) {
      // Handle error
    }
  }
}
