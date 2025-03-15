import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trackerapp/models/expense_record_model.dart';
import 'package:trackerapp/models/vehicle_maintancne_model.dart';

class DatabaseHelper {
  static const _databaseName = 'vehicle_allrecordn.db';
  static const _databaseVersion = 1;

  static const expenseRecordsTable = 'expense_records';
  static const vehicleMaintenancesTable = 'vehicle_maintenances';

  // Expense Records table columns
  static const columnId = 'id';
  static const columnDate = 'date';
  static const columnAmount = 'amount';
  static const columnCategory = 'category';
  static const columnDescription = 'description';
  static const columnVehicleId = 'vehicle_id';
  static const columnVehicleName = 'vehicle_name';

  // Vehicle Maintenances table columns
  static const columnMaintenanceId = 'maintenance_id';
  static const columnMaintenanceDate = 'maintenance_date';
  static const columnMaintenanceType = 'maintenance_type';
  static const columnMaintenanceDescription = 'maintenance_description';
  static const columnMaintenanceVehicleId = 'maintenance_vehicle_id';
  static const columnMaintenanceVehicleName = 'maintenance_vehicle_Name';

  static Database? _database;

  DatabaseHelper._();

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<String?> getStorageDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    // print('Path is' + documentsDirectory.toString());
    //final path = join('/storage/emulated/0/Music/files', _databaseName);
    final path =
        join(await documentsDirectory.path, 'database/' + _databaseName);
    print('Path is' + path.toString());
    // Create and open the database
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        // Create the expense_records table
        await db.execute('''
          CREATE TABLE $expenseRecordsTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnDate INTEGER,
            $columnAmount REAL,
            $columnCategory TEXT,
            $columnDescription TEXT,
            $columnVehicleId TEXT,
            $columnVehicleName TEXT
          )
        ''');

