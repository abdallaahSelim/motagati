import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_purchases/Screens/Admin/Widget/UpdateTwo.dart';

import '../../../constant.dart';
import '../../../core/Styles.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  @override
  final CollectionReference product = FirebaseFirestore.instance
      .collection('Add');
  @override
  Widget build(BuildContext context) {
  return Directionality(
      textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    const Text(
                      "تعديل المنتجات",
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
                    const SizedBox(width: 15,)
                  ],
                ),

                SizedBox(height: AppConstants.height40(context)),
                // استخدام StreamBuilder لاسترجاع البيانات من الـ Firebase
                Expanded(
                  child: StreamBuilder(
                    stream: product.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('حدث خطأ ما'));
                      }
            
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
            
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text(
                         "لا توجد منتجات متاحة حاليا",
                          style: Styles.text22bold(context),
                        ));
                      }
            
                      // إذا كانت هناك بيانات، استعرضها في ListView
                      final ProductDoc = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProductid(docid: ProductDoc[index]["id"]),));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: AppConstants.width10(context),
                                  vertical: AppConstants.height10(context)),
                              padding:
                                  EdgeInsets.all(AppConstants.height10(context)),
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
                                              "اسم منتج :",
                                              style: Styles.text20(context)
                                                  .copyWith(color: Colors.black),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(ProductDoc[index]["name"],
                                                style: Styles.text20(context)
                                                    .copyWith(color: Colors.black)),
                                          ],
                                        ),
                                        SizedBox(
                                            height: AppConstants.height10(context)),
                                        Row(
                                          children: [
                                            Text(
                                              "سعر منتج :",
                                              style: Styles.text20(context)
                                                  .copyWith(color: Colors.black),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(ProductDoc[index]["price"],
                                                style: Styles.text20(context)
                                                    .copyWith(color: Colors.black)),
                                          ],
                                        ),
                                        SizedBox(
                                            height: AppConstants.height20(context)),
                                        GestureDetector(
                                            onTap: () {
                                              product.doc(ProductDoc[index].id).delete();
                                            },
                                            child: const Icon(Icons.delete,color: Colors.black,))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Image.network(
                                    ProductDoc[index]["Image"],
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.cover,
                                    height: AppConstants.height100(context),
                                    width: AppConstants.width120(context),
                                  )),
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

    );
  }
}