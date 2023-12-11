import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyTile extends StatelessWidget {
  const EmptyTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Container(
            margin: EdgeInsets.only(top: 50.h),
            height: 150.h,
            child: const Image(image: AssetImage('assets/empty.png'))),
        const Gap(30),
        Text(
          'Nothing here yet',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        )
      ]),
    );
  }
}
