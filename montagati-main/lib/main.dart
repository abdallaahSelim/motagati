import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_purchases/Screens/Login/Manager/CubitSigin.dart';

import 'Screens/Regsister/Manager/CubitSignup.dart';
import 'core/Router.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
        BlocProvider(
        create: (context) => SigInCubit(),
    ),
    BlocProvider(
    create: (context) => SigUpCubit(),
    )
    ],
    child: MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff050505),
      ),
      routes: routes(),
     initialRoute:'/' ,
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
    ),


  );
}

}
