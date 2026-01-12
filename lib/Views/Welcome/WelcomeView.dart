import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:holidate/Svg.dart';
import 'package:holidate/main.dart';
import 'package:sizer/sizer.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: 100.w,
        height: 100.h,

        decoration:BoxDecoration(

          image: DecorationImage(image:AssetImage("assets/images/Welcome.png"),fit: BoxFit.contain)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(
              children: [
                SizedBox(width: 3.w,),
                Text("Join Hadiaty",style: TextStyle(
                  color: Colors.black,
                  fontSize: 33,
                  fontWeight: FontWeight.bold
                ),)
              ],
            ),
            Row(
              children: [
                SizedBox(width: 3.w,),
                Text("Your new favorite place for giving, receiving,\n and celebrating!",style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                ),)
              ],
            ),
            SizedBox(height: 1.h,),
            Row(
              children: [
                SizedBox(width: 3.w,),
                InkWell(
                  onTap: (){
                    Navigator.pushReplacementNamed(context, 'signup') ;

                  },
                  child: Container(
                    width: 14.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: Color(0xff8E7DBE),
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: Icon(Icons.arrow_forward ,color: Colors.white,),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
