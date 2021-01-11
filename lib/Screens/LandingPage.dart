import 'package:e_commerce_app/Screens/HomePage.dart';
import 'package:e_commerce_app/Screens/LoginPage.dart';
import 'package:e_commerce_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //  if snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        //  Connection initialized - Firebase App  is running
        if (snapshot.connectionState == ConnectionState.done) {
          // Streambulider can check the login state live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              // If Stream Snapshot has error
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      "Error: ${streamSnapshot.error}",
                      style: Constants.regularHeading,
                    ),
                  ),
                );
              }

              if (streamSnapshot.connectionState == ConnectionState.active) {
                //Get the user
                User _user = streamSnapshot.data;
                // If the user is nill we're not logged in
                if (_user == null) {
                  // User not logged in , head to login
                  return LoginPage();
                } else {
                  // The user is logged in head to homePage
                  return HomePage();
                }
              }

              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication...",
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }

        return Scaffold(
          body: Center(
            child: Text(
              "Initialzation App...",
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
