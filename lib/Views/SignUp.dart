import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:westblockapp/Services/auth_service.dart';
import 'package:westblockapp/Widgets/provider.dart';

enum AuthFormType { signUp, signIn, reset }

class SignUp extends StatefulWidget {
  final AuthFormType authFormType;

  const SignUp({Key key, @required this.authFormType}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState(authFormType: AuthFormType.signUp);
}

class _SignUpState extends State<SignUp> {
  AuthFormType authFormType;
  _SignUpState({this.authFormType});
  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == 'signUp') {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (authFormType == AuthFormType.signIn) {
          await auth.signInWithEmailAndPassword(_email, _password);
          Navigator.pushReplacementNamed(context, "/home");
        } else if (authFormType == AuthFormType.reset) {
          await auth.sendPasswordResetEmail(_email);
          print("Password reset email sent");
          _warning = "Password reset link has been sent to $_email";
          setState(() {
            authFormType = AuthFormType.signIn;
          });
        } else {
          await auth.createUserWithEmailAndPassword(_email, _password, _name);
          Navigator.pushReplacementNamed(context, "/home");
        }
      } catch (e) {
        setState(
          () {
            _warning = e.message;
          },
        );
        print(
          e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF011589),
      body: SafeArea(
        child: Container(
          width: _width,
          height: _height,
          child: Column(
            children: [
              SizedBox(
                height: _height * 0.025,
              ),
              showAlert(),
              SizedBox(
                height: _height * 0.025,
              ),
              buildHeadText(),
              SizedBox(
                height: _height * 0.025,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: buildInputs() + buildButtons(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  Text buildHeadText() {
    String _headerText;
    if (authFormType == AuthFormType.signUp) {
      _headerText = "Create New Account";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "Sign In";
    }
    return Text(_headerText);
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    if (authFormType == AuthFormType.reset) {
      textFields.add(
        TextFormField(
          validator: EmailValidator.validate,
          style: TextStyle(fontSize: 22),
          decoration: buildSignUpInputDecoration("Email"),
          onSaved: (value) => _email = value,
        ),
      );
      textFields.add(
        SizedBox(
          height: 20,
        ),
      );
      return textFields;
    }

    if (authFormType == AuthFormType.signUp) {
      textFields.add(
        TextFormField(
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 22),
          decoration: buildSignUpInputDecoration("Name"),
          onSaved: (value) => _name = value,
        ),
      );
      textFields.add(
        SizedBox(
          height: 20,
        ),
      );
    }
    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        style: TextStyle(fontSize: 22),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value,
      ),
    );
    textFields.add(
      SizedBox(
        height: 20,
      ),
    );
    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: TextStyle(fontSize: 22),
        decoration: buildSignUpInputDecoration("Password"),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    );
    textFields.add(
      SizedBox(
        height: 20,
      ),
    );
    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 0,
        ),
      ),
      contentPadding: EdgeInsets.only(left: 14, bottom: 10, top: 10),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtons, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _social = true;
    if (authFormType == AuthFormType.signIn) {
      _switchButtons = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtons = "Return to Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
      _social = false;
    } else {
      _switchButtons = "Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }
    return [
      FlatButton(
        child: Text(
          _submitButtonText,
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        onPressed: submit,
      ),
      SizedBox(
        height: 10,
      ),
      showForgotPassword(_showForgotPassword),
      FlatButton(
        child: Text(
          _switchButtons,
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            switchFormState(_newFormState);
          });
        },
      ),
      buildSocialIcons(_social),
    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: [
          Divider(
            color: Colors.white,
          ),
          SizedBox(
            height: 10,
          ),
          GoogleSignInButton(
            onPressed: () async {
              try {
                await _auth.signInWithGoogle();
                Navigator.of(context).pushReplacementNamed("/home");
              } catch (e) {
                _warning = e.message;
              }
            },
          ),
        ],
      ),
      visible: visible,
    );
  }
}
