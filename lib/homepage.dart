import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key, required this.username, required this.password});
  final String? username;
  final String? password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              username??"fff",
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.black, fontSize: 30),
            ),
            Text(password??"hhhhh",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontSize: 30),),

          ],
        ),

      ),
    );
  }
}
