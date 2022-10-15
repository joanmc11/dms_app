import 'package:dms_app/service/write_service_database.dart';
import 'package:flutter/material.dart';

class EditName extends StatefulWidget {
  const EditName({super.key, required this.userName});
  final String userName;

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  final _formKey = GlobalKey<FormState>();
  String nickname = '';

  @override
  void initState() {
    nickname = widget.userName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edita tu nombre"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.userName,
                validator: (val) => val != null ? null : "Introduce un nombre",
                onChanged: (val) {
                  setState(() {
                    nickname = val;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (nickname != '') {
                    WriteService().updateUserName(name: nickname);
                     Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Introduce un nombre')),
                     
                    );
                  }
                },
                child: const Text('Cambiar nombre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
