import 'package:flutter/material.dart';

class LoadingDialogue extends StatelessWidget {
  final String messageText;
  const LoadingDialogue({super.key, required this.messageText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.black87,
      content: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(width: 5,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
              const SizedBox(width: 8,),
              Text(
                messageText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )
            ],
          )
        )
      )
    );
  }
}