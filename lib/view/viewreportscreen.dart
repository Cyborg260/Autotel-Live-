import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/models/view_report_intial_data.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/view_model/getreportview_view_model.dart';

class GetReportScreen extends StatefulWidget {
  const GetReportScreen(this.viewReportIntialData, {super.key});
  final ViewReportIntialData viewReportIntialData;
  @override
  State<GetReportScreen> createState() => _GetReportScreenState();
}

class _GetReportScreenState extends State<GetReportScreen> {
  GetReportViewModel getReportViewModel = GetReportViewModel();

  @override
  void initState() {
    getReportViewModel.fetchGetReportsFromApi(widget.viewReportIntialData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FloatingActionButton(
            heroTag: UniqueKey(),
            mini: true,
            backgroundColor: AppColors.buttonColor,
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 300));
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: ChangeNotifierProvider<GetReportViewModel>(
          create: (context) => getReportViewModel,
          child: Consumer<GetReportViewModel>(
            builder: (context, value, child) {
              switch (value.getReportsResponse.status) {
                case Status.LOADING:
                  return Text('Loading....');
                case Status.ERROR:
                  return Text(AppColors.errorMessage);
                case Status.COMPLETED:
                  String pdf = value.getReportsResponse.data!.url.toString();
                  print(pdf);
                  return SfPdfViewer.network(
                      value.getReportsResponse.data!.url!,
                      pageLayoutMode: PdfPageLayoutMode.continuous);

                default:
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
