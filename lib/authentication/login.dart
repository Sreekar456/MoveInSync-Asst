import 'package:app/authentication/signup.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  // TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset('assets/images/final.png', height: 100),
              Text(
                "Login as a user",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              // textfields for email and password
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    // TextField(
                    //   controller: userNameTextEditingController,
                    //   keyboardType: TextInputType.text,
                    //   decoration: const InputDecoration(
                    //     labelText: "User Name",
                    //     labelStyle: TextStyle(fontSize: 14),
                        
                    //   ),
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: 15
                    //   ),
                    // ),

                    // const SizedBox(height: 22),

                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 14),
                        
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                      ),
                    ),
                    const SizedBox(height: 22),

                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User password",
                        labelStyle: TextStyle(fontSize: 14),
                        
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: ()
                      {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(horizontal: 80,vertical: 10)
                      ),
                      child: const Text(
                        "Log in",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUp()),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}