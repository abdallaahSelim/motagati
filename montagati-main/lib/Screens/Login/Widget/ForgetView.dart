import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_purchases/Screens/Login/Widget/DesripeApp.dart';
import 'package:my_purchases/core/Widget/textformfield.dart';

import '../../../constant.dart';
import '../../../core/Styles.dart';
import '../../../core/Widget/Custombutton.dart';

class ForgetView extends StatefulWidget {
  const ForgetView({super.key});

  @override
  State<ForgetView> createState() => _ForgetViewState();
}

class _ForgetViewState extends State<ForgetView> {
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Form(
              autovalidateMode: autovalidateMode,
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DesripeApp(),
                  Text(
                    'برجاء كتابة البريد الالكتروني لتعديل علي كلمة المرور',
                    style: Styles.text20grey(context),
                  ),
                  SizedBox(
                    height: AppConstants.height20(context),
                  ),
                  Customtitle(context, 'البريد الالكتروني'),
                  SizedBox(
                    height: AppConstants.height8(context),
                  ),
                  textFormField(
                    enable: true,
                    obsure: false,
                    controller: email,
                    onchanged: (value) {
                      email.text = value;
                    },
                    title: 'xxx@gmail.com',
                  ),
                  SizedBox(
                    height: AppConstants.height30(context),
                  ),
                  Custombutton(
                    title: 'تعديل كلمة المرور',
                    onpressed: () async {
                      if (formKey.currentState!.validate()) {
          
                FirebaseAuth.instance
            .sendPasswordResetEmail(email: email.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'لقد تم إرسال رسالة إليك عبر البريد الإلكتروني لإدخال كلمة مرور جديدة')));
                await Future.delayed(const Duration(seconds: 8), () {});
                Navigator.pushReplacementNamed(context, '/');
          
                      } else {
                        autovalidateMode = AutovalidateMode.always;
                        setState(() {
                          
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: AppConstants.height40(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Align Customtitle(BuildContext context, String title) {
    return Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: Styles.text20bold(context),
        ));
  }
}
