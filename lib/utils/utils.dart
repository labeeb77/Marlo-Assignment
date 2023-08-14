import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controller/transaction_filter.dart';

class Utils {
  static String formatDate(DateTime dateTime) {
    final formatter = DateFormat('MMMM d, y - h:mm a');
    return formatter.format(dateTime);
  }

  static Future datePicker(BuildContext context) async {
    DateTimeRange? newDateTime = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
      currentDate: DateTime.now(),
      helpText: 'Custome time range',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 218, 243, 255),
          ),
          child: Builder(builder: (BuildContext context) {
            return child!;
          }),
        );
      },
    );

    if (newDateTime != null) {
      Provider.of<TransactionFilterProvider>(context, listen: false)
          .newDateTimeRange(newDateTime);
    }
  }
}
