import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_purchases/constant.dart';
import 'package:my_purchases/core/Styles.dart';

import 'Desription.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  final CollectionReference Products = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection("favourite");
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(height: AppConstants.height10(context)),
                Center(
                  child: Text(
                    "المنتجات المفضلة",
                    style: Styles.text20bold(context),
                  ),
                ),
                Divider(
                  endIndent: AppConstants.height100(context),
                  color: Colors.grey,
                  thickness: 1.2,
                  indent: AppConstants.height100(context),
                ),
                SizedBox(height: AppConstants.height55(context)),
                StreamBuilder(
                  // تعديل الاستعلام ليقوم بجلب المنتجات التي تحتوي على favourite = true فقط.
                  stream: Products.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('حدث خطأ أثناء جلب البيانات');
                    }
            
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
            
                    // إذا كانت القائمة فارغة، يمكنك عرض رسالة بديلة
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('لا توجد منتجات مفضلة حالياً',style: Styles.text22bold(context),));
                    }
            
                    final ProductDoc = snapshot.data!.docs;
                    return GridView.builder(
                      itemCount: ProductDoc.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.55,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Description(
                                  title:'${ProductDoc[index]["name"]}' ,
                                  description: '${ProductDoc[index]["desription"]}',
                                  image: '${ProductDoc[index]["Image"]}',
                                  price: '${ProductDoc[index]["price"]}',
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: AppConstants.height300(context),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              double currentPosition = _scrollController.position.pixels;

                                              // تحديث القيمة في Firestore بدون setState
                                              await Products.doc(ProductDoc[index]['id']).delete();
            
                                              // استخدام Future.delayed للتأكد من أن واجهة المستخدم قد اكتملت
                                              Future.delayed(const Duration(milliseconds: 200), () {
                                                _scrollController.jumpTo(currentPosition);
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.favorite,
                                              color:  Colors.red,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '50%',
                                              style: Styles.text20(context).copyWith(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Image(
                                        image: NetworkImage('${ProductDoc[index]["Image"]}'),
                                        height: AppConstants.height90(context),
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ProductDoc[index]['name'],
                                              style: Styles.text20(context).copyWith(color: Colors.black, fontSize: 25),
                                            ),
                                            SizedBox(height: AppConstants.height30(context)),
                                            Text(
                                              '${ProductDoc[index]['price']} جنية مصري ',
                                              textAlign: TextAlign.right,
                                              style: Styles.text20(context).copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: AppConstants.height30(context)),
                                          ],
                                        ),
                                      ),
                                    ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
