import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marlo_tech/controller/transaction_filter.dart';
import 'package:marlo_tech/view/widgets/custom_box.dart';
import 'package:marlo_tech/view/widgets/transaction_list.dart';
import 'package:marlo_tech/view/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AllTransactions extends StatelessWidget {
  const AllTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TransactionFilterProvider>(context, listen: false)
          .fetchTransactionData();
    });
    TextEditingController searchcontroller = TextEditingController();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 253, 255),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            backgroundColor: const Color.fromARGB(255, 247, 253, 255),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Transactions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 300.w,
                  child: Consumer<TransactionFilterProvider>(
                    builder: (context, provider, child) =>
                        CupertinoSearchTextField(
                      placeholder: 'Enter text',
                      controller: searchcontroller,
                      onChanged: (value) {
                        provider.search(value);
                      },
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            height: 700.h,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 247, 247, 247),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 15),
                              child: Consumer<TransactionFilterProvider>(
                                builder: (context, provider, child) => ListView(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Filter",
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              provider.disposeFilter();
                                            },
                                            child: const Text("Clear",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.w500)))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    moneyInAndOutWidget(provider),
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                    statusesWidget(provider),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    amountWidget(provider),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            provider.disposeFilter();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 218, 243, 255),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.only(
                                                  top: 15, bottom: 15)),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 51, 185, 247)),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          provider.runFilter();
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 51, 185, 247),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.only(
                                                top: 15, bottom: 15)),
                                        child: const Text(
                                          'Apply',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const CustomBox()),
              ],
            ),
          ),
          Consumer<TransactionFilterProvider>(
            builder: (context, value, child) {
              if (value.allFilters.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: SizedBox(
                    height: 40.h,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              value.removeFilter(index);
                            },
                            child: filterContainer2(
                                contains: true, text: value.allFilters[index]),
                          ),
                        );
                      },
                      itemCount: value.allFilters.length,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          const Expanded(child: TransactionList())
        ],
      ),
    );
  }

  //   date range picker

  Future datePicker(BuildContext context) async {
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
