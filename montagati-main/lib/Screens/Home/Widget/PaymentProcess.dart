
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_purchases/core/Styles.dart';

import '../../../constant.dart';

class PaymentProcess extends StatefulWidget {
  const PaymentProcess({super.key});

  @override
  State<PaymentProcess> createState() => _PaymentProcessState();
}

class _PaymentProcessState extends State<PaymentProcess> {
  final CollectionReference paymentCollection = FirebaseFirestore.instance
      .collection('Payment').doc(FirebaseAuth.instance.currentUser!.uid).collection("payments");


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Center(
                child: Text("حالة الدفع", style: Styles.text22bold(context)),
              ),
              Divider(
                endIndent: AppConstants.height100(context),
                color: Colors.grey,
                thickness: 1.2,
                indent: AppConstants.height100(context),
              ),
              SizedBox(height: AppConstants.height40(context)),
              // استخدام StreamBuilder لاسترجاع البيانات من الـ Firebase
              Expanded(
                child: StreamBuilder(
                  stream: paymentCollection.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('حدث خطأ ما'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('لا توجد عمليات دفع مسجلة حالياً',style: Styles.text22bold(context),));
                    }

                    // إذا كانت هناك بيانات، استعرضها في ListView
                    final ProductDoc = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {

                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: AppConstants.width10(context),
                              vertical: AppConstants.height10(context)),
                          padding: EdgeInsets.all(AppConstants.height10(context)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "رقم تلفون :",
                                          style: Styles.text20(context)
                                              .copyWith(color: Colors.black),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(ProductDoc[index]["phone"],
                                            style: Styles.text20(context)
                                                .copyWith(color: Colors.black)),
                                      ],
                                    ),
                                    SizedBox(height: AppConstants.height10(context)),
                                    Row(
                                      children: [
                                        Text(
                                          "الحالة :",
                                          style: Styles.text20(context)
                                              .copyWith(color: Colors.black),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(ProductDoc[index]["process"],
                                            style: Styles.text20(context)
                                                .copyWith(color:
                                            ProductDoc[index]["process"] == "نجاح"
                                                ? Colors.green // اللون الأخضر لحالة النجاح
                                                : ProductDoc[index]["process"] == "مرفوض"
                                                ? Colors.red // اللون الأحمر لحالة الرفض
                                                : Colors.black, // اللون الأسود لأي حالة أخرى
                                            )

                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child:
                                   Image.network(
                                     ProductDoc[index]["image"],
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.cover,
                                  height: AppConstants.height100(context),
                                  width: AppConstants.width120(context),
                                )

                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
