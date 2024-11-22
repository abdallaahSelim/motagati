

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../../../const.dart';
import '../../../constant.dart';
import '../../../core/Styles.dart';
import '../../../core/Widget/textformfield.dart';

class UpdateProductid extends StatefulWidget {
  const UpdateProductid({
    super.key,
    required this.docid
  });
  final String docid;
  @override
  State<UpdateProductid> createState() => _UpdateProductidState();
}

class _UpdateProductidState extends State<UpdateProductid> {
  @override
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Add')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        imageUrl = documentSnapshot['Image'] as String;
        name = documentSnapshot['name'] as String;
        price=documentSnapshot['price'] as String;
        desription = documentSnapshot['desription'] as String;
      });
    });

    super.initState();
  }

  CollectionReference category = FirebaseFirestore.instance.collection('Add');

  GlobalKey<FormState> formKey = GlobalKey();
  final ImagePicker _imagePicker = ImagePicker();
  var imageUrl;
  TextEditingController namenewcontroller = TextEditingController();
  TextEditingController pricenewcontroller = TextEditingController();
  TextEditingController descriptionnewcontroller = TextEditingController();
  var name;
  var desription;
  var price;
  Future<void> pickImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (res != null) {
        await uploadFile(File(res.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to pick image: $e"),
        ),
      );
    }
  }

  uploadFile(File selectedFile) async {
    EasyLoading.show(status: "انتظر من فضلك...");
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('files')
        .child(selectedFile.path.split('/').last);
    try {
      var uploadTask = await ref.putFile(selectedFile);
      var downloadUrl = await ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Success"),
              content:
              Text('لقد تم إنشاء صورة ملفك الشخصي بنجاح'),
            );
          });
      await category.doc(widget.docid).update(
          {'Image': imageUrl});
      setState(() {
        EasyLoading.dismiss();
      });

    } on FirebaseException catch (e) {
      setState(() {
        EasyLoading.dismiss();
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("فشل تحميل المهمة"),
              content: Text(e.toString()),
            );
          });
    }
  }

  editcategry() async {
    if (formKey.currentState!.validate()) {
      try {
        EasyLoading.show(status: "please wait...");
        setState(() {});
        await category.doc(widget.docid).update(
            {'name': name, 'price': price,'desription':desription});
        EasyLoading.dismiss();
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('تم تعديل البيانات بنجاح')));
        await Future.delayed(const Duration(seconds:2), () {});
        Navigator.pop(context);
      } catch (e) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('حاول مرة أخرى لاحقًا')));
      }
    }
    else{
      autovalidateMode = AutovalidateMode.always;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: Column(
                    children: [

                      const Text(
                        'تعديل المنتج',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: AppConstants.height30(context),
                      ),
                      imageUrl == null
                          ? CircleAvatar(
                        radius: 70,
                        backgroundImage:const AssetImage('assets/Images/mens_clothing_1f6198db54.png'),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                onPressed: pickImage,
                                icon:const Icon(Icons.camera_alt,color: Kprimary,))),
                      )
                          : CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(imageUrl!),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                onPressed: pickImage,
                                icon:const Icon(Icons.camera_alt))),
                      ),
                      SizedBox(
                        height: AppConstants.height30(context),
                      ),
                      textFormField(
                        enable: true,
                        obsure: false,
                        controller:namenewcontroller ,
                        onchanged:(value) {
                          name=value;
                        } ,
                        title: 'اسم المنتج',


                      ),
                      SizedBox(
                        height: AppConstants.height15(context),
                      ),
                      textFormField(
                          enable: true,
                          keyboard: TextInputType.number,
                          obsure: false,
                          controller: pricenewcontroller,
                          onchanged:(value) {
                            price=value;
                          } ,
                          title: 'سعر المنتج',
                         ),
                      SizedBox(
                        height: AppConstants.height15(context),
                      ),
                      textFormField(
                          enable: true,
                          title: 'وصف المنتج',
                          obsure: false,
                          max: 4,
                          controller: descriptionnewcontroller,
                          onchanged:(value) {
                            desription=value;
                          } ,
                       ),
                      SizedBox(
                        height: AppConstants.height30(context),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Kprimary,
                                  borderRadius: BorderRadius.circular(20)),
                              child: MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                      'الرجوع للخلف',
                                      style: Styles.text20(context)
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: AppConstants.width15(context),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Kprimary,
                                  borderRadius: BorderRadius.circular(20)),
                              child: MaterialButton(
                                  onPressed: () async {
                                    editcategry();
                                  },
                                  child: Text(
                                      'حفظ البيانات',
                                      style: Styles.text20(context)
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
