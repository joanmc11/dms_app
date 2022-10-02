import 'package:dms_app/authentication/authenticate.dart';
import 'package:dms_app/controller/login_controller.dart';
import 'package:dms_app/view/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  final user = null;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (userId) {
        //Retorna home o authenticate widged depenent de si estàs logejat o no
        if (userId == '') {
          return const Authenticate();
        } else {
          return NavigationPage();
        }
      },
    );
  }
}