        // Create the vehicle_maintenances table
        await db.execute('''
          CREATE TABLE $vehicleMaintenancesTable (
            $columnMaintenanceId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnMaintenanceDate INTEGER,
            $columnMaintenanceType TEXT,
            $columnMaintenanceDescription TEXT,
            $columnMaintenanceVehicleId TEXT,
            $columnMaintenanceVehicleName TEXT
          )
        ''');
      },
    );
  }

  // Expense Records table methods

  static Future<void> insertExpenseRecord(ExpenseRecord record) async {
    final db = await database;
    print('Expense Added ' + record.toMap().toString());
    // Insert the record into the expense_records t able
    await db.insert(
      expenseRecordsTable,
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<ExpenseRecord>> getExpenseRecordsForVehicle(
      String vehicleId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = [];
    if (vehicleId == '') {
      // Retrieve expense records for a specific vehicle from the expense_records table
      maps = await db.query(
        expenseRecordsTable,
        orderBy: '$columnDate DESC',
      );
    } else {
      // Retrieve expense records for a specific vehicle from the expense_records table
      maps = await db.query(
        expenseRecordsTable,
        where: '$columnVehicleId = ?',
        whereArgs: [vehicleId],
        orderBy: '$columnDate DESC',
      );
    }

    // Convert query results to ExpenseRecord objects
    return List.generate(maps.length, (index) {
      return ExpenseRecord(
        id: maps[index][columnId],
        date: DateTime.fromMillisecondsSinceEpoch(maps[index][columnDate]),
        amount: maps[index][columnAmount],
        category: maps[index][columnCategory],
        description: maps[index][columnDescription],
        vehicleId: maps[index][columnVehicleId],
        vehicleName: maps[index][columnVehicleName],
      );
    });
  }

  static Future<void> updateExpenseRecord(ExpenseRecord record) async {
    final db = await database;

    // Update the record in the expense_records table
    await db.update(
      expenseRecordsTable,
      record.toMap(),
      where: '$columnId = ?',
      whereArgs: [record.id],
    );
  }

  static Future<void> deleteExpenseRecord(int recordId) async {
    final db = await database;

    // Delete the record from the expense_records table
    await db.delete(
      expenseRecordsTable,
      where: '$columnId = ?',
      whereArgs: [recordId],
    );
  }

  static Future<List<ExpenseRecord>> getExpenseRecordsForCurrentMonth(
      String vehicleId) async {
    final db = await database;

    // Get the current month and year
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    // Calculate the start and end dates of the current month
    final startDate = DateTime(currentYear, currentMonth, 1);
    final endDate = DateTime(currentYear, currentMonth + 1, 0);

    // Format the start and end dates in SQLite date format (YYYY-MM-DD)
    final formattedStartDate = formatDateForSqlite(startDate);
    final formattedEndDate = formatDateForSqlite(endDate);

    // Retrieve expense records for the current month from the expense_records table
    List<Map<String, dynamic>> maps = [];
    if (vehicleId == '') {
      maps = await db.query(
        expenseRecordsTable,
        where: '$columnDate >= ? AND $columnDate <= ?',
        whereArgs: [formattedStartDate, formattedEndDate],
        orderBy: '$columnDate DESC',
      );
    } else {
      maps = await db.query(
        expenseRecordsTable,
        where: '$columnVehicleId = ? AND $columnDate >= ? AND $columnDate <= ?',
        whereArgs: [vehicleId, formattedStartDate, formattedEndDate],
        orderBy: '$columnDate DESC',
      );
    }
    // Convert query results to ExpenseRecord objects
    return List.generate(maps.length, (index) {
      return ExpenseRecord(
        id: maps[index][columnId],
        date: DateTime.fromMillisecondsSinceEpoch(maps[index][columnDate]),
        amount: maps[index][columnAmount],
        category: maps[index][columnCategory],
        description: maps[index][columnDescription],
        vehicleId: maps[index][columnVehicleId],
        vehicleName: maps[index][columnVehicleName],
      );
    });
  }

  // static Future<double> calculateTotalExpensesForCurrentMonth() async {
  //   final expenseRecords = await getExpenseRecordsForCurrentMonth();

  //   double totalAmount = 0;
  //   for (final record in expenseRecords) {
  //     totalAmount += record.amount;
  //   }

  //   return totalAmount;
  // }

  static String formatDateForSqlite(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  // Vehicle Maintenances table methods

  static Future<void> insertVehicleMaintenance(
      VehicleMaintenance maintenance) async {
    final db = await database;
    try {
      // Insert the maintenance record into the vehicle_maintenances table
      await db.insert(
        vehicleMaintenancesTable,
        maintenance.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // print('Maintenance Schedule Added ' + maintenance.toMap().toString());
    } catch (e) {
      // print('Error inserting maintenance record: $e');
      // Handle the error here (e.g., show an error message to the user)
    }
  }

  static Future<List<VehicleMaintenance>> getVehicleMaintenances(
      String vehicleId) async {
    final db = await database;

    // Retrieve vehicle maintenances for a specific vehicle from the vehicle_maintenances table
    List<Map<String, dynamic>> maps = [];
    if (vehicleId == '') {
      maps = await db.query(
        vehicleMaintenancesTable,
        orderBy: '$columnMaintenanceDate ASC',
      );
    } else {
      maps = await db.query(
        vehicleMaintenancesTable,
        where: '$columnMaintenanceVehicleId = ?',
        whereArgs: [vehicleId],
        orderBy: '$columnMaintenanceDate ASC',
      );
    }

    // Convert query results to VehicleMaintenance objects
    return List.generate(maps.length, (index) {
      return VehicleMaintenance(
        maintenanceId: maps[index][columnMaintenanceId],
        maintenanceDate: DateTime.fromMillisecondsSinceEpoch(
            maps[index][columnMaintenanceDate]),
        maintenanceType: maps[index][columnMaintenanceType],
        maintenanceDescription: maps[index][columnMaintenanceDescription],
        maintenanceVehicleId: maps[index][columnMaintenanceVehicleId],
        maintenanceVehicleName: maps[index][columnMaintenanceVehicleName],
      );
    });
  }

  static Future<void> updateVehicleMaintenance(
      VehicleMaintenance maintenance) async {
    final db = await database;

    // Update the maintenance record in the vehicle_maintenances table
    await db.update(
      vehicleMaintenancesTable,
      maintenance.toMap(),
      where: '$columnMaintenanceId = ?',
      whereArgs: [maintenance.maintenanceId],
    );
  }

  static Future<void> deleteVehicleMaintenance(String maintenanceId) async {
    final db = await database;

    // Delete the maintenance record from the vehicle_maintenances table
    await db.delete(
      vehicleMaintenancesTable,
      where: '$columnMaintenanceId = ?',
      whereArgs: [maintenanceId],
    );
  }
}
