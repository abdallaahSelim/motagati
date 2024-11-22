import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_purchases/const.dart';

import '../../../constant.dart';
import 'RowCustomButton.dart';
import 'Update profile.dart';



class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String? Phone;
  String? UserName;
  String? adress;
  var imageUrl;
  void Information() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        UserName = documentSnapshot['username'];
        imageUrl = documentSnapshot['Image'];
        Phone = documentSnapshot['phone'];
        adress=documentSnapshot['Adress'];
      });
    });
  }

  @override
  void initState() {

    Information();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20, right: 20, bottom: 20, top: 13),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [

                imageUrl == null
                    ? const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/Images/person.jpg'),
                )
                    : CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    imageUrl!,
                  ),
                ),


                SizedBox(height: AppConstants.height30(context)),
                itemProfile('الاسم', '${UserName ?? ''}',
                  CupertinoIcons.person,
                      () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return  AlertDialog(
                            title:const Text("الاسم"),
                            content:
                            Text(UserName!, style: const TextStyle(
                                color: Kprimary, fontSize: 15),),
                          );
                        });
                  },
                ),
                const SizedBox(height: 10),
                itemProfile('العنوان', '${adress ?? ''}',
                  CupertinoIcons.location,
                      () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return  AlertDialog(
                            title:const Text("العنوان"),
                            content:
                            Text(adress==null?"برجاء قم بتحديث البيانات ":adress!, style: const TextStyle(
                                color: Kprimary, fontSize: 15),),
                          );
                        });
                  },
                ),
                const SizedBox(height: 10),
                itemProfile('رقم الهاتف', '${ Phone ?? ''}',
                  CupertinoIcons.phone,
                      () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return  AlertDialog(
                            title:const Text("رقم الهاتف"),
                            content:
                            Text(Phone!, style: const TextStyle(
                                color: Kprimary, fontSize: 15),),
                          );
                        });
                  },
                ),
                const SizedBox(height: 10),
                itemProfile(
                  'البريد الالكتروني',
                    '${FirebaseAuth.instance.currentUser!.email ?? ''}',
                  CupertinoIcons.mail
                  , () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  AlertDialog(
                          title:const Text("البريد الالكتروني"),
                          content:
                          Text(FirebaseAuth.instance.currentUser!.email!, style: const TextStyle(
                              color: Kprimary, fontSize: 15),),
                        );
                      });
                },
                ),
                const SizedBox(
                  height:20,
                ),
                RowCustomButton(
                  title1: 'تسجيل الخروج',
                  onpressed1: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  title2: 'تعديل البيانات',
                  onpressed2: () {
                    Navigator.push(context,MaterialPageRoute(builder:(context) =>UpdateProfile(docid:  FirebaseAuth.instance.currentUser!.uid,),));

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  itemProfile(String title, String subtitle, IconData iconData,
      void Function() onpressed) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Kprimary.withOpacity(.1),
                spreadRadius: 1,
                blurRadius: 10)
          ]),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: IconButton(onPressed: onpressed,
            icon: Icon(Icons.arrow_forward, color: Colors.grey.shade400)),
        tileColor: Colors.white,
      ),
    );
  }
}