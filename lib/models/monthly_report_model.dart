// MonthReportResponse.dart
class MonthlyReportModel {
  final String date;
  final List<ServiceData> data;

  MonthlyReportModel({
    required this.date,
    required this.data,
  });

  factory MonthlyReportModel.fromJson(Map<String, dynamic> json) {
    return MonthlyReportModel(
      date: json['date'] as String,
      data: (json['data'] as List)
          .map((item) => ServiceData.fromJson(item))
          .toList(),
    );
  }
}

// ServiceData.dart
class ServiceData {
  final String id;
  final String serviceName;
  final double serviceFee;
  final String createdDate;
  final String serviceTime;
  final String category;

  ServiceData({
    required this.id,
    required this.serviceName,
    required this.serviceFee,
    required this.createdDate,
    required this.serviceTime,
    required this.category,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'] as String,
      serviceName: json['serviceName'] as String,
      serviceFee: (json['serviceFee'] as num).toDouble(),
      createdDate: json['createdDate'] as String,
      serviceTime: json['serviceTime'] as String,
      category: json['category'] as String,
    );
  }
}