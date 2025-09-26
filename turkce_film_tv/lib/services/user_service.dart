import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;

  Future<UserCredential> registerUser(
      String email, String password, String username) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'username': username,
      'email': email,
      'avatar': 1,
    });
    return userCredential;
  }

  String? getCurrentUserId() {
    final currentUser = _auth.currentUser;
    return currentUser?.uid;
  }

  Future<UserCredential> loginUser(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> addToWatchlist(String userId, String movieId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watchlist')
          .doc(movieId)
          .set({'addedAt': DateTime.now()});
    } catch (e) {
      // Error adding movie to watchlist: $e
      rethrow;
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> updateUserData(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      await firestore.collection('users').doc(userId).update(updatedData);
    } catch (e) {
      // Error updating user data: $e
      rethrow;
    }
  }
}
