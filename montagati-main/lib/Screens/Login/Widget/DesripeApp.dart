 import 'package:flutter/material.dart';

import '../../../constant.dart';
import '../../../core/Styles.dart';

class DesripeApp extends StatelessWidget {
  const DesripeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        SizedBox(height: AppConstants.height30(context),),
        Text('مرحبا بك, مشترياتي 😎',style: Styles.text20bold(context),),
        SizedBox(height: AppConstants.height30(context),),
      ],
    );
  }
}
