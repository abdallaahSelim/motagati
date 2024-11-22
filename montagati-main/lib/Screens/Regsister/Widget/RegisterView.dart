import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_purchases/Screens/Login/Widget/DesripeApp.dart';
import 'package:my_purchases/Screens/Regsister/Manager/CubitSignup.dart';
import 'package:my_purchases/Screens/Regsister/Manager/StateSignup.dart';

import '../../../constant.dart';
import '../../../core/Styles.dart';
import '../../../core/Widget/Custombutton.dart';
import '../../../core/Widget/textformfield.dart';
import '../../Login/Widget/CustomRow.dart';
import '../Models/UserModel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController email = TextEditingController();
  TextEditingController UserName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  bool Obsure = true;
  int _number = 0;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigUpCubit,SigupState>(builder: (context, state) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child:
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child:SingleChildScrollView(
                  reverse: true,
                  child: Form(
                  autovalidateMode: autovalidateMode,
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const   DesripeApp()
                      ,
                      Customtitle(context, 'اسم المستخدم'),
                      SizedBox(
                        height: AppConstants.height8(context),
                      ),
                       textFormField(
                         enable: true,
                        title: 'أحمد وائل',
                        obsure: false,
                        controller: UserName,
                        onchanged: (value) {
                          UserName.text=value;
                        },
                      ),
                      SizedBox(
                        height: AppConstants.height20(context),
                      ),
                      Customtitle(context, 'رقم التلفون'),
                      SizedBox(
                        height: AppConstants.height8(context),
                      ),
                       textFormField(
                        obsure: false,
                         enable: true,
                        controller: phone,
                         counter:'$_number/11',
                        onchanged: (value) {
                          phone.text=value;
                           setState(() {
                        _number = value.length;
                      });
                        },
                        title: '012555497823',
                          inputformat: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly, // للسماح بالأرقام فقط
                      LengthLimitingTextInputFormatter(
                          11), // لتحديد الحد الأقصى لعدد الأرقام
                    ],
                        keyboard: TextInputType.phone,
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
                          email.text=value;
                        },
                        title: 'xxx@gmail.com',
                      ),
                      SizedBox(
                        height: AppConstants.height20(context),
                      ),
                      Customtitle(context, 'كلمة المرور'),
                      SizedBox(
                        height: AppConstants.height8(context),
                      ),
                      textFormField(
                          enable: true,
                        max: 1,
                        obsure: Obsure,
                        controller: password,
                        onchanged: (value) {
                          password.text=value;
                        },
                        title: '********',
                        iconata: IconButton(
                            onPressed: () {
                              setState(() {
                                Obsure = !Obsure;
                              });
                            },
                            icon: Obsure
                                ? Icon(
                              Icons.visibility_off,
                              color: Colors.grey[400],
                            )
                                : Icon(
                              Icons.visibility,
                              color: Colors.grey[400],
                            ))),
                      SizedBox(
                        height: AppConstants.height20(context),
                      ),
                       Custombutton(
                        title: 'تسجيل حساب',
                        onpressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<SigUpCubit>(context).Regsister(
                                email: email.text, password: password.text);
                          }
                          else{
                            autovalidateMode = AutovalidateMode.always;
                            setState(() {

                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: AppConstants.height30(context),
                      ),
                      CustomRow(
                        title: "املك حساب بالفعل؟",
                        navigate: 'تسجيل دخول',
                        onpressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                      )
                    ],
                  ),
                ),
              )

          ),

      );
    }, listener: (context, state) {
      if (state is LoadingState) {}
      if (state is SuccessState) {
        UserModel userModel = UserModel(
            uId: FirebaseAuth.instance.currentUser!.uid,
            username: UserName.text,
            email: email.text,
            phone: phone.text,
            userDeviceToken: '',
            isAdmin: false,
            isActive: true,
            Adress: null,
            createdOn: DateTime.now(), Image: null,

         );
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(userModel.toMap());
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'تم إنشاء حساب جديد الرجاء الذهاب إلى البريد الإلكتروني وتفعيل الحساب')));
        Navigator.pushReplacementNamed(context, '/');
      } else if (state is FailureState) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: state.errorMessage,
        ).show();
      }}
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
