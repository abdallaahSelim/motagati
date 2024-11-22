import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_purchases/Screens/Admin/Widget/Add.dart';
import 'package:my_purchases/Screens/Admin/Widget/Orders.dart';
import 'package:my_purchases/Screens/Admin/Widget/Update.dart';
import 'package:my_purchases/Screens/Admin/Widget/Users.dart';
import 'package:my_purchases/core/Widget/textformfield.dart';

import '../../const.dart';
import '../../constant.dart';
import '../../core/Styles.dart';
import '../Home/Widget/DesripeRowHome.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final TextEditingController phone = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // تعريف GlobalKey

  @override
  Widget build(BuildContext context) {
    final CollectionReference phonecollection = FirebaseFirestore.instance.collection('phone');

    List<ModelAdmin> admin = [
      ModelAdmin(
        color: Colors.orange,
        title: 'المستخدمين',
        onpressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Users()));
        },
      ),
      ModelAdmin(color: Colors.lightBlueAccent, title: 'الطلبات', onpressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Orders(),));
      },),
      ModelAdmin(color: Colors.green, title: 'اضافة منتجات', onpressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Add(),));
      },),
      ModelAdmin(color: Colors.red, title: 'تعديل وحذف', onpressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProduct(),));
      },),
    ];

    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: AppConstants.height200(context),
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Kprimary.withOpacity(0.4),
                    borderRadius: const BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(20),
                      bottomEnd: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DesripeRowHome(),
                      SizedBox(height: AppConstants.height40(context),),
                      Center(
                        child: Text(
                          'تطبيق مشترياتي',
                          style: Styles.text20(context),
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        indent: MediaQuery.sizeOf(context).width * 0.35,
                        endIndent: MediaQuery.sizeOf(context).width * 0.36,
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "رقم الهاتف الخاص بعمليات الدفع",
                                    style: Styles.text20(context).copyWith(color: Colors.black),
                                  ),
                                  content: Form(
                                    key: _formKey, // إضافة الـ GlobalKey هنا
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        textFormField(
                                          inputformat: <TextInputFormatter>[
                                            FilteringTextInputFormatter.digitsOnly, // للسماح بالأرقام فقط
                                            LengthLimitingTextInputFormatter(11), // يحدد طول الرقم
                                          ],
                                          title: "ادخل رقم الهاتف",
                                          enable: true,
                                          obsure: false,
                                          keyboard: TextInputType.phone,
                                          controller: phone,

                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Action for cancel button
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      child: Text('الغاء', style: Styles.text20(context).copyWith(color: Colors.black)),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Save phone number to Firestore
                                        if (_formKey.currentState!.validate()) { // التحقق من صحة النموذج
                                          await phonecollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
                                            "phone": phone.text, // استخدم phone.text بدلاً من phone
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم انشاء رقم فودافون كاش جديد")));
                                          Navigator.of(context).pop(); // Close the dialog
                                        }
                                      },
                                      child: Text('تأكيد', style: Styles.text20(context).copyWith(color: Colors.black)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.add, color: Colors.white,),
                        ),
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                  itemCount: admin.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return buildMaterialButton(admin, index, context, color: admin[index].color);
                  },
                ),
                SizedBox(height: AppConstants.height40(context),),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Kprimary),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text('تسجيل خروج', style: Styles.text20(context),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MaterialButton buildMaterialButton(List<ModelAdmin> admin, int index, BuildContext context, {required Color color}) {
    return MaterialButton(
      onPressed: admin[index].onpressed,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.sizeOf(context).width * 0.5,
        height: AppConstants.height120(context),
        padding: EdgeInsets.symmetric(vertical: AppConstants.height30(context), horizontal: AppConstants.width20(context)),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
        child: Text(admin[index].title, style: Styles.text20(context),),
      ),
    );
  }
}

class ModelAdmin {
  final String title;
  final void Function()? onpressed;
  final Color color;

  ModelAdmin({required this.color, required this.title, required this.onpressed});
}
