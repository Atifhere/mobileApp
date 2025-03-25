import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_saloon/auth/login_screen.dart';
import 'package:hair_saloon/halper/app_colors.dart';
import 'package:hair_saloon/home.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBrown,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("images/Splash screen.png",height: 250.h,width: 250.w,),
              SizedBox(height: 10.h,),
              Text("One Stop Solution to Manage Your Salon Work.",style: GoogleFonts.poppins(
                color: Colors.white
              ),),
              SizedBox(height: 20.h,),
              RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Powered By:  ",
                        style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                        text: "Manage Salons",
                        style: GoogleFonts.poppins(color: Colors.white)
                      ),

                    ]
                  )
              ),



            ],
          )
      ),
    );
  }

  Future<void> checkLogin()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if(prefs.getString("token")==null){
        Get.offAll(()=>const LoginScreen());
      }else{
        Get.offAll(()=>const Home());
      }
    },);
  }

}
