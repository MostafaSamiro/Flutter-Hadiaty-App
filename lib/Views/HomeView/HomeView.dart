  import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with  TickerProviderStateMixin{
@override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }


  @override
  Widget build(BuildContext context) {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;


    return Scaffold(

      backgroundColor: Colors.white,

      body: SingleChildScrollView(child: Column(
        children: [

          SizedBox(
            height: 10.h,
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
                      height: 20.h,
                      child: Stack(
                        children: [
                          Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Row(

                                children: [
                                  SizedBox(width: 3.w,),

                                  Text("Good Morning,",style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500
                                  ),),

                                ],
                              ),
                            ),

                            Row(
                              children: [
                                SizedBox(width: 3.w,),

                                Text(udata['userName'],style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ),)
                              ],
                            ),
                          ],),
                          Padding(
                            padding: const EdgeInsets.only(top: 30,right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                Container(
                                  width: 60,
                                  height: 60,
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

                        ],
                      ),
                    );
                  });

                }),
          ),
          SizedBox(height: 3.h,),


          Container(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 330,
                    height: 313,
                    decoration: BoxDecoration(
                      color: Color(0xff8e7dbe),
                      borderRadius: BorderRadius.circular(36)
                    ),

                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20,left: 20),
                          child: Row(
                            children: [
                              Text("List of\nfriends",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              ),),


                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 100 , left: 20),
                          child: SizedBox(width: 266,height: 50,
                            child: ListView.builder(
                              itemCount: 3,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, i){
                                return Container(
                                  width: 53,
                                  height: 53,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 3),
                                    borderRadius: BorderRadius.circular(36),
                                    image: DecorationImage(image: AssetImage("assets/images/profImg.png"),fit: BoxFit.cover)
                                  ),

                                );

                            }),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 100,left: 170),
                          child: InkWell(
                            onTap: (){
                              print("object");
                            },
                            child: Container(

                              width: 53,
                              height: 53,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(36),

                              ),
                              child: Center(child: Icon(Icons.arrow_forward,color: Color(0xff8e7dbe),),),

                            ),
                          ),
                        )



                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 120,left: 25),
                  child: Image.asset("assets/images/zina.png"),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("My Event’s",style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: (){
                      Navigator.pushReplacementNamed(context, 'lEvents');
                    },
                    child: Container(
                      width: 87,
                      height: 37,
                      decoration: BoxDecoration(
                        color: Color(0xff8E7DBE),
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("View all",style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),),
                          Icon(Icons.arrow_forward,color: Colors.white,)

                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 1.h,),

          SizedBox(
            height: 250,
            child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('events')
                    .doc(uid)
                    .collection('user_events')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
              builder: (context,snapshot) {
                if (snapshot.hasError) return Center(child: Text('Error loading events'));
                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) return Center(child: Text("No events added yet"));
                return ListView.builder(


                    scrollDirection: Axis.vertical,
                    itemCount:docs.length,
                    itemBuilder: (ctx,i){
                      final event = docs[i];
                  return Container(
                    margin: EdgeInsets.all(10),
                    width:329 ,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Color(0xffF7CFD8),
                      borderRadius: BorderRadius.circular(36)
                    ),
                    child:Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(event['name'],style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                  ),),
                                ],
                              ),
                            ),
                           Padding(
                             padding: const EdgeInsets.only(left: 10),
                             child: Row(
                               children: [
                                 RichText(text: TextSpan(text: "${event['day'] } ",style: TextStyle(
                                   color: Color(0xff8E7DBE),
                                   fontSize: 24,
                                   fontWeight:FontWeight.w600
                                 ),children: [
                                   TextSpan(text: event['month'],style: TextStyle(
                                     color: Color(0xff8c767b),
                                     fontSize: 24,
                                     fontWeight: FontWeight.w600
                                   ))
                                 ]),),
                               ],
                             ),
                           )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10,right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset("assets/images/Zina2.png"),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                });
              }
            ),
          ),









        ],
      )),

    );
  }


}


