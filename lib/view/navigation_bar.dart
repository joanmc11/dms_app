import 'package:dms_app/controller/navigation_controller.dart';
import 'package:dms_app/view/clasification_view.dart';
import 'package:dms_app/view/perfil.dart';
import 'package:dms_app/view/team_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class NavigationPage extends StatelessWidget {
  BottomNavigationController bottomNavigationController =
      Get.put(BottomNavigationController());
  NavigationPage({super.key});

  final views = [
    const TeamScreen(),
    ClasificationScreen(),
    const Perfil(),
  ];

  final titles = ["Mi Equipo", "Clasificación", "Mi Perfil"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Center(child: Text(titles[bottomNavigationController.selectedIndex.value]))),
      ),
      body: Obx(() => IndexedStack(
            index: bottomNavigationController.selectedIndex.value,
            children: views,
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white38,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: (index) {
              bottomNavigationController.changeIndex(index);
            },
            currentIndex: bottomNavigationController.selectedIndex.value,
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.usersBetweenLines,
                ),
                label: "Mi equipo",
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.trophy,
                ),
                label: "Clasificación",
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.user,
                ),
                label: "Perfil",
                backgroundColor: Colors.red,
              ),
            ]),
      ),
    );
  }
}
