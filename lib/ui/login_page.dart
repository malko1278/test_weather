
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:test_weather/ui/weather_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<LoginPage> {
  late TextEditingController _phonController;
  late TextEditingController _pinPutController;
  late FocusNode _pinPutFocusNode;
  late bool isVisible;
  late bool isActive;
  late String _verificationCode;
  late String _smsCode;
  late String _phoneNumber;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    // TODO: implement initState
    if (_auth.currentUser != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const WeatherPage(),
        ),
        (route) => false,
      );
    }
    super.initState();
    _phonController = TextEditingController();
    _pinPutController = TextEditingController();
    _pinPutFocusNode = FocusNode();
    isVisible = false;
    isActive = false;
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _phonController.dispose();
    _pinPutController.dispose();
    _pinPutFocusNode.dispose();
  }

  _verifyPhoneNumber() {
    if(isVisible == false) {
      if((_phonController.text != '') && (_phonController.text.length == 10)) {
        // If the form is valid, we want to show a loading Snackbar
        _phoneNumber = '+7${_phonController.text}';
        setState(() {
          // isVisible = true;
          isActive = true;
        });
        _askSMSCode();
      } else {
        if((_phonController.text != '') && (_phonController.text.length < 10)) {
          // Enter a valid number
          _showSnackBar("Введите действительный номер !!!");
        } else {
          // Please write the phone number
          _showSnackBar("Пожалуйста, напишите номер телефона !!!");
        }
      }
    } else {
      _verifySMSCode();
    }
  }

  _askSMSCode() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
        await _auth.signInWithCredential(credential).then((value) {
          if(value.user != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const WeatherPage()
              )
            );
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          // The provided phone number is not valid.
          _showSnackBar("Указанный номер телефона недействителен !!!");
        }
      },
      codeSent: (String verificationID, int? resentToken) async {
        setState(() {
          isVisible = true;
          _verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationCode = verificationId;
        });
      },
      timeout: const Duration(seconds:  40),
    );
  }

  _verifySMSCode() async {
    try{
      await _auth
        .signInWithCredential(
          PhoneAuthProvider.credential(
            verificationId: _verificationCode,
            smsCode: _smsCode,
          ),
        ).then((value) async => {
          // sign in was success
          if(value.user != null) {
            // store registration details in firestore database
            await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .set({'cellnumber': _phoneNumber,})
              .then((value) => {
                // then move to authorised area
                setState(() {
                  _showSnackBar("Перейдите на станицу погоды !!!");
                }),
              }),
            setState(() {
              _showSnackBar("Перейдите на станицу погоды !!!");
            }),
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => const WeatherPage()),
              (route) => false,
            ),
          }
        })
        .catchError((onError) async => {});
    } catch(e) {
      // FocusScope.of(context).unfocus();
      _showSnackBar("Недействительный выбор !!!");
    }
  }

  _showSnackBar(String msg) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: SizedBox(
        height: 30.0,  // 80.0
        child: Center(
          child: Text(msg,
            style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xff00A1FF).withOpacity(0.5),   // Colors.deepPurpleAccent,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    final BoxDecoration _pinPutDecoration = BoxDecoration(
      color: const Color(0xff00A1FF).withOpacity(0.5),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: const Color.fromRGBO(126, 203, 224, 1),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: SizedBox(
        width: double.infinity,
        height: _size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 130.0,),
                  child: const Center(
                    child: Text(
                      'Номер телефона',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  margin: const EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade200,                   // Colors.grey.shade500
                    border: Border.all(
                      color: Colors.grey.shade500,
                      width: 1.0,
                    ),
                  ),
                  child: TextField(
                    controller: _phonController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Введите ваш номер телефона',
                      prefix: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text('+7 '),
                      ),
                      counterText: "",
                    ),
                    maxLength: 10,
                  ),
                ),
                isVisible == false
                ? Visibility(
                  visible: isActive,
                  child: Container(
                    margin: const EdgeInsets.only(top: 30.0),
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.lightBlue,
                    )
                  ),
                )
                : Visibility(
                  visible: isActive,
                  child: Container(
                    margin: const EdgeInsets.only(left: 0.0, top: 30.0, right: 0.0,),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0,),
                      child: PinPut(
                        fieldsCount: 6,
                        withCursor: true,
                        textStyle: TextStyle(fontSize: 25.0, color: Colors.grey.shade800),
                        eachFieldWidth: 45.0,
                        eachFieldHeight: 55.0,
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                        submittedFieldDecoration: _pinPutDecoration,
                        selectedFieldDecoration: _pinPutDecoration,
                        followingFieldDecoration: _pinPutDecoration,
                        pinAnimationType: PinAnimationType.fade,
                        onSubmit: (String pinCode) {
                          setState(() {
                            _smsCode = pinCode;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0, bottom: 70.0),
              child: ElevatedButton(
                onPressed: _verifyPhoneNumber,
                child: Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Text(
                    'Аутентификации',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.black26;
                      }
                      return const Color(0xff00A1FF).withOpacity(0.5);
                    }
                  ),
                  // foregroundColor is red for all states.
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  elevation: MaterialStateProperty.resolveWith<double>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)
                          ||  states.contains(MaterialState.disabled)) {
                        return 0;
                      }
                      return 10;
                    },
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}