import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:trackerapp/data/globalsharedveriables.dart';
import 'package:trackerapp/models/vehicle_maintancne_model.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/view_model/vehicle_maintenance_view_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class AddVehicleMaintenanceScreen extends StatefulWidget {
  const AddVehicleMaintenanceScreen({super.key});

  @override
  _AddVehicleMaintenanceScreenState createState() =>
      _AddVehicleMaintenanceScreenState();
}

class _AddVehicleMaintenanceScreenState
    extends State<AddVehicleMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();

  final _maintenanceDateController = TextEditingController();
  final _maintenanceTimeController = TextEditingController();
  final _maintenanceTypeController = TextEditingController();
  final _maintenanceDescriptionController = TextEditingController();
  final _maintenanceVehicleNameController = TextEditingController();
  VehicleMaintenanceViewModel vehicleMaintenanceViewModel =
      VehicleMaintenanceViewModel();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _maintenanceDateController.dispose();
    _maintenanceTimeController.dispose();
    _maintenanceTypeController.dispose();
    _maintenanceDescriptionController.dispose();
    _maintenanceVehicleNameController.dispose();
    super.dispose();
  }

  String? selectedMaintenanceOption;
  String? selectedVehicleOption;
  List<String> maintenanceOptions = [
    'Oil Change',
    'Oil Filter Change',
    'Air Filter Change',
    'Timing Belt',
    'Greasing',
    'Engine Tuning',
    'Other',
  ];

  Future<void> _scheduleNotification(
    DateTime scheduledDateTime,
    String vehicleName,
    String description,
  ) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // 🔹 Initialize timezone support
    tz.initializeTimeZones();

    // 🔹 Convert scheduledDateTime to a timezone-aware format
    final tz.TZDateTime notificationTime = tz.TZDateTime.from(
        scheduledDateTime.subtract(const Duration(minutes: 5)), tz.local);

    // Create the notification details
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      12345,
      "IOS Local Notifications",
      "Maintenance schedule has been set",
      platformChannelSpecifics,
      payload: 'data',
    );

    // 🔹 Replaced `schedule` with `zonedSchedule`
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Maintenance Reminder',
      'Vehicle: $vehicleName\nDescription: $description\nTime: ${scheduledDateTime.toString()}',
      notificationTime,
      platformChannelSpecifics,
      // androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Future<void> _scheduleNotification(
  //   DateTime scheduledDateTime,
  //   String vehicleName,
  //   String description,
  // ) async {
  //   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //   // Calculate the notification time 5 minutes before the given time
  //   final notificationTime =
  //       scheduledDateTime.subtract(const Duration(minutes: 5));

  //   // Create the notification details
  //   const androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'channel_id',
  //     'channel_name',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );
  //   const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );
  //   const platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: iOSPlatformChannelSpecifics,
  //   );
  //   await flutterLocalNotificationsPlugin.show(
  //     12345,
  //     "IOS Local Notifications",
  //     "Maintenance schudule has been set",
  //     platformChannelSpecifics,
  //     payload: 'data',
  //   );

  //   // Schedule the notification
  //   await flutterLocalNotificationsPlugin.schedule(
  //     0,
  //     'Maintenance Reminder',
  //     'Vehicle: $vehicleName\nDescription: $description\nTime: ${scheduledDateTime.toString()}',
  //     notificationTime,
  //     platformChannelSpecifics,
  //     androidAllowWhileIdle: true,
  //   );
  // }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _maintenanceDateController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _maintenanceTimeController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _saveMaintenance() async {
    if (_formKey.currentState!.validate()) {
      final maintenance = VehicleMaintenance(
        maintenanceDate: DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        ),
        maintenanceType: selectedMaintenanceOption.toString(),
        maintenanceDescription: _maintenanceDescriptionController.text,
        maintenanceVehicleId: '', // Fill this with the appropriate vehicle ID
        maintenanceVehicleName: selectedVehicleOption.toString(),
      );

      try {
        await vehicleMaintenanceViewModel.addVehicleMaintenance(maintenance);
        // Schedule the local notification
        await _scheduleNotification(
          maintenance.maintenanceDate,
          maintenance.maintenanceVehicleName,
          maintenance.maintenanceDescription,
        );

        Navigator.pop(context);
      } catch (error) {
        // Handle error
        // print('Error while saving maintenance schedule' + error.toString());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: AppColors.appScreenBackgroundImage,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Add Maintenance Schedule',
              style: AppColors.appTitleTextStyle,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Add maintenance schedule with reminder'),
                    TextFormField(
                      controller: _maintenanceDateController,
                      onTap: _selectDate,
                      decoration: const InputDecoration(
                        labelText: 'Maintenance Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                      readOnly: true,
                    ),
                    TextFormField(
                      controller: _maintenanceTimeController,
                      onTap: _selectTime,
                      decoration: const InputDecoration(
                        labelText: 'Maintenance Time',
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select a time';
                        }
                        return null;
                      },
                      readOnly: true,
                    ),
                    DropdownButtonFormField<String>(
                      items: maintenanceOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedMaintenanceOption = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Select an option',
                      ),
                    ),
                    TextFormField(
                      controller: _maintenanceDescriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Maintenance Description',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the maintenance description';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      items: vehicleNames.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedVehicleOption = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Select Vechicle',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GFButton(
                          textColor: Colors.black87,
                          color: AppColors.buttonColor,
                          onPressed: _saveMaintenance,
                          text: "Save",
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GFButton(
                          textColor: Colors.black87,
                          color: AppColors.buttonColor,
                          onPressed: () => Navigator.pop(context),
                          text: "Close",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
