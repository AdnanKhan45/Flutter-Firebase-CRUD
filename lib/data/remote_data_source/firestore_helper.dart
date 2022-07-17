
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_crud/data/models/user_model.dart';

class FirestoreHelper {

  static Stream<List<UserModel>> read() {
    final userCollection = FirebaseFirestore.instance.collection("users");
    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());

  }

  static Future create(UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final docRef = userCollection.doc();

    final newUser = UserModel(
      username: user.username,
      age: user.age
    ).toJson();

    try {
      await docRef.set(newUser);

    } catch(e) {
      print("some error occured $e");
    }
  }




}