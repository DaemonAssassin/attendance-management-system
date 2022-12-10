import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String selectedValue = "User";
  final _signUpFormKey = GlobalKey<FormState>();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _signUpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSignUpText(),
              const SizedBox(height: 36.0),
              _buildNameTextField(),
              const SizedBox(height: 16.0),
              _buildEmailTextField(),
              const SizedBox(height: 16.0),
              _buildPasswordTextField(),
              const SizedBox(height: 16.0),
              _buildAccountTypeDropDown(),
              const SizedBox(height: 16.0),
              _buildSignUpButton(context),
              const SizedBox(height: 36.0),
              _buildAlreadyHaveAccount()
            ],
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
        value: selectedValue,
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
            setState(() => selectedValue = value);
          }
        },
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_signUpFormKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('SignUp Successful'),
              ),
            );
          }
        },
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
          onPressed: () {},
          child: const Text('Sign In'),
        )
      ],
    );
  }
}
