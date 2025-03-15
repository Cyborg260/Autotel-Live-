import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/models/expense_record_model.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/view_model/expnese_record_view_model.dart';

class ExpenseRecordsTable extends StatefulWidget {
  final String vehicleId;

  ExpenseRecordsTable({required this.vehicleId});

  @override
  State<ExpenseRecordsTable> createState() => _ExpenseRecordsTableState();
}

class _ExpenseRecordsTableState extends State<ExpenseRecordsTable> {
  ExpenseRecordViewModel expenseRecordViewModel = ExpenseRecordViewModel();
  String vehicleID = '';
  ExpenseRecord? _selectedRecord;

  Future<void> showExpenseDetails(BuildContext context, ExpenseRecord record) {
    setState(() {
      _selectedRecord = record;
    });

    return showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedRecord = null;
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      size: 14,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Date:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(record.date.toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Amount:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Rs. ${record.amount.toString()}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(record.description),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedRecord = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      expenseRecordViewModel.deleteExpenseRecord(
                          record.id!, record.vehicleId);
                      Navigator.pop(context);
                      setState(() {
                        _selectedRecord = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    vehicleID = widget.vehicleId.toString();
    expenseRecordViewModel.fetchExpenseRecordsForVehicle(vehicleID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRecord = null;
        });
      },
      child: SafeArea(
        child: DecoratedBox(
          decoration: AppColors.appScreenBackgroundImage,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'Vehicle Expenses',
                style: AppColors.appTitleTextStyle,
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: false,
            ),
            body: ChangeNotifierProvider.value(
              value: expenseRecordViewModel,
              child: Consumer<ExpenseRecordViewModel>(
                builder: (context, viewModel, _) {
                  List<ExpenseRecord> expenseRecords = viewModel.expenseRecords;
                  double totalAmount = viewModel.calculateTotalAmount();
                  print('List length is ${expenseRecords.length}');

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Amount: Rs. $totalAmount',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: DataTable(
                              border: TableBorder.all(
                                width: 1,
                              ),
                              headingRowHeight: 28,
                              dataRowHeight: 28,
                              dataTextStyle: const TextStyle(
                                  fontSize: 11, color: Colors.black),
                              columns: const [
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Vehicle')),
                                DataColumn(label: Text('Amount')),
                              ],
                              rows: expenseRecords
                                  .map(
                                    (record) => DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) => _selectedRecord == record
                                            ? Colors.green.withOpacity(0.5)
                                            : Colors.transparent,
                                      ),
                                      cells: [
                                        DataCell(Text(record.date
                                            .toString()
                                            .split(' ')
                                            .first)),
                                        DataCell(
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Text(record.vehicleName),
                                          ),
                                          onTap: () => showExpenseDetails(
                                              context, record),
                                        ),
                                        DataCell(
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'Rs. ${record.amount.toString()}'),
                                              Flexible(
                                                child: TextButton(
                                                  onPressed: () {
                                                    viewModel
                                                        .deleteExpenseRecord(
                                                            record.id!,
                                                            record.vehicleId);
                                                    setState(() {
                                                      _selectedRecord = null;
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
