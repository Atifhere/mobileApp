import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hair_saloon/halper/methods.dart';
import 'package:hair_saloon/home.dart';
import 'package:hair_saloon/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController{

  var userName=TextEditingController().obs;
  var password=TextEditingController().obs;
  ApiServices apiServices=ApiServices();
  RxBool isLoading=RxBool(false);





  void login() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(userName.value.text.isEmpty || password.value.text.isEmpty){
      showError("Invalid User or Password.");
      return;
    }
    isLoading(true);
    await apiServices.login(userName.value.text,password.value.text).then((value) {
      final Map<String,dynamic> response=value.data as Map<String,dynamic>;
      if(value.statusCode==200){
        showSuccess('Login Success...');
        isLoading(false);

        prefs.setString('token', response["token"]);
        prefs.setString('name', response["userName"]);
        Get.offAll(()=> const Home(),transition: Transition.zoom,duration:const Duration(seconds: 1));
      }else{
        isLoading(false);
        showError("${response['title']}");
      }

    },);
  }




}