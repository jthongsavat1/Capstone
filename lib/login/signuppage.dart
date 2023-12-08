import 'package:capstone/components/my_button.dart';
import 'package:capstone/components/my_text_field.dart';
import 'package:capstone/components/square_tile.dart';
import 'package:capstone/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign up user
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
        .showSnackBar(
          const SnackBar(
            content: Text("Passwords do no match!"),
        ),
      );
      return;
    }

    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailandPasword(
        emailController.text, 
        passwordController.text,
        );


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450){
            return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SquareTile(
                      onTap: () {}, 
                      imagePath: 'assets/images/logoidea.png',
                      ),
                      const SizedBox(height: 50),
                      const Center(
                        child: Text(
                          "Create an Account",
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 50),
                      MyButton(onTap: signUp, text: "Sign up Now"),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "Or sign in with",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SquareTile(
                            onTap: () {
                              // Handle Google sign-in
                            },
                            imagePath: 'assets/images/google.png',
                          ),
                          const SizedBox(width: 15),
                          SquareTile(
                            onTap: () {
                              // Handle Apple sign-in
                            },
                            imagePath: 'assets/images/apple.png',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already a Member?'),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Login now',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
          } else {
            return DecoratedBox(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                  child: Center(
                    child: Image.asset(
                      'assets/images/logoidea.png', // Replace with your image path
                      height: 200,
                      width: 700,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 50),
                              // Create Account Message
                              const Center(
                                child: Text(
                                  "Create an Account",
                                  style: TextStyle(
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Email field
                              MyTextField(
                                controller: emailController,
                                hintText: 'Email',
                                obscureText: false,
                              ),
                              const SizedBox(height: 10),
                              // Password field
                              MyTextField(
                                controller: passwordController,
                                hintText: 'Password',
                                obscureText: true,
                              ),
                              const SizedBox(height: 10),
                              // Confirm Password field
                              MyTextField(
                                controller: confirmPasswordController,
                                hintText: 'Confirm Password',
                                obscureText: true,
                              ),
                              const SizedBox(height: 50),
                              // Sign Up button
                              MyButton(onTap: signUp, text: "Sign up Now"),
                              const SizedBox(height: 20),
                              const Center(
                                child: Text(
                                  "Or sign in with",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Social Media Login Tiles
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SquareTile(
                                    onTap: () =>
                                        AuthService().signInWithGoogle(),
                                    imagePath: 'assets/images/google.png',
                                  ),
                                  const SizedBox(width: 15),
                                  SquareTile(
                                    onTap: () {},
                                    imagePath: 'assets/images/apple.png',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Register
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Already a Member?'),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: widget.onTap,
                                    child: const Text(
                                      'Login now',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ); 
          }
        }
      ),
    );
  }
}



