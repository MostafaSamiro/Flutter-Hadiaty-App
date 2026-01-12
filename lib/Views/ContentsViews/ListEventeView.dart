import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:holidate/main.dart';
import 'package:sizer/sizer.dart';

class ListEvents extends StatefulWidget {
  const ListEvents({super.key});

  @override
  State<ListEvents> createState() => _ListEventsState();
}

class _ListEventsState extends State<ListEvents> {

  static const String exit = '''
<svg width="23" height="22" viewBox="0 0 23 22" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M17.25 5.5L5.75 16.5" stroke="#6B7280" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M5.75 5.5L17.25 16.5" stroke="#6B7280" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
  
  
  
   ''';
  
  static const String arrows = ''' 
  <svg width="22" height="14" viewBox="0 0 22 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M4.9828 0.695644L0.233949 5.02901C-0.0193737 5.27216 -0.106545 5.79392 0.173798 6.07838C0.454319 6.36286 0.986414 6.36101 1.26483 6.07469L4.7484 2.89999L4.7484 12.7777C4.7484 13.1766 5.08419 13.5 5.49826 13.5C5.91234 13.5 6.24813 13.1766 6.24813 12.7777L6.24813 2.89999L9.7317 6.07469C10.0101 6.36101 10.5624 6.37999 10.8227 6.07838C11.0633 5.79962 11.0738 5.28209 10.7626 5.02901L6.01373 0.695644C5.82195 0.511425 5.31756 0.367848 4.98264 0.695644H4.9828Z" fill="white"/>
<path d="M15.9828 13.3044L11.2339 8.97099C10.9806 8.72784 10.8935 8.20608 11.1738 7.92162C11.4543 7.63714 11.9864 7.63899 12.2648 7.92531L15.7484 11.1L15.7484 1.22227C15.7484 0.823442 16.0842 0.5 16.4983 0.5C16.9123 0.5 17.2481 0.823429 17.2481 1.22227L17.2481 11.1L20.7317 7.92531C21.0101 7.63899 21.5624 7.62001 21.8227 7.92162C22.0633 8.20038 22.0738 8.71791 21.7626 8.97099L17.0137 13.3044C16.822 13.4886 16.3176 13.6322 15.9826 13.3044H15.9828Z" fill="white"/>
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _montheController = TextEditingController();

  // Upload Event to Firestore under events/{uid}/user_events
  Future<void> _uploadEvent() async {
    final name = _nameController.text.trim();
    final status = _statusController.text.trim();
    final day = _dayController.text.trim();
    final month = _montheController.text.trim();

    if (name.isEmpty || status.isEmpty || day.isEmpty||month.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      final uid = auth.currentUser!.uid;

      await _firestore
          .collection('events')
          .doc(uid)
          .collection('user_events')
          .add({
        'name': name,
        'status': status,
        'day': day,
        'month':month,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.of(context).pop(); // Close bottom sheet
      _nameController.clear();
      _statusController.clear();
      _dayController.clear();
      _montheController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading event: ${e.toString()}")),
      );
    }
  }

  void _showAddEventSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),side: BorderSide(color: Color(0xffF7CFD8),width: 4),
      ),
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10,left: 10),
                child: Row(
                  children: [
                    InkWell(onTap: (){
                      Navigator.pop(context);
                    },child: SvgPicture.string(exit)),
                  ],
                ),
              ),
              Text("Add Event", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
              SizedBox(height: 5.h,),
              Container(
                width: 308,
                  height: 48.89,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffE6DCCD),width: 2),
                  borderRadius: BorderRadius.circular(16)
                ),

                child: TextField(

                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(labelText: "Name",contentPadding: EdgeInsets.only(left: 10),labelStyle: TextStyle(color: Color(0xff3F2D20,),fontSize: 14,fontWeight: FontWeight.w500),border: UnderlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),
              SizedBox(height: 2.h,),
              Container(
                width: 308,
                height: 48.89,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffE6DCCD),width: 2),
                    borderRadius: BorderRadius.circular(16)
                ),

                child: TextField(
                  keyboardType: TextInputType.name,

                  controller: _statusController,
                  decoration: InputDecoration(labelText: "Status",contentPadding: EdgeInsets.only(left: 10),labelStyle: TextStyle(color: Color(0xff3F2D20,),fontSize: 14,fontWeight: FontWeight.w500),border: UnderlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),
              SizedBox(height: 2.h,),
              Container(
                width: 308,
                height: 48.89,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffE6DCCD),width: 2),
                    borderRadius: BorderRadius.circular(16)
                ),

                child: TextField(
                  keyboardType: TextInputType.datetime,

                  controller: _dayController,
                  decoration: InputDecoration(labelText: "Day",contentPadding: EdgeInsets.only(left: 10),labelStyle: TextStyle(color: Color(0xff3F2D20,),fontSize: 14,fontWeight: FontWeight.w500),border: UnderlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),
              SizedBox(height: 2.h,),
              Container(
                width: 308,
                height: 48.89,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffE6DCCD),width: 2),
                    borderRadius: BorderRadius.circular(16)
                ),

                child: TextField(
                  keyboardType: TextInputType.name,

                  controller: _montheController,
                  decoration: InputDecoration(labelText: "Month",contentPadding: EdgeInsets.only(left: 10),labelStyle: TextStyle(color: Color(0xff3F2D20,),fontSize: 14,fontWeight: FontWeight.w500),border: UnderlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),


              SizedBox(height: 20),

              InkWell(
                onTap: (){
                  _uploadEvent();
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


  Future<void> _updateEvent(String docId) async {
    final name = _nameController.text.trim();
    final status = _statusController.text.trim();
    final day = _dayController.text.trim();
    final month = _montheController.text.trim();

    try {
      final uid = auth.currentUser!.uid;
      await _firestore
          .collection('events')
          .doc(uid)
          .collection('user_events')
          .doc(docId)
          .update({
        'name': name,
        'status': status,
        'day':day,
        'month':month
      });

      Navigator.of(context).pop();
      _nameController.clear();
      _statusController.clear();
      _dayController.clear();
      _montheController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating event: ${e.toString()}")),
      );
    }
  }
  Future<void> _deleteEvent(String docId) async {
    try {
      final uid = auth.currentUser!.uid;
      await _firestore
          .collection('events')
          .doc(uid)
          .collection('user_events')
          .doc(docId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting event: ${e.toString()}")),
      );
    }
  }
  void _showEditEventSheet(DocumentSnapshot doc) {
    _nameController.text = doc['name'];
    _statusController.text = doc['status'];
    _dayController.text = doc['day'];
    _montheController.text = doc['month'];

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
              Text("Edit Event", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
              SizedBox(height: 5.h),
              buildTextField("Name", _nameController),
              SizedBox(height: 2.h),
              buildTextField("Status", _statusController),
              SizedBox(height: 2.h),
              buildTextField("Day", _dayController),
              SizedBox(height: 2.h),
              buildTextField("Month", _montheController),
              SizedBox(height: 4.h),
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



  @override
  Widget build(BuildContext context) {
    final uid = auth.currentUser!.uid;

    return Scaffold(
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
                  Text("My event’s", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),)
                ],
              ),
            ),

            SizedBox(height: 5.h,),

            SizedBox(

              height: 100.h,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('events')
                    .doc(uid)
                    .collection('user_events')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Center(child: Text('Error loading events'));
                  if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) return Center(child: Text("No events added yet"));

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final event = docs[index];
                      return  Container(
                        margin: EdgeInsets.all(10),
                        width: 330,
                        height: 123,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff8E7DBE),width: 1),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10,left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Color(0xff8E7DBE),width: 3),
                                          borderRadius: BorderRadius.circular(20),
                                        ),

                                      ),
                                      SizedBox(width: 2.w,),
                                      Text(event['name'],style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),),

                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: RichText(text: TextSpan(
                                      text: "${event['day']} ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                      children: [
                                        TextSpan(
                                          text: event['month'],style: TextStyle(
                                            color: Color(0xff7c7c7c),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        )
                                        )
                                      ]
                                    ))
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 4.h,),

                            Padding(
                              padding: const EdgeInsets.only(top: 10,left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: event['status'] == 'upcoming' ? Color(0xff00D387) : event['status'] == 'current' ? Color(0xffFFD964) : Color(0xffFF4E40) ,
                                          borderRadius: BorderRadius.circular(20),
                                        ),

                                      ),
                                      SizedBox(width: 2.w,),
                                      Text(event['status'],style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),),

                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Row(
                                      children: [
                                        InkWell(onTap: (){
                                           _showEditEventSheet(snapshot.data!.docs[index]);
                                        },child: SvgPicture.string(edit)),
                                        SizedBox(width: 2.w,),
                                        InkWell(onTap: (){
                                          _deleteEvent(snapshot.data!.docs[index].id);
                                        },child: SvgPicture.string(remove)),
                                      ],
                                    ),
                                  )

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

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Left-aligned button
            InkWell(
              onTap: (){
                _showAddEventSheet();
              },
              child: Container(
                width: 230,  // Set width
                height: 44,  // Set height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38),  // Set border radius
                  color: Color(0xff8E7DBE),  // Set color for the button
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Add",
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

            // Right-aligned button (Cancel button)
            InkWell(
              onTap: (){
                print("object");
              },
              child: Container(
                width: 88,  // Set width
                height: 44,  // Set height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38),  // Set border radius
                  color: Color(0xff8E7DBE),  // Set color for the button
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "Sort",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 1.h,),

                    SvgPicture.string(arrows),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
