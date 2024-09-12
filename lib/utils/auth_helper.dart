import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  AuthHelper._();

  static final AuthHelper authHelper = AuthHelper._();

  static GoogleSignIn googleSignIn = GoogleSignIn();
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  signUp({required String email, required String password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      res['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e) {
        case "Network-request-failed":
          res['error'] = "NO Internet available";
          break;
        case "Operation-not-allowed":
          res['error'] = "This is displayed by admin";
          break;
        case "Weak-Password":
          res['error'] = "password must be greater than 6 letters..";
          break;
        case "email-already-in-use":
          res['error'] = "This email is already  exixts...";
          break;
        default:
          res['error'] = "${e.code}";
      }
    }

    return res;
  }

  signInWithGoogle() async {
    Map<String, dynamic> res = {};
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;
      res['user'] = user;
    } catch (e) {
      res['error'] = "${e}";
    }
    return res;
  }
}
