import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  //get the users current location
  // final Geolocator _geolocator = Geolocator();

  //sign user in 
  Future<UserCredential> signInWithEmailandPassword(
    String email, String password) async {
    try {
      //sign in
      UserCredential userCredential = 
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );

      // Get user's current location
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          // Create a GeoPoint object
          GeoPoint userGeoPoint = GeoPoint(position.latitude, position.longitude);

      //add a new document for the user in users collection if it doesnt exist already
      _firestore.collection('users')
      .doc(userCredential.user!.email)
      .set ({
            'uid': userCredential.user!.uid,
            'email': email,
            'location': userGeoPoint,
          }, SetOptions(merge: true));

      return userCredential;
    }
    //catch any errors 
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //create a new user
  Future<UserCredential> signUpWithEmailandPasword(
    String email, password) async {
      try {
        UserCredential userCredential = 
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, 
          password: password,
          );

          // Get user's current location
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          // Create a GeoPoint object
          GeoPoint userGeoPoint = GeoPoint(position.latitude, position.longitude);

          //after creating the user, create a new document for the user in the users collection
          _firestore.collection('users')
          .doc(userCredential.user!.email)
          .set ({
            'uid': userCredential.user!.uid,
            'email': email,
            'username': email.split('@')[0],
            'bio': 'Empty Bio...',
            'location': userGeoPoint,
          });

          return userCredential;
      } on FirebaseAuthException catch (e) {
        throw Exception(e.code);
      }
    }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  //Delete user
  Future<void> deleteUser() async{
    return await FirebaseAuth.instance.currentUser!.delete();
  }
}