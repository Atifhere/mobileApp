import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hair_saloon/halper/methods.dart';
import 'package:hair_saloon/services/api_services.dart';

class UpdatePasswordController extends GetxController{

  var userName=TextEditingController().obs;
  var password=TextEditingController().obs;
  var conPassword=TextEditingController().obs;
  RxBool isLoading=false.obs;
  ApiServices services=ApiServices();



  forgetPassword()async{

    if(userName.value.text.isEmpty||password.value.text.isEmpty){
      showError("Fill all the Blanks.");
      return;
    }

    if(password.value.text!=conPassword.value.text){
      showError("Password & Confirm Password Dost Match");
      return;
    }

    if(!isStrongPassword(password.value.text)){
     showError("Enter Strong Password.");
     return;
    }


    isLoading(true);
    await services.updatePassword(userName.value.text, password.value.text).then((value) {
      final Map<String,dynamic> response=value.data as Map<String,dynamic>;
      if(value.statusCode==200){
        showSuccess("Password Update Successfully.");
        isLoading(false);
        Get.back();
      }else{
        showError(response['errorMessage']);
        isLoading(false);
      }
    },);



  }

  bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;

    return true;
  }
}