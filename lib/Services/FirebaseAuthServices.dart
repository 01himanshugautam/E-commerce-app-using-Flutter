import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }
}
