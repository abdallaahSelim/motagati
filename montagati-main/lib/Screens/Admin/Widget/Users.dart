 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_purchases/const.dart';
import 'package:my_purchases/constant.dart';
import 'package:my_purchases/core/Styles.dart';

 class Users extends StatefulWidget {
   const Users({super.key});

   @override
   State<Users> createState() => _UsersState();
 }

 class _UsersState extends State<Users> {
   @override
   Widget build(BuildContext context) {
     final List<Color> colors = [
       Kprimary,
       Colors.orange,
       Colors.green,
     ];
     final CollectionReference users = FirebaseFirestore.instance.collection('Users');

     return StreamBuilder(
       stream: users.snapshots(),
       builder: (context, snapshot) {
         if (snapshot.hasError) {
           return const Text('حدث خطأ ما');
         }

         if (snapshot.connectionState == ConnectionState.waiting) {
           return const Center(child: CircularProgressIndicator());
         }

         // استبعاد المستندات التي تحتوي على اسم مستخدم يساوي "admin"
         final userDocs = snapshot.data!.docs.where((doc) => doc['username'] != 'admin').toList();

         if (userDocs.isEmpty) {
           return const Center(child: Text('لا يوجد مستخدمون مسجلون حالياً'));
         }

         return Directionality(
           textDirection: TextDirection.rtl,
           child: Scaffold(
             appBar: AppBar(
               centerTitle: true,
               backgroundColor: Colors.transparent,
               title: Text(
                 "بيانات المستخدمين",
                 style: Styles.text20(context).copyWith(color: Colors.black, fontWeight: FontWeight.w600),
               ),
             ),
             body: ListView.builder(
               itemCount: userDocs.length,
               itemBuilder: (context, index) {
                 return Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                   child: Container(
                     height: 200,
                     width: double.infinity,
                     decoration: BoxDecoration(
                       color: colors[index % colors.length],
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: Column(
                       children: [
                         SizedBox(height: AppConstants.height10(context)),
                         buildRow(context, title: "اسم المستخدم : ", subtitle: userDocs[index]['username']),
                         buildRow(context, title: "تلفون المستخدم : ", subtitle: userDocs[index]['phone']),
                         buildRow(
                             context,
                             title: "عنوان المستخدم : ",
                             subtitle: userDocs[index]['Adress'] ?? 'غير متوفر حالياً'),
                         buildRow(context, title: "ايميل المستخدم : ", subtitle: userDocs[index]['email']),
                       ],
                     ),
                   ),
                 );
               },
             ),
           ),
         );
       },
     );
   }

   Padding buildRow(BuildContext context, {required String title, required String subtitle}) {
     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             title,
             style: Styles.text22bold(context).copyWith(color: Colors.white),
           ),
           Flexible(
             child: Text(
               subtitle,
               style: Styles.text22(context),
               softWrap: false,
             ),
           ),
         ],
       ),
     );
   }
 }
