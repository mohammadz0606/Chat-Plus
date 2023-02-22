import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/colors.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({
    Key? key,
    required this.image,
    required this.title,
    required this.body,
  }) : super(key: key);
  final String image;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          image,
          fit: BoxFit.cover,
          height: 250.h,
        ),
        SizedBox(height: 15.h),
        Text(
          title,
          style: GoogleFonts.notoSansJavanese(
            color: tabColor,
            fontWeight: FontWeight.bold,
            fontSize: 24.0.sp,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          body,
          style: GoogleFonts.montserrat(
            color: Colors.grey,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
