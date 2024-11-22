
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_purchases/constant.dart';
import 'package:my_purchases/core/Styles.dart';
import 'package:my_purchases/core/Widget/textformfield.dart';

import '../../../core/Widget/Custombutton.dart';



class Payment extends StatefulWidget {
  const Payment({super.key, required this.total, required this.products});
  final String total;
  final List products;

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final ImagePicker _imagePicker = ImagePicker();
  var _image; // لاحتواء الصورة المختارة
  String phoneNumber = ''; // لاحتواء رقم الهاتف
  String vodafoneCashNumber = '';
  @override
  void initState() {
    _fetchVodafoneCashNumber();
    super.initState();
  }
  Future<void> _fetchVodafoneCashNumber() async {
    try {
      final DocumentSnapshot document = await FirebaseFirestore.instance.collection('phone').doc("q9Lraffr9xZWHXwP42o7I1AsLuY2").get();

      if (document.exists) {
        setState(() {
          vodafoneCashNumber = document['phone']; // استرجاع الرقم من الوثيقة
        });
      }
    } catch (e) {
      print('Error fetching phone number: $e');
    }
  }


  final CollectionReference paymentCollection =
  FirebaseFirestore.instance.collection("Payment");

  // دالة لإتمام عملية الدفع
  void _completePayment() async {
    if (_image != null && phoneNumber.isNotEmpty) {
      try {
        // الحصول على وثيقة المستخدم بناءً على uid
        final userDoc = paymentCollection.doc(FirebaseAuth.instance.currentUser!.uid);
final user=userDoc.set({
  "email":FirebaseAuth.instance.currentUser!.email,
  "uid":FirebaseAuth.instance.currentUser!.uid
});
        // إضافة البيانات إلى مجموعة فرعية "payments" لكل مستخدم
        final paymentDoc = await userDoc.collection('payments').add({
          "email": FirebaseAuth.instance.currentUser!.email,
          "uid": FirebaseAuth.instance.currentUser!.uid,
          'total': widget.total,
          'phone': phoneNumber,
          'timestamp': FieldValue.serverTimestamp(),
          "process": "قيد المعالجة",
          'image': _image, // تخزين رابط الصورة في قاعدة البيانات
          'products': widget.products.map((product) => {
            'name': product['name'],
            'quantity': product['quantity'],
          }).toList(),
        });

        // إظهار رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت عملية الدفع بنجاح!')),
        );

        // العودة إلى الشاشة السابقة
        Navigator.pushReplacementNamed(context, "Home");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء إتمام عملية الدفع: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // إظهار رسالة تحذير إذا لم يتم إدخال المعلومات اللازمة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار صورة وإدخال رقم الهاتف'), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.width20(context)),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Text("الدفع", style: Styles.text20bold(context)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back_ios, color: Colors.white, textDirection: TextDirection.ltr),
                          ),
                        ],
                      ),
                      SizedBox(height: AppConstants.height40(context)),
                      Text(
                        "عمليات الدفع المتوفرة حاليا هي فودافوان كاش فقم بدفع من خلال الرقم المتوفر في الشاشة وقم بارفاق صورة عملية الدفع عن طريق اسكرين شوت عند اتمام العملية وايضا الرقم الذي قمت بتحوبل الاموال من خلالة",
                        style: Styles.text20(context).copyWith(fontSize: 15),
                      ),
                      SizedBox(height: AppConstants.height40(context)),
                      Row(
                        children: [
                          Text("قيمة الدفع :", style: Styles.text22bold(context)),
                          const Spacer(),
                          Text("${widget.total} جنية مصري", style: Styles.text22bold(context)),
                          const Spacer()
                        ],
                      ),
                      SizedBox(height: AppConstants.height20(context)),
                      Row(
                        children: [
                          Text("الرقم فودفوان كاش :", style: Styles.text22bold(context)),
                          const Spacer(),
                          Text(vodafoneCashNumber, style: Styles.text22bold(context)),
                          const Spacer()
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1, color: Colors.white70),
                      SizedBox(height: AppConstants.height20(context)),
                      Text("صورة الدفع", style: Styles.text22bold(context)),
                      SizedBox(height: AppConstants.height15(context)),
                      _image == null
                          ? GestureDetector(
                        onTap: pickImage, // استدعاء دالة اختيار الصورة
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: AppConstants.height40(context)),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              const Icon(Icons.cloud_download_outlined, color: Colors.grey),
                              const SizedBox(height: 5),
                              Text("ادخل صورة الدفع", style: Styles.text22(context).copyWith(color: Colors.grey)),
                            ],
                          ),
                        ),
                      )
                          : // عرض الصورة المختارة
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            _image!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: AppConstants.height20(context)),
                      Text("الرقم التلفون", style: Styles.text22bold(context)),
                      SizedBox(height: AppConstants.height15(context)),
                      textFormField(
                        inputformat: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly, // للسماح بالأرقام فقط
                          LengthLimitingTextInputFormatter(11), // لتحديد الحد الأقصى لعدد الأرقام
                        ],
                        title: "الرقم الذي ارسلت منة",
                        enable: true,
                        obsure: false,
                        onchanged: (value) {
                          phoneNumber = value; // تخزين رقم الهاتف
                        },
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0, top: 20),
                      child: GestureDetector(
                        onTap: _completePayment, // استدعاء دالة إتمام الدفع
                        child: const Custombutton(title: 'اتمام عملية الدفع'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (res != null) {
        await uploadFile(File(res.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to pick image: $e"),
        ),
      );
    }
  }

  Future<void> uploadFile(File selectedFile) async {
    EasyLoading.show(status: "انتظر من فضلك...");
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('files')
        .child(selectedFile.path.split('/').last);
    try {
      var uploadTask = await ref.putFile(selectedFile);
      var downloadUrl = await ref.getDownloadURL();
      setState(() {
        _image = downloadUrl;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Success"),
              content: Text('لقد تم إنشاء صورة منتج بنجاح'),
            );
          });
      setState(() {
        EasyLoading.dismiss();
      });
    } on FirebaseException catch (e) {
      setState(() {
        EasyLoading.dismiss();
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("فشل تحميل المهمة"),
              content: Text(e.toString()),
            );
          });
    }
  }
}
