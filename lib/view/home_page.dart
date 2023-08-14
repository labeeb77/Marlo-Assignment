import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marlo_tech/controller/transaction_filter.dart';
import 'package:marlo_tech/view/all_transactions.dart';
import 'package:marlo_tech/view/widgets/bottom_nav.dart';
import 'package:marlo_tech/view/widgets/gradiant_card.dart';
import 'package:marlo_tech/view/widgets/transaction_list.dart';
import 'package:marlo_tech/view/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TransactionFilterProvider>(context, listen: false)
          .fetchTransactionData();
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 253, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 253, 255),
        leading: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 253, 164, 48),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: const Color.fromARGB(255, 175, 95, 4))),
            child: const Center(
                child: Text(
              "JB",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            )),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_sharp,
                color: Colors.blue,
                size: 30.h,
              ))
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 140.h,
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return mainCard("assets/images/british-flag.png",
                      "15,256,486.00", "British pound");
                } else if (index == 1) {
                  return mainCard("assets/images/us-flag.png", "20,443,776.00",
                      "Us dollar");
                } else {
                  return mainCard("assets/images/canada-flag.png",
                      "18,543,990.00", "Canada");
                }
              },
              itemCount: 3,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0.h.w),
            child: const SizedBox(
                width: double.infinity,
                child: Text(
                  "To do 4",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                )),
          ),
          SizedBox(
            height: 140.h,
            child: const GradiantCard(),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.w),
            child: SizedBox(
                width: double.infinity,
                child: Row(children: [
                  const Text(
                    "All transactions",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AllTransactions(),
                        ));
                      },
                      child: const Text(
                        "See all",
                        style: TextStyle(color: Colors.blue),
                      ))
                ])),
          ),
          const TransactionList()
        ],
      )),
    );
  }
}
