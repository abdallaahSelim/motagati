
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constant.dart';
import '../../../core/Styles.dart';
import '../../../core/Widget/Custombutton.dart';

class OrderThree extends StatefulWidget {
  const OrderThree({super.key, required this.uid, required this.id});
  final String uid;
  final String id;

  @override
  State<OrderThree> createState() => _OrderThreeState();
}

class _OrderThreeState extends State<OrderThree> {
  final CollectionReference PaymentCollection =
  FirebaseFirestore.instance.collection('Payment');

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.width5(context)),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      "تأكيد الطلب",
                      style: Styles.text22bold(context),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppConstants.height30(context)),
                // استخدام DocumentSnapshot لعرض بيانات المستخدم
                Expanded(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: PaymentCollection.doc(widget.uid).collection("payments").doc(widget.id).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('حدث خطأ ما'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(child: Text('لا توجد عمليات حالياً'));
                      }

                      // الحصول على بيانات العملية
                      final productDoc = snapshot.data!;
                      final products = productDoc["products"] ?? [];

                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  Text("اسم المنتج : ", style: Styles.text22bold(context)),
                                  Text("${product["name"]}", style: Styles.text22bold(context)),
                                ],
                              ),
                              SizedBox(height: AppConstants.height15(context)),
                              Row(
                                children: [
                                  Text("الكمية : ", style: Styles.text22bold(context)),
                                  Text("${product["quantity"]}", style: Styles.text22bold(context)),
                                ],
                              ),
                              SizedBox(height: AppConstants.height15(context)),
                              const Divider(height: 2, color: Colors.white),

                            ],
                          );
                        },
                      );
                    },
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Custombutton(
                        onpressed: () {
                          PaymentCollection.doc(widget.uid).collection("payments").doc(widget.id).update(
                              {'process': "نجاح",});
                          Navigator.pop(context);
                        },
                        title: "تأكيد الطلب",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Custombutton(
                        onpressed: () {
                          PaymentCollection.doc(widget.uid).collection("payments").doc(widget.id).update(
                              {'process': "مرفوض",});
                          Navigator.pop(context);
                        },
                        title: "رفض الطلب",
                      ),
                    ),
                  ],
                ),
           const     SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
