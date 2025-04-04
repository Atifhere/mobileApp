import 'dart:convert';

import 'package:get/get.dart';
import 'package:hair_saloon/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddHoursScreenController extends GetxController{

  ApiServices services=ApiServices();
  RxString amountEarnedToday="0".obs;
  RxString amountEarnedMonth="0".obs;

  RxString myShareThisMonth="".obs;
  RxString myPercentageValue="".obs;
  RxString monthlyTarget="".obs;
  RxString companyName="".obs;
  RxString name="".obs;

  // "myShareThisMonth": 20,
  // "myPercentageValue": 50,
  // "monthlyTarget": 4000,
  // "companyName": "Abu Dhabi Salon"


  Future<void> loadService() async {
    try {
      final response = await services.fetchWorkSummary();
      print(response);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        amountEarnedToday.value = (data['amountEarnedToday'] ?? '0').toString();
        amountEarnedMonth.value = (data['amountEarnedMonth'] ?? '0').toString();

        myShareThisMonth.value = (data['myShareThisMonth'] ?? '').toString();

        myPercentageValue.value = (data['myPercentageValue'] ?? '').toString();
        monthlyTarget.value = (data['monthlyTarget'] ?? '').toString();

        companyName.value = (data['companyName'] ?? '').toString();
        if(companyName.value.length > 25){
          companyName.value = "${companyName.value.substring(0,24)}...";
        }
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