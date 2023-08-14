import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBox extends StatelessWidget {
  const CustomBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(
              255, 236, 238, 237),
          borderRadius: BorderRadius.circular(6), 
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6), // Shadow color

              
            ),
          ],
        ),
        child: SizedBox(
          width: 35.w,
          height: 37.h,
          child: Padding(
            padding: EdgeInsets.all(4.0.h.w),
            child: const Icon(
              Icons.filter_alt_rounded,
              color: Color.fromARGB(255, 157, 158, 158),
            ),
          ),
        ));
  }
}
