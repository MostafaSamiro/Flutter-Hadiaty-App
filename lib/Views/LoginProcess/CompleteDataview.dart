import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class CompleteData extends StatefulWidget {
  const CompleteData({super.key});

  @override
  State<CompleteData> createState() => _CompleteDataState();
}

class _CompleteDataState extends State<CompleteData> {

TextEditingController UserName = TextEditingController() ;
  final _formKey = GlobalKey<FormState>();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

File? file;
getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    file = File(image.path);
    setState(() {});
  }
}

Future<void> _uploadUData() async {
  final UN = UserName.text.trim();

  if (UN.isEmpty ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please fill name field")),
    );
    return;
  }

  try {
    final uid = auth.currentUser!.uid;

    // تحويل الصورة إلى base64
    String? base64Image;
    if (file != null) {
      final bytes = await file!.readAsBytes();
      base64Image = base64Encode(bytes);
    }

    final UserData = {
      'userName': UN,
      'createdAt': FieldValue.serverTimestamp(),
    };

    // إذا في صورة، أضفها
    if (base64Image != null) {
      UserData['imageBase64'] = base64Image;
    }

    await _firestore
        .collection('userData')
        .doc(uid)
        .collection('user_data')
        .add(UserData);

    // إفراغ الحقول
    UserName.clear();


    // حذف الصورة من الواجهة
    setState(() {
      file = null;
    });

    // إظهار رسالة نجاح
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login successfully!")),
    );
    Navigator.pushReplacementNamed(context, 'home');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error Login: ${e.toString()}")),
    );
  }
}


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
                  image: AssetImage("assets/images/upload.png"),
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
                    child: Column(

                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("HI, friend",style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold

                            ),)
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Let's get started ",style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w400

                            ),)
                          ],
                        ),
                        SizedBox(
                          height:5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(text: TextSpan(
                              text:"Set a profile picture ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold

                              ),
                              children: [
                                TextSpan(
                                  text:"(optional)",
                                  style: TextStyle(
                                      color: Color(0xffc0c0c0),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold

                                  ),
                                )
                              ]
                            ),

                            )

                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            InkWell(
                              onTap: (){
                                getImage();
                              },
                                child: file != null ? Container(width: 153,height: 153,decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(image: FileImage(file!),fit: BoxFit.cover)
                                )):Image.asset("assets/images/SelectImage.png"))

                          ],
                        ),
                        SizedBox(height: 4.h,),
                        IntrinsicHeight(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    Text(
                                      " Your Name ?",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                CustomTextFieldContainer(hintText: "Your Name", controller: UserName, ),


                                Spacer(),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h,),

                        InkWell(
                          onTap:(){
                            _uploadUData();

                          },
                          child: Container(
                            width: 308,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xff8E7DBE),
                              borderRadius: BorderRadius.circular(16)
                            ),
                            child: Center(
                              child: Text("Next",style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),),
                            ),
                          ),
                        )


                      ],
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
