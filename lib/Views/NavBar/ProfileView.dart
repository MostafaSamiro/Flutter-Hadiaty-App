import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const String exit = '''
<svg width="23" height="22" viewBox="0 0 23 22" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M17.25 5.5L5.75 16.5" stroke="#6B7280" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M5.75 5.5L17.25 16.5" stroke="#6B7280" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
  
  
  
   ''';

  TextEditingController _nameController = TextEditingController();
  File? file;
  Uint8List? imageBytes;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;


    File?file;
    Future<void> getImage(Function setModalState) async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        file = File(image.path);
        imageBytes = await file!.readAsBytes();
        setModalState(() {}); // Update image in bottom sheet
      }
    }

    Future<void> _updateEvent(String docId) async {
      final name = _nameController.text.trim();
      String? base64Image;

      if (file != null) {
        final bytes = await file!.readAsBytes();
        base64Image = base64Encode(bytes);
      }

      try {
        final uid = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance
            .collection('userData')
            .doc(uid)
            .collection('user_data')
            .doc(docId)
            .update({
          'userName': name,
          if (base64Image != null) 'imageBase64': base64Image,
        });

        Navigator.of(context).pop();
        _nameController.clear();
        file = null;
        imageBytes = null;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: ${e.toString()}")),
        );
      }
    }

    void _showEditEventSheet(DocumentSnapshot doc) {
      _nameController.text = doc['userName'];
      imageBytes = base64Decode(doc['imageBase64']);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          side: BorderSide(color: Color(0xffF7CFD8), width: 4),
        ),
        builder: (_) => StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          file = null;
                          imageBytes = null;
                          Navigator.pop(context);
                        },
                        child: SvgPicture.string(exit),
                      ),
                    ],
                  ),
                  Text("Edit Profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                  SizedBox(height: 3.h),
                  InkWell(
                    onTap: () => getImage(setModalState),
                    child: Container(
                      width: 122,
                      height: 122,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff8e7dbe), width: 4),
                        borderRadius: BorderRadius.circular(100),
                        image: imageBytes != null
                            ? DecorationImage(image: MemoryImage(imageBytes!), fit: BoxFit.cover)
                            : null,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Edit Pic", style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  buildTextField("Name", _nameController),
                  SizedBox(height: 2.h),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _updateEvent(doc.id);
                      Navigator.pop(context);

                    } ,
                    child: Container(
                      width: 230,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: Color(0xffF7CFD8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }




    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50,left: 20),
            child: Row(
              children: [
                InkWell(onTap: (){
                  Navigator.pushReplacementNamed(context, 'home');
                },child: Icon(Icons.arrow_back_outlined, color: Colors.black, size: 30,)),
                SizedBox(width: 30.w,),
                Text("Profile", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),),

              ],
            ),
          ),
          SizedBox(
            height: 27.h,
            child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("userData")
                    .doc(uid)
                    .collection("user_data").snapshots(),
                builder: (context, snapshot){
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No data available'));
                  }

                  final docs = snapshot.data!.docs;




                  return ListView.builder(

                      itemCount: 1, itemBuilder: (ctx,i){
                    final udata = docs[i];

                    // Decode Base64 to image bytes
                    Uint8List? imageBytes;
                    final imageBase64 = udata['imageBase64'];
                    if (imageBase64 != null) {
                      imageBytes = base64Decode(imageBase64);
                    }

                    return Container(
                      height: 40.h,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Container(
                                width: 122,
                                height: 122,
                                decoration: BoxDecoration(
                                    border:Border.all(color: Color(0xff8e7dbe),width: 4),
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(image: imageBytes != null?
                                    MemoryImage(imageBytes) :
                                    AssetImage("assets/images/profImg.png"),
                                        fit: BoxFit.cover
                                    )
                                ),

                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(udata['userName'],style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),)
                          ],
                        ),
                        SizedBox(height: 2.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                _showEditEventSheet(snapshot.data!.docs[i]);
                              },
                              child: Container(
                                width: 105,
                                height: 29,
                                decoration: BoxDecoration(
                                  color:Color(0xff8E7DBE),
                                  borderRadius: BorderRadius.circular(19)
                                ),
                                child:Center(
                                  child: Text('Edit Profile',style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),),
                                ),
                              ),
                            )
                          ],
                        )

                      ],),
                    );
                  });

                }),
          ),
          Divider(color: Color(0xff8E7DBE),thickness: 5,)


        ],
      ),
    );
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
}
