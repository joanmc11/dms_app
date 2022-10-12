import 'package:dms_app/authentication/authenticate.dart';
import 'package:dms_app/controller/login_controller.dart';
import 'package:dms_app/service/user_pref_service.dart';
import 'package:dms_app/view/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  final user = null;
  @override
  Widget build(BuildContext context) {
    var prefs = UserPreferences();
    return GetBuilder<LoginController>(
      id: "wrapper",
      init: LoginController(),
     
      builder: (userId) {
        //Retorna home o authenticate widged depenent de si estàs logejat o no
          if(userId.userId.value == '' &&  !prefs.loggedIn ){
              return  const Authenticate() ;
          }else{
              return NavigationPage();
          }
          
          
           
        
      },
    );
  }
}
