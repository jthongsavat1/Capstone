import 'package:capstone/components/my_button.dart';
import 'package:capstone/components/my_text_field.dart';
import 'package:capstone/components/square_tile.dart';
import 'package:capstone/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  final void Function()? onTap;
  const LogInPage({super.key, required this.onTap});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in user
  void signIn() async {
    //get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
        emailController.text, 
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
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
                        
                        //Welcome Back
                        const Center(
                          child: Text(
                            "Welcome Back Buddy!",
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
            
                        const SizedBox(height: 25),
                        
                        //sign in button
                        MyButton(onTap: signIn, text: "Sign In"),
            
                        const SizedBox(height: 50),
            
                        const Center(
                          child: Text(
                            "Or sign in with",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
            
                        const SizedBox(height: 5),
            
            
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SquareTile(
                                onTap: () => AuthService().signInWithGoogle(), 
                                imagePath: 'assets/images/google.png',
                              ),
                                  
                              const SizedBox(width: 25),
                                  
                              SquareTile(
                                onTap: () {}, 
                                imagePath: 'assets/images/apple.png',
                              ),
                            ],
                          ),
                        ),
            
                        const SizedBox(height: 50),
                        
                        //register
                        Row(
                          mainAxisAlignment:  MainAxisAlignment.center,
                          children: [
                            const Text('Not a Member?'),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: const Text(
                                'Register now',
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
          ],
        ),
      )
    );
  }
}