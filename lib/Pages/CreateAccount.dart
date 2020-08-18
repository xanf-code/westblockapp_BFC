import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  String Username;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  submitUsername() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      SnackBar snackBar = SnackBar(
        content: Text("Welcome ${Username}"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(
        Duration(seconds: 4),
        () {
          Navigator.pop(context, Username);
        },
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 26.0),
                  child: Center(
                    child: Text(
                      "Setup Username",
                      style: GoogleFonts.montserrat(
                        fontSize: 26,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(17),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        style: GoogleFonts.montserrat(color: Colors.black),
                        validator: (val) {
                          if (val.trim().length < 5 || val.isEmpty) {
                            return "User Name is Short";
                          } else if (val.trim().length > 15) {
                            return "User Name is Very long";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => Username = val,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          labelStyle: GoogleFonts.montserrat(fontSize: 16),
                          hintText: "must be atleast 5 characters",
                          hintStyle: GoogleFonts.montserrat(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submitUsername,
                  child: Container(
                    height: 55,
                    width: 360,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Proceed",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
