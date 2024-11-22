import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_purchases/Screens/Admin/Widget/OrderTwo.dart';
import 'package:my_purchases/Screens/Admin/Widget/OrderThree.dart';


class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final CollectionReference paymentCollection =
  FirebaseFirestore.instance.collection('Payment');

  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('Users');

  Map<String, Map<String, dynamic>> userDataMap = {}; // تخزين بيانات المستخدمين باستخدام خريطة

  @override
  Widget build(BuildContext context) {
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
                          var paymentData = paymentDocs[index].data() as Map<String, dynamic>;
                          var userId = paymentData['uid'];

                          // إذا كانت بيانات المستخدم غير موجودة، نحصل عليها
                          if (!userDataMap.containsKey(userId)) {
                            usersCollection.doc(userId).get().then((userDoc) {
                              if (userDoc.exists) {
                                var userData = userDoc.data() as Map<String, dynamic>;
                                setState(() {
                                  userDataMap[userId] = {
                                    'username': userData['username'],
                                    'phone': userData['phone'],
                                    'adress': userData['Adress'],
                                  };
                                });
                              } else {
                                // إضافة بيانات فارغة إذا لم يكن المستخدم موجودًا
                                setState(() {
                                  userDataMap[userId] = {
                                    'username': 'غير متوفر',
                                    'phone': 'غير متوفر',
                                    'adress': 'غير متوفر',
                                  };
                                });
                              }
                            });
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderTwo(uid:paymentData['uid'] ),));
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text("البريد الالكتروني :"),
                                      const SizedBox(width: 4,),
                                      Text(paymentData["email"]),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // عرض بيانات المستخدم إذا كانت موجودة
                                  if (userDataMap.containsKey(userId)) ...[
                                    Row(
                                      children: [
                                        const Text("اسم المستخدم :"),
                                        const SizedBox(width: 4,),
                                        Text(userDataMap[userId]?['username'] ?? 'غير متوفر'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("رقم تلفون :"),
                                        const SizedBox(width: 4,),
                                        Text(userDataMap[userId]?['phone'] ?? 'غير متوفر'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("عنوان مستخدم :"),
                                        const SizedBox(width: 4,),
                                        Text(userDataMap[userId]?['adress'] ?? 'غير متوفر'),
                                      ],
                                    ),
                                  ],
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
