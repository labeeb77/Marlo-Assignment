import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marlo_tech/controller/transaction_filter.dart';
import 'package:marlo_tech/utils/utils.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.h.w),
      child: Consumer<TransactionFilterProvider>(
        builder: (context, value, child) {
          if (value.transaction != null && value.transaction!.isNotEmpty) {
            return SizedBox(
              height: 230.h,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final DateTime creationDate =
                      DateTime.parse(value.transaction![index].createdAt!);
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        value.transaction![index].description!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        Utils.formatDate(creationDate),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(bottom: 15.h),
                        child: Text(
                          "\$${value.transaction![index].amount}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      leading: Container(
                        height: 45.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 6, 50, 87)),
                        child: Center(
                          child: Icon(
                            value.transaction![index].transactionType ==
                                    "CONVERSION_BUY"
                                ? Icons.south_west_rounded
                                : Icons.north_east_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: value.transaction!.length,
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No Transactions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }
}
