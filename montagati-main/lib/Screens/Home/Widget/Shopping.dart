import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_purchases/core/Styles.dart';
import 'package:my_purchases/core/Widget/Custombutton.dart';

import '../../../constant.dart';
import 'Payment.dart';

class Shopping extends StatefulWidget {
  const Shopping({super.key});

  @override
  State<Shopping> createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  final CollectionReference cartCollection = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Cart");

  // إنشاء خريطة لتتبع الكمية لكل عنصر في السلة
  Map<String, int> itemQuantities = {};
  double totalAmount = 0.0;
  List<Map<String, dynamic>> productList = [];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: AppConstants.height10(context)),
                    Center(
                      child: Text("سلة المنتجات", style: Styles.text20bold(context)),
                    ),
                    Divider(
                      endIndent: AppConstants.height100(context),
                      color: Colors.grey,
                      thickness: 1.2,
                      indent: AppConstants.height100(context),
                    ),
                    SizedBox(height: AppConstants.height30(context)),
                    StreamBuilder(
                      stream: cartCollection.snapshots(),
                      builder: (context, snapshot) {
                        // التحقق أولاً من حالة الـ snapshot
                        if (snapshot.hasError) {
                          return const Text('حدث خطأ ما');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        // التحقق من أن البيانات ليست فارغة أو غير موجودة
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('لا توجد منتجات في سلة التسوق حالياً',
                                style: TextStyle(fontSize: 22,color: Colors.white ,fontWeight: FontWeight.bold)),
                          );
                        }

                        // في حال توفر البيانات، يمكننا استخدامها
                        final cart = snapshot.data!.docs;

                        // إعادة تعيين totalAmount في كل مرة يتم فيها بناء الواجهة
                        totalAmount = 0.0;
                        void updateProductList() {
                          productList.clear(); // تفريغ القائمة القديمة
                          itemQuantities.forEach((productId, quantity) {
                            if (quantity > 0) {
                              productList.add({
                                'name': cart.firstWhere((item) => item.id == productId)["title"],
                                'quantity': quantity,
                              });
                            }
                          });
                        }
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cart.length,
                              itemBuilder: (context, index) {
                                // استرجاع القيم الأساسية للمنتج
                                String productId = cart[index].id;
                                double price = double.parse(cart[index]["price"]);

                                // تعيين الكمية الافتراضية إن لم تكن موجودة في الخريطة
                                if (!itemQuantities.containsKey(productId)) {
                                  itemQuantities[productId] = 0;
                                }

                                // الحصول على الكمية الحالية للمنتج
                                int quantity = itemQuantities[productId]!;
                                double totalPrice = quantity * price;

                                // إضافة السعر الحالي إلى السعر الكلي
                                totalAmount += totalPrice; // حساب المبلغ الكلي

                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: AppConstants.height10(context)),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                cart[index]["title"],
                                                style: Styles.text20(context).copyWith(color: Colors.black),
                                              ),
                                              Row(
                                                children: [
                                                  // زر تقليل الكمية
                                                  MaterialButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        itemQuantities[productId] = quantity + 1;
                                                        // تحديث totalAmount بعد زيادة الكمية
                                                        totalAmount += price; // إضافة السعر
                                                        updateProductList();
                                                      });
                                                    },
                                                    child: Text('<',
                                                        style: Styles.text20(context).copyWith(color: Colors.black)),
                                                  ),
                                                  // عرض الكمية الحالية
                                                  Text("$quantity",
                                                      style: Styles.text20(context).copyWith(color: Colors.black)),
                                                  // زر زيادة الكمية
                                                  MaterialButton(
                                                    onPressed: () {
                                                      if (quantity > 0) {
                                                        setState(() {
                                                          itemQuantities[productId] = quantity - 1;
                                                          // تحديث totalAmount بعد تقليل الكمية
                                                          totalAmount -= price; // تقليل السعر
                                                          updateProductList();
                                                        });
                                                      }

                                                    },
                                                    child: Text('>',
                                                        style: Styles.text20(context).copyWith(color: Colors.black)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Image(
                                            image: NetworkImage(cart[index]["image"]),
                                            height: AppConstants.height70(context),
                                            width: AppConstants.width50(context),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: AppConstants.height10(context)),
                                      Row(
                                        children: [
                                          // عرض السعر الإجمالي بناءً على الكمية
                                          Text(
                                            "${totalPrice.toStringAsFixed(2)} جنية مصري",
                                            style: Styles.text20bold(context).copyWith(color: Colors.black),
                                          ),
                                          const Spacer(),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              onPressed: () {
                                                // حذف العنصر من السلة
                                                cartCollection.doc(cart[index].id).delete();
                                                setState(() {
                                                  itemQuantities.remove(productId); // إزالة الكمية من الخريطة
                                                  // تحديث totalAmount بعد حذف العنصر
                                                  totalAmount -= totalPrice;
                                                  updateProductList();
                                                });
                                              },
                                              icon: const Icon(Icons.delete, color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                      onTap: () {
                        if(totalAmount.toStringAsFixed(2)=="0.00"){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('انتا لم تحدد كمية منتح التي تريدها'),backgroundColor: Colors.red,),
                          );
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Payment(
                              total: totalAmount.toStringAsFixed(2), products: productList),));
                        }

                      },
                      child: Custombutton(title: 'دفع ${totalAmount.toStringAsFixed(2)} جنية مصري ')), // استخدام totalAmount هنا
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
