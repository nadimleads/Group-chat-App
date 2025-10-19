import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMassage extends StatefulWidget {
  const NewMassage({super.key});

  @override
  State<NewMassage> createState() {
    return _NewMassageState();
  }
}

class _NewMassageState extends State<NewMassage> {
  final _massageController = TextEditingController();

  @override
  void dispose() {
    _massageController.dispose();
    super.dispose();
  }

  void _submitMethod() async {
    final enteredMassage = _massageController.text;

    if (enteredMassage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus(); //closing Keyboard remove what sent
    _massageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(); //retriving data form FireStore

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMassage,
      'createAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': 'No Image',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _massageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: 'Send a massage...'),
            ),
          ),
          IconButton(
            onPressed: _submitMethod,
            color: Colors.blue,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
