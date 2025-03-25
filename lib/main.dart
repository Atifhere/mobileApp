import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hair_saloon/auth/login_screen.dart';
import 'package:hair_saloon/home.dart';
import 'package:hair_saloon/splash.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: ToastificationWrapper(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
            title: 'Hair Saloon',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialBinding: BindingsBuilder(() {
              Get.put(HomeController());
            },),
            home: const Splash(),
        ),
      ),
    );
  }
}

