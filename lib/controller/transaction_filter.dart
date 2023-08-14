import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marlo_tech/model/transaction_model.dart';
import 'package:marlo_tech/service/json_data.dart';

class TransactionFilterProvider with ChangeNotifier {
  // fetch transaction data
  TransactionRes? allTransactions;
  List<Datum>? transaction;

  Future<void> fetchTransactionData() async {
    try {
      final jsonData = JsonData().jsonData;
      allTransactions = TransactionRes.fromJson(jsonData);
      transaction = allTransactions?.data;
      notifyListeners();
    } catch (e) {
      log("error fetching data");
    }
  }

// Text Editing Controllers
  TextEditingController minimumController = TextEditingController();
  TextEditingController maximumController = TextEditingController();

  List<String> allFilters = [];
  DateTimeRange? dateTimeRange;

  List<String> moneyInOut = ['Money in', 'Money out'];
  List<String> moneyInOutadd = [];
  List<String> statuses = [
    'Completed',
    'Failed',
    'Declined',
    'Pending',
    'Reverted',
    'Cancelled'
  ];
  List<String> statusAdd = [];
  List<String> timeRange = [
    'Today',
    'This week',
    'This month',
    'This quarter',
    'custom'
  ];
  List<String> timeRangeAdd = [];
  String? createCustomRange;

  moneyInOutFuntion(String value) {
    if (!moneyInOutadd.contains(value)) {
      moneyInOutadd.add(value);
      notifyListeners();
    } else {
      moneyInOutadd.remove(value);
      notifyListeners();
    }
  }

  statusFunction(value) {
    if (!statusAdd.contains(value)) {
      statusAdd.add(value);
      notifyListeners();
    } else {
      statusAdd.remove(value);
      notifyListeners();
    }
  }

  timeRangeFuntion(value) {
    if (!timeRangeAdd.contains(value)) {
      timeRangeAdd.add(value);
      notifyListeners();
    } else {
      timeRangeAdd.remove(value);
      notifyListeners();
    }
  }

  disposeFilter() {
    minimumController.clear();
    maximumController.clear();
    moneyInOutadd.clear();
    timeRangeAdd.clear();
    statusAdd.clear();
    allFilters.clear();
    dateTimeRange = null;
    timeRange.removeLast();
    timeRange.add('custom');
    createCustomRange = null;
    notifyListeners();
  }

  runFilter() {
    allFilters = [...moneyInOutadd, ...statusAdd, ...timeRangeAdd];
    if (minimumController.text.isNotEmpty &&
        maximumController.text.isNotEmpty) {
      allFilters
          .add("min ${minimumController.text} - max ${maximumController.text}");
    }
    if (dateTimeRange != null) {
      final dateTime = DateTime.parse(dateTimeRange!.start.toString());
      String formatedDate = DateFormat('d MMMM').format(dateTime);
      final dateTime2 = DateTime.parse(dateTimeRange!.end.toString());
      String formatedDate2 = DateFormat('d MMMM').format(dateTime2);

      allFilters.add("$formatedDate - $formatedDate2");
    }
    notifyListeners();
    log(allFilters.toString());
  }

  removeFilter(index) {
    if (allFilters[index] ==
        "min ${minimumController.text} - max ${maximumController.text}") {
      minimumController.clear();
      maximumController.clear();
    }

    allFilters.removeAt(index);
    minimumController.clear();
    maximumController.clear();
    notifyListeners();
  }

  newDateTimeRange(DateTimeRange newDate) {
    dateTimeRange = newDate;
    final dateTime = DateTime.parse(dateTimeRange!.start.toString());
    String formatedDate = DateFormat('d MMMM').format(dateTime);
    final dateTime2 = DateTime.parse(dateTimeRange!.end.toString());
    String formatedDate2 = DateFormat('d MMMM').format(dateTime2);

    createCustomRange = "$formatedDate - $formatedDate2";
    timeRange.removeLast();
    timeRange.add(createCustomRange!);
    notifyListeners();
  }

