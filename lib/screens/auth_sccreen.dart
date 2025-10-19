import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase = FirebaseAuth.instance; //

class AuthSccreen extends StatefulWidget {
  const AuthSccreen({super.key});

  @override
  State<AuthSccreen> createState() {
    return _AuthSccreenState();
  }
}

class _AuthSccreenState extends State<AuthSccreen> {
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  final _formKey = GlobalKey<FormState>();
  var _enteredUsername = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      if (_isLogin) {
        // ignore: unused_local_variable
        final userCredential = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } //
      else //
      {
        final userCredential = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'username': _enteredUsername,
              'email': _enteredEmail,
              'image_url': 'no image no Firebase Store',
              'password': _enteredPassword,
            });
      }
    }
    //'on' defining the type of the error. and when using try{..} on...catch, only exceptions of the provided type(FirebaseAuth in this case) will be cayghet & handled!!
    on FirebaseAuthException catch (error) {
      if (error.code == 'email-aready-in-use' ||
          error.code == 'invalid-email') {
        //....
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication Failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Chat', style: TextStyle(color: Colors.blueAccent)),
            Text('App'),
          ],
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),

              Card(
                margin: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        //takes as much space as needed by the contents by main axis size
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value
                                      .trim()
                                      .isEmpty || //trim is for removing white space
                                  !value.contains('@')) {
                                return 'Plaese Enter a Valid Email.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredEmail = newValue!;
                            },
                          ),

                          SizedBox(height: 5),

                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'User Name',
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null || value.trim().length < 4) {
                                  return 'Enter a valid User name (atleast 4 characters.)';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredUsername = newValue!;
                              },
                            ),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be atleast 6 Characters';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredPassword = newValue!;
                            },
                          ),

                          const SizedBox(height: 10),

                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                            ),
                            child: Text(_isLogin ? 'Login' : 'SignUp'),
                          ),

                          const SizedBox(height: 15),

                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin =
                                    !_isLogin; //_isLogin ? false : true (! this checks for the opposits)
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? 'Create An Account'
                                  : 'I Already Have an account',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
