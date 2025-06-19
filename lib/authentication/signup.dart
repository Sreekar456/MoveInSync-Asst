import 'package:app/methods/common_methods.dart';
import 'package:app/pages/home.dart';
import 'package:app/widgets/loading_dialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'login.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignupState();
}

class _SignupState extends State<SignUp> {
   TextEditingController userPhoneTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  checkIfNetworkAvailable() {
   cMethods.checkConnectivity(context);
   signUpFormValidation();
  }
  signUpFormValidation(){
    if(userNameTextEditingController.text.trim().length<3){
      cMethods.displaySnackbar("User name must be at least 3 characters", context);}
      else if(userPhoneTextEditingController.text.trim().length<10){
      cMethods.displaySnackbar("Phone number must be at least 10 digits", context);
      }
      else if(emailTextEditingController.text.contains("@") == false){
      cMethods.displaySnackbar("Email is not valid", context);}
      else if(passwordTextEditingController.text.trim().length<6){
      cMethods.displaySnackbar("Password must be at least 6 characters", context);}
      else{
        registerNewUser();
      }
  }
  registerNewUser()async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=>LoadingDialogue(messageText: "Registering your account..." ),
    );
    final UserCredential? userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim())
        .catchError((error) {
      Navigator.pop(context);
      cMethods.displaySnackbar(error.toString(), context);
    });

    final User? userFirebase = userCredential?.user;
    if(!context.mounted || userFirebase == null) {
      return;
    }
    Navigator.pop(context);
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(userFirebase.uid);

    Map userDataMap = {
      "name": userNameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "phone": userPhoneTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus":"no", 
    };
    userRef.set(userDataMap);
        Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
  }
  
    
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', height: 100),
              Text(
                "Create a User\'s Account",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              // textfields for email and password
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      controller: userNameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Name",
                        labelStyle: TextStyle(fontSize: 14),
                        
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                      ),
                    ),

                    const SizedBox(height: 22),
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
                      controller: userPhoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone No.",
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
                        checkIfNetworkAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(horizontal: 80,vertical: 10)
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LogIn()),
                        );
                      },
                      child: const Text(
                        "Already have an account? Sign In",
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
