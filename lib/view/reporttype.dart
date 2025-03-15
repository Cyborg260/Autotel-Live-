import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/models/device_history_on_map.dart';
import 'package:trackerapp/models/view_report_intial_data.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';
import 'package:trackerapp/view/customehistory.dart';
import 'package:trackerapp/view_model/date_timepicker_viewmodel.dart';
import 'package:trackerapp/view_model/reporttypeview_viewmodel.dart';

class ReportTypeScreen extends StatefulWidget {
  final DeviceHistoryOnMapIntialData initialData;
  const ReportTypeScreen(this.initialData, {super.key});

  @override
  State<ReportTypeScreen> createState() => _ReportTypeScreenState();
}

class _ReportTypeScreenState extends State<ReportTypeScreen> {
  DateTime currentDateTime = DateTime.now();
  // DateTime initialDateTime = DateTime(2023, 01, 19, 5, 30);
  DateFormat dateFormat = DateFormat("yy-MM-dd");
  DateFormat timeFormat = DateFormat("HH:mm:ss");
  DateTime initialDateTimeFrom = DateTime(DateTime.now().year,
      DateTime.now().month, DateTime.now().day, 00, 01, 00);
  DateTime initialDateTimeTo = DateTime(DateTime.now().year,
      DateTime.now().month, DateTime.now().day, 23, 59, 00);

  DateTimePickerViewModel dateTimePickerViewModel = DateTimePickerViewModel();
  ReportTypeViewModel reportTypeViewModel = ReportTypeViewModel();

