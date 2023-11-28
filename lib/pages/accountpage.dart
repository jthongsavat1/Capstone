import 'package:capstone/components/my_text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget{
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>{
  final User? currentUser = FirebaseAuth.instance.currentUser!;
  // final userData = snapshot.data!.data() as Map<String, dynamic>;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot<Map<String,dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser!.email)
      .get();
  }

  Future<void> editField(String field) async{
    String newValue = "";
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey,
          title: Text(
            'Edit $field',
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: const TextStyle(color: Colors.white),
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [

            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            TextButton(
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(newValue),
            ),
          ],
          ),
        ); 

        if (newValue.trim().isNotEmpty) {
          await usersCollection.doc(currentUser!.email).update({field: newValue});
        }
      }

  //sign user out
  void signOut() {
    //get auth service
    // final authService = Provider.of<AuthService>(context, listen: false);
    FirebaseAuth.instance.signOut();
    // authService.signOut();
  }

  void deleteUser() {
    FirebaseAuth.instance.currentUser!.delete();
    // FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          //Delete User
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return const DeleteUserDialog();
              }
            ), 
            icon: const Icon(Icons.delete_forever_rounded),
          ),

        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.email)
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final currentUser = FirebaseAuth.instance.currentUser;
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50),

                const Icon(
                  Icons.person,
                  size: 72,
                ),

                const SizedBox(height: 10),

                Text(
                  currentUser!.email!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 50),

                const Padding(padding: EdgeInsets.only(left: 25.0),
                child: Text(
                  "My Details",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              MyTextBox(
                text: userData['username'],
                sectionName: 'Username',
                onPressed: () => editField('username'),
              ),

              const SizedBox(height: 25),

              MyTextBox(
                text: userData['bio'],
                sectionName: 'Bio',
                onPressed: () => editField('bio'),
              ),

              const SizedBox(height: 100),

              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: signOut,
                  child: const Text('Logout'),
                ),
              ),

              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}

class DeleteUserDialog extends StatelessWidget {
  const DeleteUserDialog({super.key});

  void deleteUser() {
    FirebaseAuth.instance.currentUser!.delete();
    // FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey,
      title: const Text(
        'Do you want to delete your account?',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text(
            'Yes, Please',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => deleteUser,
        ),
      ],
    );
  }
}
