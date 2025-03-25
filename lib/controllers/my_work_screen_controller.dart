import 'package:get/get.dart';
import 'package:hair_saloon/models/monthly_report_model.dart';
import 'package:hair_saloon/services/api_services.dart';
import 'package:intl/intl.dart';

class MyWorkScreenController extends GetxController {
  RxString amountEarnedToday = "0".obs;
  RxString amountEarnedMonth = "0".obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxBool isLoading = false.obs;
  ApiServices services = ApiServices();
  final RxList<MonthlyReportModel> allReports = <MonthlyReportModel>[].obs;

  final DateFormat dateFormatter = DateFormat('d-MMM-yyyy');
  final DateFormat apiDateFormatter = DateFormat('MM-dd-yyyy'); // For API: MM-dd-yyyy

  @override
  void onInit() {
    super.onInit();
    loadService();
    loadLogHours();
  }

  Future<void> loadService() async {
    try {
      final response = await services.fetchWorkSummary();
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        amountEarnedToday.value = (data['amountEarnedToday'] ?? '0').toString();
        amountEarnedMonth.value = (data['amountEarnedMonth'] ?? '0').toString();
      }
    } catch (e) {
      print('Error loading service: $e');
      DateTime today = DateTime.now();
      double todayTotal = 0;
      double monthTotal = 0;

      for (var report in allReports) {
        DateTime reportDate = DateTime.parse(report.date);
        if (reportDate.day == today.day &&
            reportDate.month == today.month &&
            reportDate.year == today.year) {
          todayTotal += report.data.fold(0, (sum, item) => sum + item.serviceFee);
        }
        if (reportDate.month == today.month &&
            reportDate.year == today.year) {
          monthTotal += report.data.fold(0, (sum, item) => sum + item.serviceFee);
        }
      }

      amountEarnedToday.value = todayTotal.toStringAsFixed(2);
      amountEarnedMonth.value = monthTotal.toStringAsFixed(2);
    }
  }

  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
    loadLogHours(); // Reload data when date changes
  }

  List<MonthlyReportModel> getFilteredReports() {
    return allReports.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> loadLogHours() async {
    try {
      isLoading.value = true;
      allReports.clear();

      // Calculate the first and last day of the selected month
      DateTime firstDayOfMonth = DateTime(selectedDate.value.year, selectedDate.value.month, 1);
      DateTime lastDayOfMonth = DateTime(selectedDate.value.year, selectedDate.value.month + 1, 0);

      // Format dates for the API
      String fromDate = apiDateFormatter.format(firstDayOfMonth);
      String toDate = apiDateFormatter.format(lastDayOfMonth);

      // Fetch reports from the API with the date range
      final reports = await services.getMonthReport1(fromDate: fromDate, toDate: toDate);
      allReports.addAll(reports);
    } catch (e) {
      print('Error loading log hours: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String formatDate(String dateStr) {
    try {
      DateTime date = DateTime.parse(dateStr);
      return dateFormatter.format(date);
    } catch (e) {
      return dateStr;
    }
  }
}