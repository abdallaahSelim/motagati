
import 'package:flutter/material.dart';
import 'package:my_purchases/const.dart';

import '../../../constant.dart';
import '../../../core/Styles.dart';


class RowCustomButton extends StatelessWidget {
  const RowCustomButton({
    super.key,
    required this.title1,
    required this.title2,
    required this.onpressed1,
    required this.onpressed2,
  });
  final String title1;
  final void Function()? onpressed1;
  final void Function()? onpressed2;
  final String title2;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 50,
            decoration: BoxDecoration(
                color: Kprimary, borderRadius: BorderRadius.circular(20)),
            child: MaterialButton(
                onPressed: onpressed1,
                child: Text(
                  title1,
                  style: Styles.text20(context)
                      .copyWith(color: Colors.white, fontSize: 15),
                )),
          ),
        ),
        SizedBox(
          width: AppConstants.width15(context),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 50,
            decoration: BoxDecoration(
                color: Kprimary, borderRadius: BorderRadius.circular(20)),
            child: MaterialButton(
                onPressed: onpressed2,
                child: Text(
                  title2,
                  style: Styles.text20(context)
                      .copyWith(color: Colors.white, fontSize: 18),
                )),
          ),
        ),
      ],
    );
  }
}
