import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:my_purchases/Screens/Home/Widget/Desription.dart';

import '../../../const.dart';
import '../../../constant.dart';
import '../../../core/Styles.dart';
import 'DesripeRowHome.dart';
import 'TextFormSearch.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {
  // تعريف قائمة الفئات
  List<CategoryModel> Category = [
    CategoryModel(
        onpressed: () {},
        title: 'رياضية',
        image: const AssetImage('assets/Images/sports.jpg')),
    CategoryModel(
        onpressed: () {},
        title: 'رجال',
        image: const AssetImage('assets/Images/mens_clothing_1f6198db54.png')),
    CategoryModel(
        onpressed: () {},
        title: 'نساء',
        image: const AssetImage('assets/Images/women.jpg')),
    CategoryModel(
        onpressed: () {},
        title: 'اطفال',
        image: const AssetImage('assets/Images/kides.jpg')),
    CategoryModel(
        onpressed: () {},
        title: 'احذية',
        image: const AssetImage('assets/Images/shoes.png')),
  ];

  // Collection references
  final CollectionReference productsCollection = FirebaseFirestore.instance.collection('Add');
  final CollectionReference favouriteCollection = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("favourite");

  late ScrollController _scrollController;
  bool favouritebool = false;

  // إضافة متغيرات للبحث
  TextEditingController searchController = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // تحديث الداتا عند الكتابة في حقل البحث
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose(); // التخلص من المتحكم
    super.dispose();
  }

  // إضافة منتج إلى المفضلة
  Future<void> addToFavourite(DocumentSnapshot product) async {
    final productId = product.id;
    final productData = product.data() as Map<String, dynamic>;

    await favouriteCollection.doc(productId).set(productData);
    setState(() {
      favouritebool = true; // تحديث الحالة إلى مفضل
    });
  }

  // إزالة منتج من المفضلة
  Future<void> removeFromFavourite(String productId) async {
    await favouriteCollection.doc(productId).delete();
    setState(() {
      favouritebool = false; // تحديث الحالة إلى غير مفضل
    });
  }

  // التحقق من إذا كان المنتج مفضلاً أم لا
  Future<bool> isFavourite(String productId) async {
    final favouriteDoc = await favouriteCollection.doc(productId).get();
    return favouriteDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Kprimary.withOpacity(0.4),
                    borderRadius: const BorderRadiusDirectional.only(
                        bottomStart: Radius.circular(20),
                        bottomEnd: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DesripeRowHome(),
                    SizedBox(height: AppConstants.height40(context)),
                    // إضافة حقل البحث
                    TextFormSearch(
                      controller: searchController,
                    ),
                    SizedBox(height: AppConstants.height20(context)),
                    Text('الفئات الشعبية', style: Styles.text20(context)),
                    SizedBox(height: AppConstants.height20(context)),
                    SizedBox(
                      height: AppConstants.height90(context),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("عذرًا، هذا الجزء غير متوفر حاليًا. يرجى متابعة التحديثات القادمة.")));
                            },
                            child: Container(
                              child: Column(
                                  children: [
                                    CircleAvatar(backgroundImage: Category[index].image),
                                    SizedBox(height: AppConstants.height5(context)),
                                    Text(Category[index].title,
                                        style: Styles.text20(context).copyWith(fontSize: 12)),
                                  ]),
                            ),
                          );
                        },
                        itemCount: Category.length,
                        scrollDirection: Axis.horizontal,
                        itemExtent: AppConstants.height70(context),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                        Text('المنتجات', style: Styles.text20bold(context)),



                    SizedBox(height: AppConstants.height40(context)),
                    // StreamBuilder لعرض المنتجات
                    StreamBuilder(
                      // تحديث Stream ليقوم بالتصفية حسب نص البحث
                      stream: productsCollection
                          .where("name", isGreaterThanOrEqualTo: searchText)
                          .where("name", isLessThanOrEqualTo: "$searchText\uf8ff")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('حدث خطأ ما');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('لا توجد منتجات حالياً', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          );
                        }

                        final productDocs = snapshot.data!.docs;

                        return GridView.builder(
                          itemCount: productDocs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.55,
                          ),
                          itemBuilder: (context, index) {
                            final product = productDocs[index];
                            final productId = product.id;
                            return FutureBuilder<bool>(
                              future: isFavourite(productId),
                              builder: (context, snapshot) {
                                final isFav = snapshot.data ?? false;

                                return GestureDetector(
                                  onTap: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => Description(
                                     title:product["name"] ,
                                       image: product["Image"],
                                       description: product['desription'],
                                       price: product['price']
                                   ),));
                                  },
                                  child: SizedBox(
                                    height: 300,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(color: Colors.grey.shade100),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      if (isFav) {

                                                        await removeFromFavourite(productId);
                                                      } else {
                                                        await addToFavourite(product);
                                                      }

                                                    },
                                                    icon: Icon(
                                                      Icons.favorite,
                                                      color: isFav ? Colors.red : Colors.grey,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                        color: Colors.amber,
                                                        borderRadius: BorderRadius.circular(20)),
                                                    child:const Text(
                                                      '50%',
                                                      style: TextStyle(color: Colors.black, fontSize: 15),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Image(
                                                image: NetworkImage('${product["Image"]}'),
                                                height: 90,
                                                width: double.infinity,
                                                fit: BoxFit.fill,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration: const BoxDecoration(color: Colors.white),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(product['name'],
                                                        style: const TextStyle(color: Colors.black, fontSize: 25)),
                                                    const SizedBox(height: 30),
                                                    Text('${product['price']}جنية مصري ',
                                                        textAlign: TextAlign.right,
                                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
                                                    const SizedBox(height: 30),
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
                        );
                      },
                    )
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


class CategoryModel {
  final VoidCallback onpressed;
  final String title;
  final ImageProvider image;

  CategoryModel({required this.onpressed, required this.title, required this.image});
}
/*
يستخدمان معًا لتصفية البيانات بناءً على نطاق معين من النصوص. لفهم وظيفتهما بالتفصيل، دعنا نشرحهما بشكل أوضح:

1. .where("name", isGreaterThanOrEqualTo: searchText)
هذا الشرط يستخدم لتحديد نقطة البداية للبحث في القيم النصية في الحقل name.
isGreaterThanOrEqualTo يقوم بتصفية جميع العناصر التي تكون قيمتها في الحقل name أكبر أو تساوي نص البحث (searchText).
مثلاً، إذا كان searchText هو "abc", فسيقوم Firestore بتصفية كل المستندات التي تبدأ بحرف "a" أو بعدها في الترتيب الأبجدي (مثل "abc", "abd", "b", "c", وهكذا).
2. .where("name", isLessThanOrEqualTo: "$searchText\uf8ff")
هذا الشرط يستخدم لتحديد نقطة النهاية للبحث.
isLessThanOrEqualTo يقوم بتصفية جميع العناصر التي تكون قيمتها في الحقل name أقل أو تساوي النص "$searchText\uf8ff".
الحرف \uf8ff هو أحد أعلى الرموز في ترميز Unicode، ويستخدم هنا لضمان أن أي نص يبدأ بـ searchText سيتم تضمينه في النطاق.
مثال عملي:
لنفترض أن لدينا بعض العناصر في قاعدة البيانات بالحقل name مثل:

"apple"
"banana"
"cherry"
"date"
"grape"
إذا كان searchText هو "ap"، فإن الشرطين معًا:
الشرط الأول: .where("name", isGreaterThanOrEqualTo: "ap") سيشمل كل العناصر التي تبدأ بـ "ap" أو أكبر في الترتيب الأبجدي، مثل: "apple", "banana", "cherry".
الشرط الثاني: .where("name", isLessThanOrEqualTo: "ap\uf8ff") سيشمل جميع العناصر التي تبدأ بـ "ap"، مثل "apple"، ولن يشمل "banana" أو أي عنصر آخر بعد "ap" في الترتيب الأبجدي.
النتيجة النهائية:
باستخدام الشرطين معًا، سيتم تحديد نطاق البحث بدقة لعرض العناصر التي تبدأ بنص البحث (searchText). وفي مثالنا، النتيجة ستكون ["apple"] فقط.
لماذا يتم استخدام \uf8ff؟
الحرف \uf8ff في ترميز Unicode هو حرف مرتفع للغاية، ويتم استخدامه هنا لضمان تضمين جميع النصوص التي تبدأ بنص البحث (searchText) في نطاق البحث، حتى لو كان هناك نصوص أخرى تأتي بعد ذلك النص في الترتيب الأبجدي.

مثلاً، إذا كان نص البحث هو "app"، فوجود \uf8ff يضمن تضمين "apple", "application", و "appliance" في النتائج.

تلخيص:
الشرطان:

isGreaterThanOrEqualTo: searchText: يحدد نقطة البداية للنصوص التي تبدأ بـ searchText أو بعدها.
isLessThanOrEqualTo: "$searchText\uf8ff": يحدد نقطة النهاية للنصوص التي تبدأ بـ searchText فقط، مما يضمن شمول جميع النصوص المطابقة.
بهذا، يتم إنشاء نطاق بحث يغطي كل النصوص التي تبدأ بالكلمة المحددة في searchText.*/
