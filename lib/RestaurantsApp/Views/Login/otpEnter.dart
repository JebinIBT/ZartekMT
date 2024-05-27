import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../HomePage/homepage.dart';

class OtpScreen extends StatefulWidget {
  final String verficationId;
  const OtpScreen({super.key, required this.verficationId});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}
class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Image.asset(
                'assets/5847f40ecef1014c0b5e488a.png',
                width: 250,
              ),
              SizedBox(
                height: 100,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: otpController,
                decoration: InputDecoration(
                  prefixIconColor: Colors.grey,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter your OTP',
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey),
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey),
                    borderRadius: new BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      PhoneAuthCredential cred = await PhoneAuthProvider.credential(
                          verificationId: widget.verficationId,
                          smsCode: otpController.text.toString());
                      await FirebaseAuth.instance.signInWithCredential(cred).then((value) {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));

                      });

                    } catch (error) {
                      log(error.toString());
                    }
                  },
                  child: Text(
                    "Next",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
