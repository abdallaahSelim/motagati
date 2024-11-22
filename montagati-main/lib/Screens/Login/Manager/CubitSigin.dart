import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'StateSigin.dart';

class SigInCubit extends Cubit<SiginState> {
  SigInCubit() : super(initialState());

  Future<void> Login({required String email, required String password}) async {
    try {
      EasyLoading.show(status: "من فضلك انتظر...");
      emit(LoadingState());
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      EasyLoading.dismiss();
      emit(SuccessState());

    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'user-not-found') {
        emit(FailureState(errorMessage: 'برجاء كتابة البريد الالكتروني صحيح'));
      } else if (e.code == 'wrong-password') {
        emit(FailureState(errorMessage: 'برجاء كتابة كلمة المرور صحيحة'));
      }
      else{
        emit(FailureState(errorMessage:'برجاء كتابة البريد الالكتروني وكلمة المرور بطريقة صحيحة'));
      }
    }
  }
}


