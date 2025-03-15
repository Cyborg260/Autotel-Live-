import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/models/vehicle_maintancne_model.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/res/components/custometitletontainer.dart';
import 'package:trackerapp/view_model/vehicle_maintenance_view_model.dart';

class ViewMaintenanceSchedule extends StatefulWidget {
  const ViewMaintenanceSchedule({super.key});

  @override
  State<ViewMaintenanceSchedule> createState() =>
      _ViewMaintenanceScheduleState();
}

class _ViewMaintenanceScheduleState extends State<ViewMaintenanceSchedule> {
  VehicleMaintenanceViewModel vehicleMaintenanceViewModel =
      VehicleMaintenanceViewModel();
  @override
  void initState() {
    // TODO: implement initState

    vehicleMaintenanceViewModel.fetchVehicleMaintenanceList('');
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
            'Maintenance Schedule',
            style: AppColors.appTitleTextStyle,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
        ),
        body: ChangeNotifierProvider.value(
          value: vehicleMaintenanceViewModel,
          child: Consumer<VehicleMaintenanceViewModel>(
            builder: (context, value, child) {
              List<VehicleMaintenance> maintenanceList = value.maintenanceList;

              return ListView.builder(
                itemCount: maintenanceList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: Card(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      shape: AppColors.cardBorderShape,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTitleContainer(
                                  titleText: maintenanceList[index]
                                      .maintenanceVehicleName),
                              InkWell(
                                onTap: () => vehicleMaintenanceViewModel
                                    .deleteVehicleMaintenance(
                                        maintenanceList[index]
                                            .maintenanceId
                                            .toString(),
                                        ''),
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                    size: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.double_arrow_rounded,
                                  color: Colors.red,
                                  size: 12,
                                ),
                                const VerticalDivider(
                                  width: 4,
                                ),
                                Text(maintenanceList[index]
                                    .maintenanceDescription),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.car_repair,
                                          size: 12,
                                        ),
                                        Text(
                                          maintenanceList[index]
                                              .maintenanceType,
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  158, 158, 158, 1),
                                              fontSize: 12),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.alarm,
                                          size: 12,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          DateFormat('hh:mm a').format(
                                              maintenanceList[index]
                                                  .maintenanceDate),
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  158, 158, 158, 1),
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 12,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          DateFormat('dd-MM-yyyy').format(
                                              maintenanceList[index]
                                                  .maintenanceDate),
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  158, 158, 158, 1),
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    ));
  }
}
