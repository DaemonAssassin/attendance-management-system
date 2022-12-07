import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String selectedValue = "User";
  final _loginFormKey = GlobalKey<FormState>();

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
          key: _loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLoginText(),
              const SizedBox(height: 36.0),
              _buildEmailTextField(),
              const SizedBox(height: 16.0),
              _buildPasswordTextField(),
              const SizedBox(height: 16.0),
              _buildAccountTypeDropDown(),
              const SizedBox(height: 16.0),
              _buildLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return const Text(
      'Login',
      style: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
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

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_loginFormKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login'),
              ),
            );
          }
        },
        child: const Text('Login'),
      ),
    );
  }
}
