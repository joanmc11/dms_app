

import 'package:get/get.dart';

class ClasificationController extends GetxController{

  var general = true.obs;

  void toggleJornada(bool select){
    general.value = select;
  }
}