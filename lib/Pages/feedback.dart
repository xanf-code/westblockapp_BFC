import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  TextEditingController descEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController tagsEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF011589),
        title: Text("Feedback Form"),
        centerTitle: false,
      ),
      body: Column(
        children: [
          buildFeedbackForm(),
        ],
      ),
    );
  }

  String selectType = "";
  var typeslist = [
    "Login Trouble",
    "Performance Issue",
    "Profile Issue",
    "Other Issue",
    "Suggestion",
  ];

  saveFeedBackToFirebase({String description, String email, String tag}) {
    Firestore.instance.collection("feedback").document().setData({
      "description": description,
      "email": email,
      "tag": tag,
    });
  }

  controlSave() async {
    saveFeedBackToFirebase(
      description: descEditingController.text,
      email: emailEditingController.text,
      tag: tagsEditingController.text,
    );
    descEditingController.clear();
    emailEditingController.clear();
    tagsEditingController.clear();
  }

  buildFeedbackForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            height: 200,
            child: TextFormField(
              controller: descEditingController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "Please briefly describe the issue here",
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFc5c5c5),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFc5c5c5),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: emailEditingController,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Email here",
              hintStyle: TextStyle(
                fontSize: 13,
                color: Color(0xFFc5c5c5),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFc5c5c5),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DropDownField(
            controller: tagsEditingController,
            inputFormatters: [
              WhitelistingTextInputFormatter(
                RegExp("[a-zA-Z]"),
              ),
            ],
            itemsVisibleInDropdown: 3,
            hintText: "Select Tag",
            items: typeslist,
            onValueChanged: (value) {
              setState(() {
                selectType = value;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  padding: EdgeInsets.all(16),
                  onPressed: () {
                    controlSave();
                  },
                  child: Text(
                    "Submit Here",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