  search(String keyword) {
    if (keyword.isEmpty) {
      transaction = allTransactions?.data;
      notifyListeners();
    } else {
      transaction = allTransactions?.data
          ?.where((element) => element.description!
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
      notifyListeners();
    }
  }

  bool isMoneyIn(Datum moneyInOut) {
    return moneyInOut.transactionType == "CONVERSION_BUY";
  }

  filtersearch() {
    if (allFilters.isEmpty) {
      transaction = allTransactions?.data;
      notifyListeners();
    } else {
      List<Datum>? settledIn;
      List<Datum>? cancelledIn;
      List<Datum>? pendingIn;
      List<Datum>? pendingOut;
      List<Datum>? settledOut;
      List<Datum>? cancelledOut;
      List<Datum>? settled;
      List<Datum>? cancelled;
      List<Datum>? pending;
      List<Datum>? moneyNull;
      List<Datum>? moneyInTrue;
      List<Datum>? moneyOutTrue;
      List<Datum>? amountRangeSettled;
      List<Datum>? amountRangeSettledIn;
      List<Datum>? amountRangeSettledOut;
      List<Datum>? amountRangePending;
      List<Datum>? amountRangePendingIn;
      List<Datum>? amountRangePendingOut;
      List<Datum>? amountRangeCancel;
      List<Datum>? amountRangeCancelIn;
      List<Datum>? amountRangeCancelOut;

      final moneyIn = allFilters.contains('Money in')
          ? allTransactions?.data
              ?.where((element) => isMoneyIn(element))
              .toList()
          : null;
      final moneyOut = allFilters.contains('Money out')
          ? allTransactions?.data
              ?.where((element) => isMoneyIn(element))
              .toList()
          : null;

      if (moneyIn == null && moneyOut == null) {
        settled = allFilters.contains('Completed')
            ? allTransactions?.data
                ?.where((element) => element.status == "SETTLED")
                .toList()
            : null;
        cancelled = allFilters.contains('Cancelled')
            ? allTransactions?.data
                ?.where((element) => element.status == "CANCELLED")
                .toList()
            : null;
        pending = allFilters.contains('Pending')
            ? allTransactions?.data
                ?.where((element) => element.status == "PENDING")
                .toList()
            : null;

        if (minimumController.text.isNotEmpty &&
            maximumController.text.isNotEmpty) {
          final minInt = int.parse(minimumController.text);
          final maxInt = int.parse(maximumController.text);
          amountRangeSettled = settled
              ?.where((element) =>
                  double.parse(element.amount!.replaceAll(',', '')).abs() >
                      minInt &&
                  double.parse(element.amount!.replaceAll(',', '')).abs() <
                      maxInt)
              .toList();
          amountRangeCancel = cancelled
              ?.where((element) =>
                  double.parse(element.amount!.replaceAll(',', '')).abs() >
                      minInt &&
                  double.parse(element.amount!.replaceAll(',', '')).abs() <
                      maxInt)
              .toList();
          amountRangePending = pending
              ?.where((element) =>
                  double.parse(element.amount!.replaceAll(',', '')).abs() >
                      minInt &&
                  double.parse(element.amount!.replaceAll(',', '')).abs() <
                      maxInt)
              .toList();
          moneyNull = [
            ...?amountRangeSettled,
            ...?amountRangeCancel,
            ...?amountRangePending
          ];
        } else {
          moneyNull = [...?settled, ...?cancelled, ...?pending];
        }
        notifyListeners();
      }

      if (moneyIn != null) {
        settledIn = allFilters.contains('Completed')
            ? moneyIn.where((element) => element.status == "SETTLED").toList()
            : null;
        cancelledIn = allFilters.contains('Cancelled')
            ? moneyIn.where((element) => element.status == "CANCELLED").toList()
            : null;
        pendingIn = allFilters.contains('Pending')
            ? moneyIn.where((element) => element.status == "PENDING").toList()
            : null;
        if (settledIn == null && cancelledIn == null && pendingIn == null) {
          if (minimumController.text.isNotEmpty &&
              maximumController.text.isNotEmpty) {
            final minInt = int.parse(minimumController.text);
            final maxInt = int.parse(maximumController.text);
            final moneyInRange = moneyIn
                .where((element) =>
                    double.parse(element.amount!.replaceAll(',', '')).abs() >
                        minInt &&
                    double.parse(element.amount!.replaceAll(',', '')).abs() <
                        maxInt)
                .toList();
            moneyInTrue = moneyInRange;
          } else {
            moneyInTrue = moneyIn;
          }
        } else {
          if (minimumController.text.isNotEmpty &&
              maximumController.text.isNotEmpty) {
            final minint = int.parse(minimumController.text);
            final maxint = int.parse(maximumController.text);
            amountRangeSettledIn = settledIn
                ?.where((element) =>
                    double.parse(element.amount!.replaceAll(',', '')).abs() >
                        minint &&
                    double.parse(element.amount!.replaceAll(',', '')).abs() <
                        maxint)
                .toList();
            amountRangeCancelIn = cancelledIn
                ?.where((element) =>
                    double.parse(element.amount!.replaceAll(',', '')).abs() >
                        minint &&
                    double.parse(element.amount!.replaceAll(',', '')).abs() <
                        maxint)
                .toList();
            amountRangePendingIn = pendingIn
                ?.where((element) =>
                    double.parse(element.amount!.replaceAll(',', '')).abs() >
                        minint &&
                    double.parse(element.amount!.replaceAll(',', '')).abs() <
                        maxint)
                .toList();
            moneyInTrue = [
              ...?amountRangeSettledIn,
              ...?amountRangeCancelIn,
              ...?amountRangePendingIn
            ];
          } else {
            moneyInTrue = [...?settledIn, ...?cancelledIn, ...?pendingIn];
          }
        }

        notifyListeners();
      }

      if (moneyOut != null) {
        settledOut = allFilters.contains('Completed')
            ? moneyOut.where((element) => element.status == "SETTLED").toList()
            : null;
        cancelledOut = allFilters.contains('Cancelled')
            ? moneyOut
                .where((element) => element.status == "CANCELLED")
                .toList()
            : null;
        pendingOut = allFilters.contains('Pending')
            ? allTransactions?.data
                ?.where((element) =>
                    element.status == "PENDING" && !isMoneyIn(element))
                .toList()
            : null;
        if (settledOut == null && cancelledOut == null && pendingOut == null) {
          if (minimumController.text.isNotEmpty &&
              maximumController.text.isNotEmpty) {
            final minInt = int.parse(minimumController.text);
            final maxInt = int.parse(maximumController.text);
            final moneyoutrange = moneyOut
                .where((element) =>
                    double.parse(element.amount!.replaceAll(',', '')).abs() >
                        minInt &&
                    double.parse(element.amount!.replaceAll(',', '')).abs() <
                        maxInt)
                .toList();
            moneyOutTrue = moneyoutrange;
          } else {
            moneyOutTrue = moneyOut;
          }
        } else {
          if (minimumController.text.isNotEmpty &&
              maximumController.text.isNotEmpty) {
            final minint = int.parse(minimumController.text);
            final maxint = int.parse(maximumController.text);
            amountRangeSettledOut = settledOut
                ?.where((element) =>
                    double.parse(element.amount!.replaceAll(',', '')).abs() >
                        minint &&
                    double.parse(element.amount!.replaceAll(',', '')).abs() <
                        maxint)
                .toList();
            amountRangeCancelOut = cancelledOut
                ?.where((element) =>
                    double.parse(element.amount!.replaceAll(',', '')).abs() >
                        minint &&
                    double.parse(element.amount!.replaceAll(',', '')).abs() <
                        maxint)
                .toList();
            amountRangePendingOut = pendingOut
                ?.where((element) =>
                    double.parse(element.amount!.replaceAll(',', '')).abs() >
                        minint &&
                    double.parse(element.amount!.replaceAll(',', '')).abs() <
                        maxint)
                .toList();
            moneyOutTrue = [
              ...?amountRangeSettledOut,
              ...?amountRangeCancelOut,
              ...?amountRangePendingOut
            ];
          } else {
            moneyOutTrue = [...?settledOut, ...?cancelledOut, ...?pendingOut];
          }
        }

        notifyListeners();
      }

      final transactions = <dynamic>{
        ...?moneyNull,
        ...?moneyInTrue,
        ...?moneyOutTrue
      };
      transaction = transactions.cast<Datum>().toList();
      notifyListeners();
    }
  }
}
