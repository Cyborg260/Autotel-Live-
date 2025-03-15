import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/models/device_history_on_map.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/view_model/fuel_view_view_model.dart';

class VehicleFuelReporViewScreen extends StatefulWidget {
  final DeviceHistoryOnMapIntialData? initialData;

  const VehicleFuelReporViewScreen(this.initialData, {super.key});

  @override
  State<VehicleFuelReporViewScreen> createState() =>
      _VehicleFuelReporViewScreenState();
}

class _VehicleFuelReporViewScreenState
    extends State<VehicleFuelReporViewScreen> {
  FuelReportViewModel fuelReportViewModel = FuelReportViewModel();
  late String fromDateStr;
  late String toDateStr;
  late double fuelConsumed;
  late double totalFuelCost;
  late String vehicleName;
  double? currentFuelCostPerLiter = 1.0;
  double vehicleFuelAveragePerKm = 1.0;

  Future<void> getVehicleFuelAveragePerKm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    vehicleFuelAveragePerKm =
        prefs.getDouble('fuelAverage_${widget.initialData!.deviceId!}')!;
    currentFuelCostPerLiter = prefs.getDouble('fuelPrice');
  }

  @override
  void initState() {
    fuelReportViewModel.fetchDeviceRoutHisotyFromApi(
        widget.initialData!.deviceId!.toString(),
        widget.initialData!.fromDate!,
        widget.initialData!.toDate!,
        widget.initialData!.fromTime!,
        widget.initialData!.toTime!);
    vehicleName = widget.initialData!.deviceTitle.toString();
    DateFormat format = DateFormat("yy-MM-dd");
    DateTime date = format.parse(widget.initialData!.fromDate!);

    fromDateStr = DateFormat("dd-MM-yy").format(date);
    date = format.parse(widget.initialData!.toDate!);
    toDateStr = DateFormat("dd-MM-yy").format(date);
    getVehicleFuelAveragePerKm();
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
            title: const Text(
              'Fuel Report',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Column(
            children: [
              ChangeNotifierProvider<FuelReportViewModel>(
                create: (BuildContext context) => fuelReportViewModel,
                child: Consumer<FuelReportViewModel>(
                  builder: (context, value, child) {
                    switch (value.deviceRoutHistoryResponse.status) {
                      case Status.LOADING:
                        return Expanded(
                          child: Stack(children: const [
                            Center(
                              child: Image(
                                  image:
                                      AssetImage('assets/images/loading.gif'),
                                  width: 100,
                                  height: 100),
                            ),
                          ]),
                        );
                      case Status.ERROR:
                        return const Center(
                            child: Text(AppColors.errorMessage));
                      case Status.COMPLETED:
                        var arr = value
                            .deviceRoutHistoryResponse.data?.distanceSum
                            .split(' ');

                        fuelConsumed =
                            double.parse(arr[0]) / vehicleFuelAveragePerKm;
                        totalFuelCost = fuelConsumed * currentFuelCostPerLiter!;
                        return Column(
                          children: [
                            Card(
                              shape: AppColors.cardBorderShape,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          vehicleName,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.grey,
                                            size: 17,
                                          ),
                                          const VerticalDivider(
                                            width: 2,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: 'From : ',
                                              children: [
                                                TextSpan(
                                                  text: fromDateStr,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                )
                                              ],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.grey,
                                            size: 17,
                                          ),
                                          const VerticalDivider(
                                            width: 2,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: 'To : ',
                                              children: [
                                                TextSpan(
                                                  text: toDateStr,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                )
                                              ],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_month_outlined,
                                              color: Colors.grey,
                                              size: 17,
                                            ),
                                            const VerticalDivider(
                                              width: 2,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Distance : ',
                                                children: [
                                                  TextSpan(
                                                    text: value
                                                        .deviceRoutHistoryResponse
                                                        .data
                                                        ?.distanceSum,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  )
                                                ],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.gas_meter_outlined,
                                              color: Colors.grey,
                                              size: 17,
                                            ),
                                            const VerticalDivider(
                                              width: 2,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Fuel Used : ',
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${fuelConsumed.toStringAsFixed(2)} lit',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  )
                                                ],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.gas_meter_outlined,
                                              color: Colors.grey,
                                              size: 17,
                                            ),
                                            const VerticalDivider(
                                              width: 2,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Fuel Cost : ',
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${totalFuelCost.toStringAsFixed(2)} Rupees',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  )
                                                ],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.price_check,
                                              color: Colors.grey,
                                              size: 17,
                                            ),
                                            const VerticalDivider(
                                              width: 2,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Fuel Price : ',
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${currentFuelCostPerLiter.toString()} Rupees / lit',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  )
                                                ],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.car_repair,
                                              color: Colors.grey,
                                              size: 17,
                                            ),
                                            const VerticalDivider(
                                              width: 2,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Vehicle Average : ',
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${vehicleFuelAveragePerKm.toString()} Km/l',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  )
                                                ],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.cached_rounded,
                                              color: Colors.grey,
                                              size: 17,
                                            ),
                                            const VerticalDivider(
                                              width: 2,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Move Duration : ',
                                                children: [
                                                  TextSpan(
                                                    text: value
                                                        .deviceRoutHistoryResponse
                                                        .data
                                                        ?.moveDuration,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  )
                                                ],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.stop_circle_outlined,
                                              color: Colors.grey,
                                              size: 17,
                                            ),
                                            const VerticalDivider(
                                              width: 2,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Stop Duration : ',
                                                children: [
                                                  TextSpan(
                                                    text: value
                                                        .deviceRoutHistoryResponse
                                                        .data
                                                        ?.stopDuration,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  )
                                                ],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      default:
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
