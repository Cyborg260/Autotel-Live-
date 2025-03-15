import 'package:flutter/foundation.dart';
import 'package:trackerapp/models/database_helper.dart';
import 'package:trackerapp/models/expense_record_model.dart';

class ExpenseRecordViewModel extends ChangeNotifier {
  List<ExpenseRecord> _expenseRecords = [];
  bool _isLoading = false;

  List<ExpenseRecord> get expenseRecords => _expenseRecords;
  bool get isLoading => _isLoading;

  // Fetch expense records for a specific vehicle from the database
  Future<void> fetchExpenseRecordsForVehicle(String vehicleId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _expenseRecords =
          await DatabaseHelper.getExpenseRecordsForVehicle(vehicleId);

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      // Handle error

      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new expense record
  Future<void> addExpenseRecord(ExpenseRecord record) async {
    try {
      await DatabaseHelper.insertExpenseRecord(record);
      print('Database added');

      // Fetch updated expense records after successful insertion
      await fetchExpenseRecordsForVehicle(record.vehicleId);
    } catch (error) {
      print('Database error is ' + error.toString());
    }
  }

  // Update an existing expense record
  Future<void> updateExpenseRecord(ExpenseRecord record) async {
    try {
      await DatabaseHelper.updateExpenseRecord(record);
      // Fetch updated expense records after successful update
      await fetchExpenseRecordsForVehicle(record.vehicleId);
    } catch (error) {
      print('Database error is ' + error.toString());
    }
  }

  // Delete an expense record
  Future<void> deleteExpenseRecord(int recordId, String vehicleId) async {
    try {
      await DatabaseHelper.deleteExpenseRecord(recordId);
      // Fetch updated expense records after successful deletion
      await fetchExpenseRecordsForVehicle(vehicleId);
    } catch (error) {
      print('Database error is ' + error.toString());
    }
  }

  double calculateTotalAmount() {
    print('calculating total');
    double total = 0;
    for (var record in _expenseRecords) {
      total += record.amount;
    }
    return total;
  }

  // Fetch current month's expense records for a specific vehicle from the database
  Future<void> fetchExpenseRecordsForCurrentMonthByVehicle(
      String vehicleId) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('vehicle Id is' + vehicleId.toString());
      _expenseRecords =
          await DatabaseHelper.getExpenseRecordsForCurrentMonth(vehicleId);

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print('Error is at ' + error.toString());

      _isLoading = false;
      notifyListeners();
    }
  }
}
