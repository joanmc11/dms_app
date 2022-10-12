// ignore_for_file: deprecated_member_use

import 'package:dms_app/service/auth_service.dart';
import 'package:dms_app/shared/loading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  final Function toggleView;
  const LogIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

//text field states
  String email = "";
  String password = "";
  String nickname = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.2,
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "Registrate",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TextFormField(
                        //email
                        validator: (val) =>
                            val != null ? null : "Introduce un nickname",
                        decoration: const InputDecoration(
                            hintText: "Nickname",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amber, width: 0.5))),
                        onChanged: (val) {
                          setState(() {
                            nickname = val;
                          });
                        },
                      ),
                      TextFormField(
                        //email
                        validator: (val) => EmailValidator.validate(val!)
                            ? null
                            : "Introduce un email válido",
                        decoration: const InputDecoration(
                            hintText: "Email",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amber, width: 0.5))),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      TextFormField(
                        //password
                        validator: (val) => val!.length < 6
                            ? "Introduce una contraseña de mínimo 6 caracteres"
                            : null,
                        decoration: const InputDecoration(
                            hintText: "Password",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amber, width: 0.5))),
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: email != "" && password != ""
                                      ? Colors.amber
                                      : Colors.grey),
                              child: const Text(
                                "Registrate",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  
                                      await _auth.registerWithEmailAndPassword(
                                          nickname, email, password);

                                 setState(() {
                                    loading = false;
                                  });
                                  }
                                }
                              
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("¿Ya tienes cuenta? "),
                            Text(
                              "Inicia sesión",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
