
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_purchases/constant.dart';
import 'package:my_purchases/core/Styles.dart';

import '../../../const.dart';
class Description extends StatefulWidget {
  const Description({
    super.key,
    required this.image,
    required this.description,
    required this.title,
    required this.price,
  });

  final String image;
  final String title;
  final String description;
  final String price;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  // مرجع لمجموعة Cart في Firestore
  final CollectionReference cartCollection = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Cart");

  // دالة لإضافة المنتج إلى سلة التسوق
  Future<void> addToCart() async {
    try {
      await cartCollection.doc(widget.title).set({
        'title': widget.title,
        'image': widget.image,
        'description': widget.description,
        'price': widget.price,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إضافة المنتج إلى السلة بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء إضافة المنتج إلى السلة'),backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.width30(context),
                  vertical: AppConstants.height10(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          widget.title,
                          style: Styles.text20bold(context),
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
                    SizedBox(height: AppConstants.height40(context)),
                    Image.network(
                      widget.image,
                      height: AppConstants.height300(context),
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: AppConstants.height40(context)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "وصف المنتج",
                        style: Styles.text20bold(context),
                      ),
                    ),
                    SizedBox(height: AppConstants.height5(context)),
                    Text(
                      widget.description,
                      style: Styles.text20grey(context),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.width10(context),
                  vertical: AppConstants.height15(context),
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  color: Kprimary.withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "السعر",
                          style: Styles.text20bold(context),
                        ),
                        SizedBox(height: AppConstants.height10(context)),
                        Text(
                          "${widget.price}جنية مصري ",
                          style: Styles.text20(context).copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: addToCart, // استدعاء الدالة عند النقر على الزر
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.width20(context),
                          vertical: AppConstants.height15(context),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "أضف إلى السلة",
                          style: Styles.text20(context),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
