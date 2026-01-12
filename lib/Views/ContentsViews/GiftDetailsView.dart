import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class GiftDetails extends StatefulWidget {
  const GiftDetails({super.key});

  @override
  State<GiftDetails> createState() => _GiftDetailsState();
}

class _GiftDetailsState extends State<GiftDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController _giftN = TextEditingController();
  final TextEditingController _gifD = TextEditingController();
  final TextEditingController _gifC = TextEditingController();
  final TextEditingController _gifP = TextEditingController();
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _gifChoose = TextEditingController();

  File? file;

  @override
  void initState() {
    super.initState();
    loadSavedImage(); // تحميل الصورة المحفوظة
  }

  // حفظ الصورة في SharedPreferences
  Future<void> saveImageToPrefs(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    await prefs.setString('giftImage', base64Image);
  }

  // تحميل الصورة من SharedPreferences
  Future<void> loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('giftImage');
    if (base64Image == null) return;

    final bytes = base64Decode(base64Image);
    final tempDir = Directory.systemTemp;
    final imageFile = await File('${tempDir.path}/temp_image.png').writeAsBytes(bytes);

    setState(() {
      file = imageFile;
    });
  }

  // اختيار صورة من المعرض
  getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      file = File(image.path);
      setState(() {});
    }
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Container(
      width: 308,
      height: 48.89,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffE6DCCD), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.only(left: 10),
          labelStyle: TextStyle(color: Color(0xff3F2D20), fontSize: 14, fontWeight: FontWeight.w500),
          border: UnderlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Future<void> _uploadGifts() async {
    final gN = _giftN.text.trim();
    final gD = _gifD.text.trim();
    final gC = _gifC.text.trim();
    final gP = _gifP.text.trim();
    final eventName = _eventName.text.trim();
    final gChoose = _gifChoose.text.trim();

    if (gN.isEmpty || gD.isEmpty || gC.isEmpty || gP.isEmpty || gChoose.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
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

      final dataToUpload = {
        'gN': gN,
        'gD': gD,
        'gC': gC,
        'gP': gP,
        'EN': eventName,
        'gChoose': gChoose,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // إذا في صورة، أضفها
      if (base64Image != null) {
        dataToUpload['imageBase64'] = base64Image;
      }

      await _firestore
          .collection('gifts')
          .doc(uid)
          .collection('user_gifts')
          .add(dataToUpload);

      // إفراغ الحقول
      _giftN.clear();
      _gifD.clear();
      _gifC.clear();
      _gifP.clear();
      _eventName.clear();
      _gifChoose.clear();

      // حذف الصورة من الواجهة
      setState(() {
        file = null;
      });

      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gift uploaded successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading gifts: ${e.toString()}")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'home');
                      },
                      child: Icon(Icons.arrow_back_outlined, color: Colors.black, size: 30)),
                  SizedBox(width: 25.w),
                  Text(
                    "Gift Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  )
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Container(
              width: 328,
              height: 570,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff8E7DBE), width: 3),
                  borderRadius: BorderRadius.circular(22)),
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  InkWell(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                        width: 290,
                        height: 163,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff8E7DBE), width: 3),
                            borderRadius: BorderRadius.circular(22),
                          image: DecorationImage(image: file !=null? FileImage(file!): AssetImage("assets/images/Img.png"),fit: file!=null ? BoxFit.cover:BoxFit.none)
                        ),
                        ),
                  ),
                  SizedBox(height: 2.h),
                  buildTextField("Gift Name", _giftN),
                  SizedBox(height: 1.h),
                  buildTextField("Dscription", _gifD),
                  SizedBox(height: 1.h),
                  buildTextField("Category", _gifC),
                  SizedBox(height: 1.h),
                  buildTextField("Price", _gifP),
                  SizedBox(height: 1.h),
                  buildTextField("Event Name", _eventName),
                  SizedBox(height: 1.h),
                  buildTextField("available/pledged", _gifChoose),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _uploadGifts();
              },
              child: Container(
                width: 330,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38),
                  color: Color(0xff8E7DBE),
                ),
                child: Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
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
