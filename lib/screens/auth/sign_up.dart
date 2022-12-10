import 'dart:developer';
import 'dart:io';

import 'package:attendance_management_system/models/user_or_admin_model.dart';
import 'package:attendance_management_system/screens/auth/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedAccountType = "User";
  File? _imageFile;
  final _signUpFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _signUpFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSignUpText(),
                  const SizedBox(height: 36.0),
                  _buildProfileImage(),
                  const SizedBox(height: 36.0),
                  _buildNameTextField(),
                  const SizedBox(height: 16.0),
                  _buildEmailTextField(),
                  const SizedBox(height: 16.0),
                  _buildPasswordTextField(),
                  const SizedBox(height: 16.0),
                  _buildAccountTypeDropDown(),
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  _buildSignUpButton(context),
                  const SizedBox(height: 36.0),
                  _buildAlreadyHaveAccount()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpText() {
    return const Text(
      'SignUp',
      style: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildProfileImage() {
    return _imageFile == null
        ? IconButton(
            onPressed: _pickImageFromGallery,
            icon: const Icon(Icons.add_a_photo_sharp),
            iconSize: 48.0,
          )
        : ClipOval(
            child: Image.file(
              _imageFile!,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          );
  }

  Widget _buildNameTextField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'name',
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          return null;
        }
        return 'Please fill name properly';
      },
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'email',
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          return null;
        }
        return 'Please fill email properly';
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'password',
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          return null;
        }
        return 'Please fill password properly';
      },
    );
  }

  Widget _buildAccountTypeDropDown() {
    return SizedBox(
      width: 150,
      child: DropdownButton(
        isExpanded: true,
        value: _selectedAccountType,
        items: const [
          DropdownMenuItem(
            value: 'User',
            child: Text('User'),
          ),
          DropdownMenuItem(
            value: 'Admin',
            child: Text('Admin'),
          ),
        ],
        onChanged: (value) {
          if (value != null && value.isNotEmpty) {
            setState(() => _selectedAccountType = value);
          }
        },
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onSignUpButtonPressed,
        child: const Text('SignUp'),
      ),
    );
  }

  Widget _buildAlreadyHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account",
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SignInScreen(),
              ),
            );
          },
          child: const Text('Sign In'),
        )
      ],
    );
  }

  void _pickImageFromGallery() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      _imageFile = File(file.path);
      setState(() {});
    }
  }

  Future<String?> _uploadImageToFirebaseStorage() async {
    try {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      UploadTask imageUploadTask = FirebaseStorage.instance
          .ref()
          .child(_selectedAccountType == 'User' ? 'users/' : 'admins')
          .child(imageName)
          .putFile(_imageFile!);
      TaskSnapshot snapshot = await imageUploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log('Image not uploaded');
      return null;
    }
  }

  Future<void> _onSignUpButtonPressed() async {
    if (_signUpFormKey.currentState!.validate() && _imageFile != null) {
      setState(() => _isLoading = true);
      // create user / admin account in firebase
      final String name = _nameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;

      // Todo: Cloud Storage is not working for now
      // Upload the image to the firebase storage
      // final String? imageUrl = await _uploadImageToFirebaseStorage();
      const String imageUrl = '--';

      // creating account of user / admin on Firebase Auth
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      if (credential.user != null) {
        // creating model
        UserOrAdmin userOrAdmin = UserOrAdmin(
          name: name,
          image: imageUrl,
          email: email,
          password: password,
          accountType: _selectedAccountType,
        );

        // creating doc of user / admin in firestore
        FirebaseFirestore.instance
            .collection(_selectedAccountType == 'User' ? 'users' : 'admins')
            .doc(credential.user!.uid)
            .set(userOrAdmin.toMap());

        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SignUp Successful'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SignInScreen(),
          ),
        );
      }
    }
  }
}
