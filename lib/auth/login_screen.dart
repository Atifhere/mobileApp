import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_saloon/auth/update_password.dart';
import 'package:hair_saloon/controllers/login_controller.dart';
import 'package:hair_saloon/halper/app_colors.dart';
import 'package:hair_saloon/halper/methods.dart';
import 'package:hair_saloon/home.dart';

import '../widgets/text_field_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBrown,
      body: GetBuilder(
        init: LoginController(),
          builder: (controller) {
            return Center(
              child: Padding(
                padding: REdgeInsets.symmetric(horizontal: 30.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/logo3.png', width: 300.w),
                      const _TitleWidget(),
                      SizedBox(height: 30.h),
                      TextFieldWidget(hintText: 'User Name',controller: controller.userName.value,),
                      SizedBox(height: 20.h),
                      TextFieldWidget(hintText: 'Password', obscureText: true,controller: controller.password.value),
                      SizedBox(height: 10.h),
                      const _RememberMeWidget(),
                      SizedBox(height: 20.h),
                      Obx(() {
                        if(controller.isLoading.value){
                          return Center(child: loading());
                        }else{
                          return _SignInButtonWidget(controller.login);
                        }
                      },),
                      SizedBox(height: 10.h),
                      const _ForgotPasswordWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
      ),
    );
  }
}

// Title Widget
class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Log In',
      style: GoogleFonts.dancingScript(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 40.sp,
      ),
    );
  }
}

// TextField Widget

// Remember Me Widget
class _RememberMeWidget extends StatefulWidget {
  const _RememberMeWidget();

  @override
  State<_RememberMeWidget> createState() => _RememberMeWidgetState();
}

class _RememberMeWidgetState extends State<_RememberMeWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: isChecked ? AppColors.appOrange : Colors.orange),
          ),
          checkColor: Colors.white,
          activeColor: const Color(0XFFE66E0D),
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
        ),
        Text(
          'Remember me',
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.sp),
        ),
      ],
    );
  }
}

// Sign In Button Widget
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
          'Sign in',
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.sp),
        ),
      ),
    );
  }
}

// Forgot Password Widget
class _ForgotPasswordWidget extends StatelessWidget {
  const _ForgotPasswordWidget();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(()=>const UpdatePassword(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1)),
      child: Text(
        'Update Password?',
        style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.sp),
      ),
    );
  }
}
