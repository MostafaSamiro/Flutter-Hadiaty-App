import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class GiftPage extends StatefulWidget {
  const GiftPage({super.key});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {

  static const String flag = ''' 
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M5.15039 2V22" stroke="#292D32" stroke-width="3.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M5.15039 4H16.3504C19.0504 4 19.6504 5.5 17.7504 7.4L16.5504 8.6C15.7504 9.4 15.7504 10.7 16.5504 11.4L17.7504 12.6C19.6504 14.5 18.9504 16 16.3504 16H5.15039" stroke="#8E7DBE" stroke-width="2.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
</svg>

  
  
  ''';

  static const String edit = ''' 
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M19.0206 3.47967C17.0806 1.53967 15.1806 1.48967 13.1906 3.47967L11.9806 4.68967C11.8806 4.78967 11.8406 4.94967 11.8806 5.08967C12.6406 7.73967 14.7606 9.85967 17.4106 10.6197C17.4506 10.6297 17.4906 10.6397 17.5306 10.6397C17.6406 10.6397 17.7406 10.5997 17.8206 10.5197L19.0206 9.30967C20.0106 8.32967 20.4906 7.37967 20.4906 6.41967C20.5006 5.42967 20.0206 4.46967 19.0206 3.47967Z" fill="#B28CFF"/>
<path d="M15.6103 11.5298C15.3203 11.3898 15.0403 11.2498 14.7703 11.0898C14.5503 10.9598 14.3403 10.8198 14.1303 10.6698C13.9603 10.5598 13.7603 10.3998 13.5703 10.2398C13.5503 10.2298 13.4803 10.1698 13.4003 10.0898C13.0703 9.80981 12.7003 9.44981 12.3703 9.04981C12.3403 9.0298 12.2903 8.9598 12.2203 8.8698C12.1203 8.7498 11.9503 8.5498 11.8003 8.3198C11.6803 8.1698 11.5403 7.9498 11.4103 7.7298C11.2503 7.4598 11.1103 7.1898 10.9703 6.9098C10.9491 6.86441 10.9286 6.81924 10.9088 6.77434C10.7612 6.44102 10.3265 6.34358 10.0688 6.60133L4.34032 12.3298C4.21032 12.4598 4.09032 12.7098 4.06032 12.8798L3.52032 16.7098C3.42032 17.3898 3.61032 18.0298 4.03032 18.4598C4.39032 18.8098 4.89032 18.9998 5.43032 18.9998C5.55032 18.9998 5.67032 18.9898 5.79032 18.9698L9.63032 18.4298C9.81032 18.3998 10.0603 18.2798 10.1803 18.1498L15.9016 12.4285C16.1612 12.1689 16.0633 11.7235 15.7257 11.5794C15.6877 11.5632 15.6492 11.5467 15.6103 11.5298Z" fill="#B28CFF"/>
</svg>

  
  
  ''';

  static const String remove = ''' 
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M21 5.98047C17.67 5.65047 14.32 5.48047 10.98 5.48047C9 5.48047 7.02 5.58047 5.04 5.78047L3 5.98047" stroke="#FF4E40" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M8.5 4.97L8.72 3.66C8.88 2.71 9 2 10.69 2H13.31C15 2 15.13 2.75 15.28 3.67L15.5 4.97" stroke="#FF4E40" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M18.8504 9.13965L18.2004 19.2096C18.0904 20.7796 18.0004 21.9996 15.2104 21.9996H8.79039C6.00039 21.9996 5.91039 20.7796 5.80039 19.2096L5.15039 9.13965" stroke="#FF4E40" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M10.3301 16.5H13.6601" stroke="#FF4E40" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M9.5 12.5H14.5" stroke="#FF4E40" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>

  
  
  ''';
  static const String exit = '''
<svg width="23" height="22" viewBox="0 0 23 22" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M17.25 5.5L5.75 16.5" stroke="#6B7280" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M5.75 5.5L17.25 16.5" stroke="#6B7280" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
  
  
  
   ''';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController _giftN = TextEditingController();
  final TextEditingController _gifD = TextEditingController();
  final TextEditingController _gifC = TextEditingController();
  final TextEditingController _gifP = TextEditingController();
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _gifChoose = TextEditingController();

  Future<void> _updateEvent(String docId) async {
    final gN = _giftN.text.trim();
    final gD = _gifD.text.trim();
    final gC = _gifC.text.trim();
    final gP = _gifP.text.trim();
    final eventName = _eventName.text.trim();
    final gChoose = _gifChoose.text.trim();

    try {
      final uid = auth.currentUser!.uid;
      await _firestore
          .collection('gifts')
          .doc(uid)
          .collection('user_gifts')
          .doc(docId)
          .update({
        'gN': gN,
        'gD': gD,
        'gC': gC,
        'gP': gP,
        'EN': eventName,
        'gChoose': gChoose,
        'createdAt': FieldValue.serverTimestamp(),
      });

      //Navigator.of(context).pop();
      _giftN.clear();
      _gifD.clear();
      _gifC.clear();
      _gifP.clear();
      _eventName.clear();
      _gifChoose.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating gift: ${e.toString()}")),
      );
    }
  }
  Future<void> _deleteEvent(String docId) async {
    try {
      final uid = auth.currentUser!.uid;
      await _firestore
          .collection('gifts')
          .doc(uid)
          .collection('user_gifts')
          .doc(docId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting gift: ${e.toString()}")),
      );
    }
  }
  void _showEditEventSheet(DocumentSnapshot doc) {
    _giftN.text = doc['gN'];
    _gifD.text = doc['gD'];
    _gifC.text = doc['gC'];
    _gifP.text = doc['gP'];
    _eventName.text = doc['EN'];
    _gifChoose.text = doc['gChoose'];


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: Color(0xffF7CFD8), width: 4),
      ),
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InkWell(onTap: () {
                    Navigator.pop(context);
                  }, child: SvgPicture.string(exit)),
                ],
              ),
              Text("Edit Gift", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
              SizedBox(height: 5.h),
              SizedBox(height: 2.h,),
              buildTextField("Gift Name",_giftN),
              SizedBox(height: 1.h,),
              buildTextField("Dscription",_gifD),
              SizedBox(height: 1.h,),
              buildTextField("Category",_gifC),
              SizedBox(height: 1.h,),
              buildTextField("Price",_gifP),
              SizedBox(height: 1.h,),
              buildTextField("Event Name",_eventName),
              SizedBox(height: 1.h,),
              buildTextField("available/pledged",_gifChoose),
              SizedBox(height: 20),

              InkWell(
                onTap: (){
                  _updateEvent(doc.id);
                },
                child: Container(
                  width: 230,  // Set width
                  height: 44,  // Set height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38),  // Set border radius
                    color: Color(0xffF7CFD8),  // Set color for the button
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
                      // Space between the text and the button
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
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



  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = auth.currentUser!.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50,left: 20),
              child: Row(
                children: [
                  InkWell(onTap: (){
                    Navigator.pushReplacementNamed(context, 'home');
                  },child: Icon(Icons.arrow_back_outlined, color: Colors.black, size: 30,)),
                  SizedBox(width: 25.w,),
                  Text("My wishes", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),),
                  SizedBox(width: 25.w,),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacementNamed(context,'giftD');

                    },
                    child: Icon(Icons.add,size: 30,),
                  )
                ],
              ),
            ),
            SizedBox(height: 3.h,),
            SizedBox(

              height: 700,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('gifts')
                    .doc(uid)
                    .collection('user_gifts')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Center(child: Text('Error loading gifts'));
                  if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) return Center(child: Text("No gifts added yet"));

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final gifts = docs[index];

                      // Decode Base64 to image bytes
                      Uint8List? imageBytes;
                      final imageBase64 = gifts['imageBase64'];
                      if (imageBase64 != null) {
                        imageBytes = base64Decode(imageBase64);
                      }

                      return Container(
                        margin: EdgeInsets.all(10),
                        width: 333,
                        height: 430,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff8E7DBE), width: 3),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showEditEventSheet(snapshot.data!.docs[index]);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.string(edit),
                                      Text(
                                        "Edit",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                InkWell(
                                  onTap: () {
                                    _deleteEvent(snapshot.data!.docs[index].id);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.string(remove),
                                      Text(
                                        "remove",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Container(
                              width: 312,
                              height: 198,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff8E7DBE), width: 3),
                                borderRadius: BorderRadius.circular(22),
                                image: imageBytes != null
                                    ? DecorationImage(
                                  image: MemoryImage(imageBytes),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                            ),
                            SizedBox(height: 2.h,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(gifts['gN'],style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,

                                  ),),
                                  SizedBox(width: 10.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Row(children: [
                                      Container(
                                        width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: getRandomColor(),
                                            borderRadius: BorderRadius.circular(12)
                                          ),
                                      ),
                                      SizedBox(width: 2.w,),
                                      Text(gifts['gC'],style: TextStyle(
                                        color: Color(0xff8E7DBE),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,

                                      ),),
                                    ],),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      gifts['gD'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: true,
                                       // or fade/clip
                                     // Optional: limit number of lines
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.string(flag),
                                      SizedBox(width: 2.w,),
                                      Text(gifts['EN'],style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold

                                      ),)

                                    ],


                                  ),
                                  Row(
                                    children: [
                                      RichText(text: TextSpan(text: gifts['gP'],style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500
                                      ),children: [
                                        TextSpan(text: " EGP",style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold

                                        ))
                                      ]))
                                    ],
                                  ),



                                ],
                              ),
                            ),
                            SizedBox(height: 1.h,),

                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                RichText(text: TextSpan(text: "Pldeged by: ",style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),children: [
                                  TextSpan(text: gifts['gChoose'],style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500

                                  ))
                                ]))
                                ],
                              ),
                            ),


                          ],
                        ),
                      );

                    },
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
