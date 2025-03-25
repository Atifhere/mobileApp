import 'dart:convert';

import 'package:get/get.dart';
import 'package:hair_saloon/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddHoursScreenController extends GetxController{

  ApiServices services=ApiServices();
  RxString amountEarnedToday="0".obs;
  RxString amountEarnedMonth="0".obs;
  RxString name="".obs;


  Future<void> loadService() async {
    try {
      final response = await services.fetchWorkSummary();
      print(response);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        amountEarnedToday.value = (data['amountEarnedToday'] ?? '0').toString();
        amountEarnedMonth.value = (data['amountEarnedMonth'] ?? '0').toString();
      }

    } catch (e) {
      print('Error loading service: $e');
    }
  }

  Future<void> loadName()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    name.value=prefs.getString("name")!;
    print(prefs.getString("name"));
  }



}