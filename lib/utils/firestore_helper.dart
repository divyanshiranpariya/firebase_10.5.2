import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_5/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  addAuthentication({required UserModel userModel}) async {
    bool isUserExists = false;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("users").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
        querySnapshot.docs;

    allDocs.forEach((doc) {
      if (doc['email'] == userModel.email) {
        isUserExists = true;
      }
    });

    if (isUserExists == false) {
      await db.collection("users").doc("").set({
        "id": userModel.id,
        "name": userModel.name,
        "email": userModel.email,
        "age": userModel.age
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUser() {
    return db.collection("users").snapshots();
  }
}
