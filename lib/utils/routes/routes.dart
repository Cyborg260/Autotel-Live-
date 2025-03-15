import 'package:flutter/material.dart';
import 'package:trackerapp/models/device_history_on_map.dart';
import 'package:trackerapp/models/device_on_map_model.dart';
import 'package:trackerapp/models/event_on_map_model.dart';
import 'package:trackerapp/models/events_intitial_data.dart';
import 'package:trackerapp/models/expense_record_model.dart';
import 'package:trackerapp/models/view_report_intial_data.dart';
import 'package:trackerapp/view/AddVehicleMaintenanceScreen.dart';
import 'package:trackerapp/view/alerts.dart';
import 'package:trackerapp/view/alertstypelist.dart';
import 'package:trackerapp/view/contactusscreen.dart';
import 'package:trackerapp/view/eventsonmap.dart';
import 'package:trackerapp/view/geofencelist.dart';
import 'package:trackerapp/view/home.dart';
import 'package:trackerapp/view/login.dart';
import 'package:trackerapp/view/playroutonmap.dart';
import 'package:trackerapp/view/reporttype.dart';
import 'package:trackerapp/view/singledeviceonmap.dart';
import 'package:trackerapp/view/splashscreen.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';
import 'package:trackerapp/view/vehiclefuelist.dart';
import 'package:trackerapp/view/vehiclefuelreportview.dart';
import 'package:trackerapp/view/vehiclelisthistory.dart';
import 'package:trackerapp/view/vehiclereportlist.dart';
import 'package:trackerapp/view/viewexpenserecord.dart';
import 'package:trackerapp/view/viewreportscreen.dart';
import 'package:trackerapp/view/viewupcomingmaintenance.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashSceen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplachScreen(),
        );
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => Login(),
        );
      case RoutesName.geoFenceList:
        return MaterialPageRoute(
          builder: (BuildContext context) => const GeoFenceListScreen(),
        );
      case RoutesName.vehiclereportlist:
        return MaterialPageRoute(
          builder: (BuildContext context) => const VehicleReportList(),
        );
      case RoutesName.addVehicleMaintenanceScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              const AddVehicleMaintenanceScreen(),
        );

      case RoutesName.vehiclehistorylist:
        return MaterialPageRoute(
          builder: (BuildContext context) => const VehicleHistoryList(),
        );
      case RoutesName.viewVehicleFuelList:
        return MaterialPageRoute(
          builder: (BuildContext context) => const VehicleFuelListScreen(),
        );
      case RoutesName.viewExpenseScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final vehicleId = args['vehicleId'] as String;

        return MaterialPageRoute(
          builder: (BuildContext context) =>
              ExpenseRecordsTable(vehicleId: vehicleId),
        );
      case RoutesName.contactusScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ContactUsScreen(),
        );
      case RoutesName.viewMaintenanceSchedule:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ViewMaintenanceSchedule(),
        );
      case RoutesName.getreports:
        final viewReportIntialData = settings.arguments as ViewReportIntialData;
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              GetReportScreen(viewReportIntialData),
        );
      case RoutesName.eventsScreen:
        final eventsInitialData = settings.arguments as EventsInitialData;
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              EventsAlertsPage(eventsInitialData),
        );
      case RoutesName.reporttype:
        final deviceHistoryOnMapIntitalData =
            settings.arguments as DeviceHistoryOnMapIntialData;
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              ReportTypeScreen(deviceHistoryOnMapIntitalData),
        );
      case RoutesName.playroutonmap:
        final deviceHistoryOnMapIntitalData =
            settings.arguments as DeviceHistoryOnMapIntialData;
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              PlayRoutOnMap(deviceHistoryOnMapIntitalData),
        );
      case RoutesName.viewVehicleFuelReport:
        final deviceHistoryOnMapIntitalData =
            settings.arguments as DeviceHistoryOnMapIntialData;
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              VehicleFuelReporViewScreen(deviceHistoryOnMapIntitalData),
        );
      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HomePage(),
        );
      case RoutesName.alertsTypeList:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AlertsTypeListScreen(),
        );
      case RoutesName.eventondevicemap:
        final eventsOnMapDataModel = settings.arguments as EventOnMapDataModel;
        return MaterialPageRoute(
          builder: (BuildContext context) => EventsOnMap(eventsOnMapDataModel),
        );
      case RoutesName.singledevicemap:
        final deviceOnMapintialData =
            settings.arguments as DeviceOnMapintialData;
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              SingleDeviceOnMap(deviceOnMapintialData),
        );

      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplachScreen(),
        );
    }
  }
}
