import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_purchases/constant.dart';
import 'package:my_purchases/core/Styles.dart';
import 'package:my_purchases/core/Widget/Custombutton.dart';
import 'package:my_purchases/core/Widget/textformfield.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  @override
  TextEditingController addcontroll = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController desription = TextEditingController();
  CollectionReference AddProduct = FirebaseFirestore.instance.collection('Add');
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  var imageUrl;
  var prices,add,desriptionc;
  bool favourite=false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppConstants.width20(context),vertical:12),
          child: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                children: [
                  Center(
                      child: Text(
                    'اضافة المنتج',
                    style: Styles.text20bold(context),
                  )),
                  SizedBox(
                    height: AppConstants.height20(context),
                  ),
                  textFormField(
                    title: 'اسم المنتج',
                    enable: true,
                    obsure: false,
                    controller: addcontroll,
                    onchanged: (value) {
                      add = value;
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    height: AppConstants.height20(context),
                  ),
                  textFormField(
                    title: ' سعر المنتج',
                    enable: true,
                    obsure: false,
                    keyboard: TextInputType.number,
                    controller: price,
                    onchanged: (value) {
                      prices = value;
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    height: AppConstants.height20(context),
                  ),
                  textFormField(
                    title: 'وصف المنتج',
                    obsure: false,
                    enable: true,
                    max: 8,
                    controller: desription,
                    onchanged: (value) {
                      desriptionc= value;
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    height: AppConstants.height20(context),
                  ),
                  imageUrl==null?    GestureDetector(
                    onTap:pickImage,
                    child: textFormField(
                      title: 'صورة المنتج',
                      enable: false,
                      obsure: false,
                      keyboard: TextInputType.number,
                      iconata:IconButton(onPressed: (){}, icon:
                    const   Icon( Icons.image,color: Colors.grey,)),

                    ),
                  ):Container(
                    width: MediaQuery.sizeOf(context).width*0.7,
                    height: AppConstants.height55(context),
                    decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(imageUrl))),),
                  SizedBox(
                    height: AppConstants.height30(context),
                  ),
                  Custombutton(
                    title: 'التالي',
                    onpressed: () {
                if (formKey.currentState!.validate()) {
                  print(desription.text);
                  AddProduct
                      .add({
                    'name': add,
                    'favourite':favourite,// John Doe
                    'price': prices, // Stokes and Sons
                    'Image': imageUrl,
                    'desription':desriptionc// 42
                  });
                  setState(() {

                  });

Navigator.pop(context);
                }
                else {
                  autovalidateMode = AutovalidateMode.always;
                  setState(() {
            
                  });
                }         },
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
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
              Text('لقد تم إنشاء صورة منتج بنجاح'),
            );
          });
     /* await category.doc(widget.docid).update(
          {'Image': imageUrl});*/
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

}