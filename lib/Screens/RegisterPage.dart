import 'package:e_commerce_app/Widgets/CustomButton.dart';
import 'package:e_commerce_app/Widgets/CustomInput.dart';
import 'package:e_commerce_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Build an alert dialog to display some errors.
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

// Create a new user
  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        return 'The password provide is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'The account alreadu ez=xists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

// Set the form to loading state
  void _submitForm() async {
    setState(() {
      _registerFormLoading = true;
    });
    // Run the create method
    String _createAccountFeedback = await _createAccount();
    // if the string is not null , we got error while create account
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);
      // set th form to regualr state [not loading]
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      // The String was null,user is logged in.
      Navigator.pop(context);
    }
  }

// Default form loading state
  bool _registerFormLoading = false;

// Form inout loading Values'
  String _registerEmail = "";
  String _registerPassword = "";

  // Focus Node for inpur fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(top: 24.0),
            child: Text(
              "Create A New Account",
              textAlign: TextAlign.center,
              style: Constants.boldHeading,
            ),
          ),
          Column(children: [
            CustomInput(
              hintText: "Email...",
              onChanged: (value) {
                _registerEmail = value;
              },
              onSubmitted: (value) {
                _passwordFocusNode.requestFocus();
              },
              textInputAction: TextInputAction.next,
            ),
            CustomInput(
              hintText: "Password...",
              onChanged: (value) {
                _registerPassword = value;
              },
              focusNode: _passwordFocusNode,
              isPasswordField: true,
              onSubmitted: (value) {
                _submitForm();
              },
            ),
            Custombutton(
              text: "Create a account",
              onPressed: () {
                print("Click on Login button");
                // _alertDialogBuilder();
                _submitForm();
              },
              isloading: _registerFormLoading,
              // outlineBtn: true,
            )
          ]),
          Custombutton(
            text: "Back To Login",
            onPressed: () {
              print("Clicke on back button");
              Navigator.pop(context);
            },
            outlineBtn: true,
          )
        ],
      ),
    )));
  }
}
