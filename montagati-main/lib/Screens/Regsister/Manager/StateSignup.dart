abstract class SigupState{}
class initialState extends SigupState{}
class LoadingState extends SigupState{}
class SuccessState extends SigupState{}
class FailureState extends SigupState{
  String errorMessage;
  FailureState({required this.errorMessage});
}