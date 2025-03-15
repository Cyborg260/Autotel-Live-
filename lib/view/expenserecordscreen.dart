import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackerapp/models/expense_record_model.dart';
import 'package:trackerapp/view_model/expnese_record_view_model.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  final String vehicleId;
  final String vehicleName;

  AddExpenseScreen({required this.vehicleId, required this.vehicleName});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  ExpenseRecordViewModel expenseRecordViewModel = ExpenseRecordViewModel();
  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Vehicle ID: ${widget.vehicleId}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vehicle Name: ${widget.vehicleName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd-MM-yyyy').format(_selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                    keyboardType: TextInputType
                        .number, // Set the keyboard type to numeric
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9]*$')), // Only allow numeric input
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Create an ExpenseRecord object from the form data
                        ExpenseRecord expenseRecord = ExpenseRecord(
                          date: _selectedDate,
                          amount: double.parse(_amountController.text),
                          category: _categoryController.text,
                          description: _descriptionController.text,
                          vehicleId: widget.vehicleId,
                          vehicleName: widget.vehicleName,
                        );

                        // Add the expense record using the view model
                        // Provider.of<ExpenseRecordViewModel>(context,
                        //         listen: false)
                        //     .addExpenseRecord(expenseRecord);
                        expenseRecordViewModel
                            .addExpenseRecord(expenseRecord)
                            .then((value) => Navigator.pop(context));
                      }
                    },
                    child: const Text('Add Expense'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
