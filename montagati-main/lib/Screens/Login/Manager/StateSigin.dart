abstract class SiginState{}
class initialState extends SiginState{}
class LoadingState extends SiginState{}
class SuccessState extends SiginState{}
class FailureState extends SiginState{
  String errorMessage;
  FailureState({required this.errorMessage});
}