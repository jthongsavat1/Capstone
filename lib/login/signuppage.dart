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
      body:
      DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'), fit: BoxFit.cover
          )
        ),
        child: Row(
          children: [
            const Expanded(
                child: 
                  SizedBox(height: 50)
              ),
            Expanded(
              child: Container(
                color:const Color.fromARGB(255, 155, 46, 19),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50),
                      
                      //logo
                      Expanded(
                        child: Image.asset(
                          'assets/images/logo.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 50),
                      
                      //Create Account Message
                      const Center(
                        child: Text(
                        "Create an Account",
                        style: TextStyle(
                          fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      
                      //email field
                      MyTextField(
                        controller: emailController, 
                        hintText: 'Email', 
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),
                      
                      //password
                      MyTextField(
                        controller: passwordController, 
                        hintText: 'Password', 
                        obscureText: true,
                      ),

                      const SizedBox(height: 10),

                      //confirm password
                      MyTextField(
                        controller: confirmPasswordController, 
                        hintText: 'Confirm Password', 
                        obscureText: true,
                      ),

                      const SizedBox(height: 50),
                      
                      //sign up button
                      MyButton(onTap: signUp, text: "Sign up Now"),

                      const SizedBox(height: 50),

                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SquareTile(
                                onTap: () {}, 
                                imagePath: 'assets/images/shiba.jpg',
                              ),
                                  
                              const SizedBox(width: 25),
                                  
                              SquareTile(
                                onTap: () {}, 
                                imagePath: 'assets/images/marker.jpg',
                              ),
                            ],
                          ),
                        ),
                      
                      //register
                      Row(
                        mainAxisAlignment:  MainAxisAlignment.center,
                        children: [
                          const Text('Already a Member?'),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Login now',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlueAccent
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
          ],
        ),
      )
    );
  }
}

