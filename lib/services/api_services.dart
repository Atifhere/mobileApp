import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hair_saloon/halper/api_urls.dart';
import 'package:hair_saloon/halper/methods.dart';
import 'package:hair_saloon/models/category_model.dart';
import 'package:hair_saloon/models/monthly_report_model.dart';
import 'package:hair_saloon/models/selected_item_model.dart';

class ApiServices {


  final Dio dio=Dio();
  ApiUrls urls=ApiUrls();

  Future<Response> login(String email,String password) async {
    try {
      Map<String, dynamic> requestData = {
          'username': email,
          'password': password
        };
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      Response response = await dio.post(
        urls.loginURL,
        data: requestData,
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: e.requestOptions,
          statusCode: 500,
          data: {'error': e.message},
        );
      }
    }
  }



  Future<Response> fetchWorkSummary() async {


    String authToken = await myToken();

    try {
      final response = await dio.get(
        urls.workSummery,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );
      print('work summary code: ${response.statusCode}');
      if (response.statusCode == 200) {
        return response;
      } else {
        print('Failed to load work summary: ${response.statusCode}');
        return response;

      }
    } catch (e) {
      print('Error fetching work summary: $e');
      rethrow;
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    final Dio dio = Dio(); // Your Dio instance

    try {
      String authToken = await myToken();

      final response = await dio.get(
        urls.categoryUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<List<MonthlyReportModel>> getMonthReport() async {
    try {
      String authToken = await myToken();
      final response = await dio.get(
        urls.monthlyReport,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        )
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((json) => MonthlyReportModel.fromJson(json as Map<String,dynamic>)).toList();
      } else {
        throw Exception('Failed to load month report: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching month report: $e');
    }
  }


  Future<List<MonthlyReportModel>> getMonthReport1({required String fromDate, required String toDate,}) async {
    String authToken = await myToken();
    try {
      final response = await dio.get('https://salonmanger.com/Staff/MonthReport?fromDate=$fromDate&toDate=$toDate',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
        queryParameters: {
          'fromDate': fromDate,
          'toDate': toDate,
        },
      );
      print("Manan");
      print(response.data);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => MonthlyReportModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load month report: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      throw Exception('Failed to load month report: ${e.response?.statusCode ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

//
  //
  // Future<Response> myService() async {
  //   const url = 'https://salonmanger.com/User/UpdatePassword/Staff';
  //
  //   try {
  //     final response = await dio.get(
  //       url,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('Password update data retrieved: ${response.data}');
  //       return response;
  //     } else {
  //       print('Failed to get password update data: ${response.statusCode}');
  //       print('Error details: ${response.data}');
  //       return response;
  //     }
  //   } catch (e) {
  //     print('Error fetching password update data: $e');
  //     rethrow;  // Allows the caller to handle the error
  //   }
  // }
  //
  //
  Future<Response> logWork(String cataID,List<SelectedItemModel> list) async {
    try {
      String token=await myToken();

      Map<String, dynamic> requestData = {
        "businessCategoryId": cataID,
        "workItem":list.map((item) => item.toJson()).toList(),
      };

      dio.options.headers = {
        'Content-Type': 'application/json',
        'accept': '/',
        'Authorization': 'bearer $token',
      };
      Response response = await dio.post(
        "https://salonmanger.com/Staff/LogWork",
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      print(e.response);
      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: e.requestOptions,
          statusCode: 500,
          data: {'error': e.message},
        );
      }
    }
  }

  Future<Response> updatePassword(String email,String password) async {
    try {
      Map<String, dynamic> requestData = {
        'username': email,
        'password': password
      };
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      Response response = await dio.post(
        urls.updatePassword,
        data: requestData,
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: e.requestOptions,
          statusCode: 500,
          data: {'error': e.message},
        );
      }
    }
  }




}