import 'package:get/get.dart';

class LoginController extends GetxController{

  var userId = ''.obs;

  void setId(String id){
    userId.value = id;
    update(['wrapper']);
  }
}