import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class CreateGroupsPage extends StatefulWidget{
  const CreateGroupsPage({super.key});

  @override
  State<CreateGroupsPage> createState() => _CreateGroupsPageState();
}

class _CreateGroupsPageState extends State<CreateGroupsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController groupNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!.email;

  Future<void> createGroup() async {
    try {
      // Create a new group document
      DocumentReference groupDocRef = firestore.collection('groups').doc();

      // Define the group details
      Map<String, dynamic> groupData = {
        'groupName': groupNameController.text,
        'description': descriptionController.text,
        'members': [currentUser], // Initially, the group has no members
        // Add other relevant fields for the group
      };

      // Set the data for the group document
      await groupDocRef.set(groupData);

    Navigator.of(context).pop();
    } catch (error) {
      print('Error creating group: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: groupNameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: createGroup,
              child: const Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    groupNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}