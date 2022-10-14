import 'package:dms_app/controller/clasification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToggleButtonsClasification extends StatefulWidget {
   const ToggleButtonsClasification({super.key});



  @override
  State<ToggleButtonsClasification> createState() =>
      _ToggleButtonsClasificationState();
}

class _ToggleButtonsClasificationState
    extends State<ToggleButtonsClasification> {
  final List<bool> _selectedButton = [true, false];
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: ((index) {
           ClasificationController clasificationController =
      Get.put(ClasificationController());
        setState(() {
          for (int i = 0; i < _selectedButton.length; i++) {
            _selectedButton[i] = i == index;
          clasificationController.toggleJornada(!_selectedButton[i]);
          }
        });
        
        
      }),
      isSelected: _selectedButton,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.red[700],
      selectedColor: Colors.white,
      fillColor: Colors.red[200],
      color: Colors.red[400],
      constraints:  BoxConstraints(
        minHeight: 40.0,
        minWidth: MediaQuery.of(context).size.width/2.5,
      ),
      children: const [Text("General"), Text("Jornada")],
    );
  }
}
