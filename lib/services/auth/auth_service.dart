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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // After successful sign-in, retrieve user data and store it in Firestore
      await _storeUserData(userCredential.user!);

      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> _storeUserData(User user) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      GeoPoint userGeoPoint = GeoPoint(position.latitude, position.longitude);

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'username': user.displayName ?? user.email!.split('@')[0],
        'bio': 'Empty Bio...',
        'location': userGeoPoint,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error storing user data: $e');
    }
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