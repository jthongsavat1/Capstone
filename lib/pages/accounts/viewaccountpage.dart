import 'package:capstone/components/my_text_box.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccountPage extends StatelessWidget {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserAccountPage({super.key, required this.userId});

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    try {
      return await _firestore.collection('users').doc(userId).get();
    } catch (error) {
      throw ('Error fetching user details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(), // Retrieve user details
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('User not found');
          } else {
            // Extract user data
            var userData = snapshot.data!.data();
            String userEmail = userData?['email'] ?? ''; // Get user's email

            return Text(
              userEmail,
            ); // Set user's email as the title
          }
        },
      ),
      centerTitle: true,
    ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          } else {
            // Display user details
            var userData = snapshot.data!.data();
            return ListView(
              padding: const EdgeInsets.all(20.0),
                children: [
                  const SizedBox(height: 50),

                  const Icon(
                    Icons.person,
                    size: 72,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    userData?['username'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    userData?['email'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 50),
                  
                  ViewTextBox(
                    text: userData?['bio'],
                    sectionName: 'Bio:', 
                  ),
                ],
            );
          }
        },
      ),
    );
  }
}
