import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection("Products");
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");
}
