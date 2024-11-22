import 'package:flutter/material.dart';

import '../../../core/Styles.dart';

class DesripeRowHome extends StatelessWidget {
  const DesripeRowHome({super.key});

  @override
  Widget build(BuildContext context) {
    return     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'يوم سعيد في التسوق',
          style: Styles.text20(context)
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          'تطبيق منتجاتي 😎',
          style: Styles.text20(context),
        ),
      ],
    );
  }
}
