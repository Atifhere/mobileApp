import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_saloon/halper/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';


Future<dynamic> showSuccess(String title) async {
  return toastification.show(
    primaryColor: Colors.green,
    title: Text(
      title,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    ),
    autoCloseDuration: const Duration(seconds: 3), // Increase duration
    showProgressBar: false,
    icon: const Icon(
      Icons.check_circle_outline,
      color: Colors.white,
    ),
    style: ToastificationStyle.fillColored,
  );
}

ToastificationItem showError(String title){
  return toastification.show(
      primaryColor: Colors.red,
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      icon: const Icon(Icons.error,color: Colors.white,),
      style: ToastificationStyle.fillColored
  );
}

Widget loading(){
  return LoadingAnimationWidget.staggeredDotsWave(
      color: AppColors.appOrange,
      size:50
  );
}

Future<String> myToken()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("token").toString();
}