  Future<DateTime?> pickDate() {
    return showDatePicker(
      context: context,
      initialDate: initialDateTimeFrom,
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
  }

  Future<void> showDatePickerDialog(BuildContext context, String screenRout) {
    return showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomeHistoryDateTimePicker(
                  widget.initialData.deviceId!, screenRout),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    reportTypeViewModel.fetchReportsTypeFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xffefecec),
        centerTitle: false,
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.date_range),
              shape: ContinuousRectangleBorder(
                borderRadius: AppColors.popupmenuborder,
              ),
              onSelected: ((value) {
                String toDate;
                String fromDate;
                String fromTime = '00:00:01';
                String toTime = '23:59:00';
                DateTime dt;
                DateFormat newFormat;
                dt = DateTime.now();
                newFormat = DateFormat("yy-MM-dd");
                toDate = newFormat.format(dt);
                switch (value) {
                  case 0:
                    toDate = newFormat.format(dt);
                    fromDate = newFormat.format(dt);
                    toDate = newFormat.format(dt.add(const Duration(days: 1)));
                    Navigator.popAndPushNamed(
                      context,
                      RoutesName.reporttype,
                      arguments: DeviceHistoryOnMapIntialData(
                          deviceTitle: widget.initialData.deviceTitle,
                          deviceId: widget.initialData.deviceId,
                          fromDate: fromDate,
                          toDate: toDate,
                          fromTime: fromTime,
                          toTime: toTime),
                    );
                    break;

                  case 1:
                    fromDate =
                        newFormat.format(dt.subtract(const Duration(days: 1)));
                    toDate = newFormat.format(dt);
                    Navigator.popAndPushNamed(
                      context,
                      RoutesName.reporttype,
                      arguments: DeviceHistoryOnMapIntialData(
                          deviceTitle: widget.initialData.deviceTitle,
                          deviceId: widget.initialData.deviceId,
                          fromDate: fromDate,
                          toDate: toDate,
                          fromTime: fromTime,
                          toTime: toTime),
                    );
                    break;
                  case 7:
                    toDate = newFormat.format(dt);
                    fromDate =
                        newFormat.format(dt.subtract(const Duration(days: 7)));
                    Navigator.popAndPushNamed(
                      context,
                      RoutesName.reporttype,
                      arguments: DeviceHistoryOnMapIntialData(
                          deviceTitle: widget.initialData.deviceTitle,
                          deviceId: widget.initialData.deviceId,
                          fromDate: fromDate,
                          toDate: toDate,
                          fromTime: fromTime,
                          toTime: toTime),
                    );
                    break;
                  case 30:
                    toDate = newFormat.format(dt);
                    fromDate =
                        newFormat.format(dt.subtract(const Duration(days: 30)));
                    Navigator.popAndPushNamed(
                      context,
                      RoutesName.reporttype,
                      arguments: DeviceHistoryOnMapIntialData(
                          deviceTitle: widget.initialData.deviceTitle,
                          deviceId: widget.initialData.deviceId,
                          fromDate: fromDate,
                          toDate: toDate,
                          fromTime: fromTime,
                          toTime: toTime),
                    );
                    break;
                  case 2:
                    showDatePickerDialog(context, 'reporttype');
                    break;

                  default:
                    toDate = newFormat.format(dt.add(const Duration(days: 1)));
                    fromDate = newFormat.format(dt);
                    Navigator.popAndPushNamed(
                      context,
                      RoutesName.reporttype,
                      arguments: DeviceHistoryOnMapIntialData(
                          deviceTitle: widget.initialData.deviceTitle,
                          deviceId: widget.initialData.deviceId,
                          fromDate: fromDate,
                          toDate: toDate,
                          fromTime: fromTime,
                          toTime: toTime),
                    );
                }
              }),
              // child: Container(
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              //   decoration: BoxDecoration(
              //     color: Colors.black12,
              //     borderRadius: BorderRadius.circular(20.0),
              //   ),
              //   child: Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: const [
              //         Icon(
              //           Icons.report_outlined,
              //           size: 16,
              //         ),
              //         Text(
              //           ' Reports',
              //           style: TextStyle(fontSize: 14),
              //         )
              //       ]),
              // ),
              itemBuilder: (BuildContext bc) {
                return const [
                  PopupMenuItem(
                    value: 0,
                    child: Text('Today'),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text('yesterday'),
                  ),
                  PopupMenuItem(
                    value: 7,
                    child: Text('7 Days'),
                  ),
                  PopupMenuItem(
                    value: 30,
                    child: Text('30 Days'),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text('Custom Date'),
                  ),
                ];
              }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.car_repair,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const VerticalDivider(
                          width: 2,
                        ),
                        // const Text(
                        //   'Device: ',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 12,
                        //       color: Colors.grey),
                        // ),
                        Text(
                          widget.initialData.deviceTitle.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const VerticalDivider(
                      width: 2,
                    ),
                    const Text(
                      'From: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                    Text(
                      widget.initialData.fromDate
                          .toString()
                          .split('-')
                          .reversed
                          .join('-'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const VerticalDivider(
                      width: 2,
                    ),
                    const Text(
                      'To: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                    Text(
                      widget.initialData.toDate
                          .toString()
                          .split('-')
                          .reversed
                          .join('-'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ChangeNotifierProvider<DateTimePickerViewModel>(
          //   create: (context) => dateTimePickerViewModel,
          //   child: Consumer<DateTimePickerViewModel>(
          //     builder: (context, value, child) {
          //       return Container(
          //         child: Row(
          //           children: [
          //             OutlinedButton(
          //               onPressed: () async {
          //                 final date = await pickDate();
          //                 print(initialDateTimeFrom);
          //                 if (date == null) {
          //                   return;
          //                 }
          //                 final newDatetime = DateTime(
          //                   date.year,
          //                   date.month,
          //                   date.day,
          //                   initialDateTimeFrom.hour,
          //                   initialDateTimeFrom.minute,
          //                 );
          //                 initialDateTimeFrom = newDatetime;
          //                 print('now Date is $initialDateTimeFrom');
          //                 value.setDateTime();
          //               },
          //               child: Row(
          //                 children: [
          //                   const Icon(Icons.date_range),
          //                   const VerticalDivider(),
          //                   Text(
          //                       '${initialDateTimeFrom.day}/${initialDateTimeFrom.month}/${initialDateTimeFrom.year}'),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),
          ChangeNotifierProvider<ReportTypeViewModel>(
            create: (context) => reportTypeViewModel,
            child: Consumer<ReportTypeViewModel>(
              builder: (context, value, child) {
                switch (value.reportsTypeResponse.status) {
                  case Status.LOADING:
                    return Expanded(
                      child: Stack(children: const [
                        Center(child: CircularProgressIndicator()),
                      ]),
                    );

                  case Status.ERROR:
                    return Center(child: Text(AppColors.errorMessage));

                  case Status.COMPLETED:
                    return Expanded(
                      child: ListView.builder(
                        itemCount:
                            value.reportsTypeResponse.data!.items!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Card(
                              shape: AppColors.cardBorderShape,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ListTile(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RoutesName.getreports,
                                    arguments: ViewReportIntialData(
                                        widget.initialData.fromDate,
                                        widget.initialData.toDate,
                                        widget.initialData.deviceId,
                                        'pdf',
                                        value.reportsTypeResponse.data!
                                            .items![index].type),
                                  ),
                                  title: Text(
                                    value.reportsTypeResponse.data!
                                        .items![index].name
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );

                  default:
                }
                return Container();
              },
            ),
          )
        ],
      ),
    );
  }
}
