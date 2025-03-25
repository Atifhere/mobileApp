import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_saloon/controllers/update_password_controller.dart';
import 'package:hair_saloon/halper/app_colors.dart';
import 'package:hair_saloon/halper/methods.dart';

import '../widgets/text_field_widget.dart';


class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  UpdatePasswordController controller=Get.put(UpdatePasswordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBrown,
      appBar: AppBar(
        backgroundColor: AppColors.appOrange,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white,)
        ),
        title: Text("Update Password",style: GoogleFonts.poppins(color: Colors.white),),
      ),

      body: Center(
        child: Padding(
          padding: REdgeInsets.only(left: 10.w,right: 10.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
            
            
            
                TextFieldWidget(controller: controller.userName.value,hintText: "userName",obscureText: false,),
                SizedBox(height: 20.h,),
                TextFieldWidget(controller: controller.password.value,hintText: "password",obscureText: true,),
                SizedBox(height: 20.h,),
                TextFieldWidget(controller: controller.conPassword.value,hintText: "confirm Password",obscureText: true,),
            
                SizedBox(height: 10.h,),
                Text("Note:",style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.sp),),
                SizedBox(height: 5.h,),
                Text("1) Please enter atlest one capital letter and one Number.",style: GoogleFonts.poppins(color: Colors.white),),
                Text("2) Minimum length is 8 characters",style: GoogleFonts.poppins(color: Colors.white),),
            
            
            
            
                SizedBox(height: 40.h,),
                
                Obx(() {
                  if(controller.isLoading.value){
                    return Center(child: loading());
                  }else{
                    return _SignInButtonWidget(controller.forgetPassword);
                  }
                },)
                
              ],
            ),
          ),
        ),
      ),

    );
  }



}



class _SignInButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  const _SignInButtonWidget(this.onTap);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFFE66E0D)),
        onPressed: onTap,
        child: Text(
          'Update Password',
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.sp),
        ),
      ),
    );
  }
}
