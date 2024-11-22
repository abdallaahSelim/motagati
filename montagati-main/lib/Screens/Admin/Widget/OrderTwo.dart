import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_purchases/Screens/Admin/Widget/OrderThree.dart';

import '../../../core/Styles.dart';


class OrderTwo extends StatefulWidget {
  const OrderTwo({super.key,required this.uid});
final String uid;
  @override
  State<OrderTwo> createState() => _OrderTwoState();
}

class _OrderTwoState extends State<OrderTwo> {


  @override
  Widget build(BuildContext context) {
    final CollectionReference paymentCollection =
    FirebaseFirestore.instance.collection('Payment').doc(widget.uid).collection("payments");
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    const Text(
                      "الطلبات",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
                const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: paymentCollection.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'حدث خطأ ما',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'لا توجد عمليات دفع مسجلة حالياً',
                            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      final paymentDocs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: paymentDocs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>OrderThree(uid: paymentDocs[index]["uid"], id: paymentDocs[index].id,) ),);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(

                                children: [Expanded(
                                  flex:2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("رقم تلفون: ",style: Styles.text20(context).copyWith(color: Colors.black,fontSize: 16),),
                                            const SizedBox(width: 2,),
                                            Text(paymentDocs[index]["phone"],style: Styles.text20(context).copyWith(color: Colors.black,fontSize: 16),),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        // عرض بيانات المستخدم إذا كانت موجودة
                                        Row(
                                          children: [
                                            Text("سعر العملية: ",style: Styles.text20(context).copyWith(color: Colors.black,fontSize: 16),),
                                            const SizedBox(width: 2,),
                                            Text("${paymentDocs[index]["total"]} جنية مصري",style: Styles.text20(context).copyWith(color: Colors.black,fontSize: 16),),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text("العملية: ",style: Styles.text20(context).copyWith(color: Colors.black,fontSize: 16),),
                                            const SizedBox(width: 2,),
                                            Text(paymentDocs[index]["process"],
                                                style: Styles.text20(context)
                                                    .copyWith(color:
                                                paymentDocs[index]["process"] == "نجاح"
                                                    ? Colors.green // اللون الأخضر لحالة النجاح
                                                    : paymentDocs[index]["process"] == "مرفوض"
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
                                    child: Image.network(paymentDocs[index]["image"],
                                      height: 60,

                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
