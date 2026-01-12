import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/vector2.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Foreground content
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomTextFieldContainer(
                                  hintText: "Your Email",
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an email';
                                    }
                                    // Email validation regex
                                    String emailPattern =
                                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                                    RegExp regExp = RegExp(emailPattern);
                                    if (!regExp.hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 1.h),
                                CustomTextFieldContainer(
                                  hintText: "Password",
                                  obscureText: true,
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters';
                                    }
                                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                                      return 'Password must contain at least one number';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 1.h),
                                CustomTextFieldContainer(
                                  hintText: "Name",
                                  keyboardType: TextInputType.name,
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 1.h),
                                CustomTextFieldContainer(
                                  hintText: "Date of birth",
                                  keyboardType: TextInputType.datetime,
                                  controller: dobController,
                                  suffixIcon: Icon(
                                    Icons.calendar_month_outlined,
                                    color: Color(0xffBCB3AB),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your date of birth';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async{
                                        if (_formKey.currentState?.validate() ?? false) {
                                          // Perform Sign Up Logic here
                                        }
                                        try {
                                          final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                          Navigator.pushReplacementNamed(context, 'login') ;
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == 'weak-password') {
                                            print('The password provided is too weak.');
                                          } else if (e.code == 'email-already-in-use') {
                                            print('The account already exists for that email.');
                                          }
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Container(
                                        width: 70.w,
                                        height: 6.h,
                                        decoration: BoxDecoration(
                                          color: Color(0xff8E7DBE),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Sign Up",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "by Signing in you accept our term of Services and",
                                style: TextStyle(
                                    color: Color(0xff55565A),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Privacy Policy",
                                style: TextStyle(
                                    color: Color(0xff8E7DBE),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(
                                    color: Color(0xff73665C),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Sign In",
                                      style: TextStyle(
                                        color: Color(0xff8E7DBE),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      recognizer: TapGestureRecognizer()..onTap = () {
                                        Navigator.pushReplacementNamed(context, 'login');
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextFieldContainer extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextFieldContainer({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffe9e0d3), width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xff3F2D20),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
