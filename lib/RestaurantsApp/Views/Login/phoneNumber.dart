import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'otpEnter.dart';

class EnterPhone extends StatelessWidget {
  TextEditingController phoneController = TextEditingController();

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
                controller: phoneController,
                decoration: InputDecoration(
                  prefixIconColor: Colors.grey,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter your Phone Number',
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
                    await FirebaseAuth.instance.verifyPhoneNumber(
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException ex) {},
                        codeSent:
                            (String verficationId, int? resendindToken) {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(verficationId:verficationId,)));
                            },
                        codeAutoRetrievalTimeout: (String verficationId) {},
                        phoneNumber: ('+91${phoneController.text.toString()}')
                    );

                    // FirebaseAuth.instance.verifyPhoneNumber(
                    //      phoneNumber:phoneController.text ,
                    //     verificationCompleted: (phoneAuthcerdential){
                    //
                    //     },
                    //     verificationFailed: (error){
                    //        log(error.toString() );
                    //     },
                    //     codeSent: (verficationId,forceResendindToken){
                    //       Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(verficationId:verficationId,)));
                    //
                    //     },
                    //     codeAutoRetrievalTimeout: (verficationId){
                    //        log('codeAutoRetrievalTimeout');
                    //     });
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
