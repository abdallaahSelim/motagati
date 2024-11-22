import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_purchases/Screens/Login/Manager/CubitSigin.dart';
import 'package:my_purchases/Screens/Login/Manager/StateSigin.dart';

import '../../../constant.dart';
import '../../../core/Styles.dart';
import '../../../core/Widget/Custombutton.dart';
import '../../../core/Widget/textformfield.dart';
import 'CustomRow.dart';
import 'DesripeApp.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  bool Obsure = true;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigInCubit,SiginState>(builder: (context, state) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child:    Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child:SingleChildScrollView(

                child :Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const   DesripeApp(),
                      Text('اكتب بيانات الحساب لتسجيل الدخول',style: Styles.text20grey(context),)
                      , SizedBox(height: AppConstants.height30(context),),
                      Customtitle(context,'البريد الالكتروني'),
                      SizedBox(height: AppConstants.height8(context),)
                      , textFormField(
                        enable: true,
                        obsure: false,
                        controller: email,
                        onchanged: (value) {
                          email.text=value;
                        },
                        title: 'xxx@gmail.com',
                      ),
                      SizedBox(
                        height: AppConstants.height30(context),
                      ),
                      Customtitle(context,'كلمة المرور'),
                      SizedBox(height: AppConstants.height8(context),),
                      textFormField(
                          enable: true,
                        max: 1,
                        controller: password,
                        onchanged: (value) {
                          password.text=value;
                        },
                        obsure: Obsure,
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
                            ))
                      ),
                      SizedBox(
                        height: AppConstants.height30(context),
                      ),
                      Custombutton(
                        title: 'تسجيل الدخول',
                        onpressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<SigInCubit>(context)
                                .Login(email: email.text, password: password.text);
                          }
                          else{
                            autovalidateMode = AutovalidateMode.always;
                            setState(() {

                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: AppConstants.height10(context),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, 'Forget');
                            },
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: Styles.text20grey(context),
                            ),
                          )),
                      SizedBox(height: AppConstants.height40(context),),
                      CustomRow(title: "لم يكن لديك حساب؟", navigate: 'تسجيل حساب',onpressed: () {
                        Navigator.pushReplacementNamed(context, 'Register');
                      },)
                    ],
                  ),
                ),
              )


          ),


      );
    }, listener: (context, state) {
      if(state is LoadingState){
        startLoading();
      }
     else if (state is SuccessState) {
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot['isAdmin'] == true) {
              Navigator.pushReplacementNamed(context, 'Admin');
            } else {
              Navigator.pushReplacementNamed(context, 'Home');
            }
          });
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'تفعيل الحساب',
            desc:
            "يرجى الذهاب إلى بريدك الإلكتروني والنقر على رابط التحقق من البريد الإلكتروني لتفعيل حسابك",
          ).show();
        }
      } else if (state is FailureState) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: state.errorMessage,
        ).show();
      }
    },
    );
  }

  Align Customtitle(BuildContext context,String title) {
   return Align(alignment: Alignment.centerRight,child: Text(title,style: Styles.text20bold(context),));
  }
  void startLoading() {
    FocusScope.of(context).unfocus();
    // بدء عملية التحميل هنا
  }
}

