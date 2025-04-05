import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_saloon/controllers/my_work_screen_controller.dart';
import 'package:hair_saloon/halper/app_colors.dart';
import 'package:hair_saloon/models/monthly_report_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_screen.dart';
import '../halper/methods.dart';
import 'package:intl/intl.dart';

class MyWorkScreen extends StatefulWidget {
  const MyWorkScreen({super.key});

  @override
  State<MyWorkScreen> createState() => _MyWorkScreenState();
}

class _MyWorkScreenState extends State<MyWorkScreen> {
  MyWorkScreenController controller = Get.put(MyWorkScreenController());

  @override
  void initState() {
    super.initState();
    controller.selectedDate.value = DateTime.now();
    controller.loadService();
    controller.loadLogHours();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.appOrange,
            colorScheme: ColorScheme.light(primary: AppColors.appOrange),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != controller.selectedDate.value) {
      controller.updateSelectedDate(DateTime(picked.year, picked.month));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBrown,
      body: Padding(
        padding: REdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              //padding: const EdgeInsets.all(8.0),
              padding: REdgeInsets.only(left: 3, right: 3),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My Work List",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove("token");
                          prefs.remove("name");
                          Get.offAll(() => const LoginScreen());
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Logout",
                              style: GoogleFonts.poppins(color: Colors.white),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
            SizedBox(height: 7.h),
            myServices(context),
            SizedBox(height: 10.h),
            Expanded(child: myLogHours(context)),
          ],
        ),
      ),
    );
  }

  Widget myServices(BuildContext context) {
    // ... (keep this widget same as before)
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black87),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
              color: AppColors
                  .appOrange, // Dark orange background for better contrast
            ),
            padding: REdgeInsets.symmetric(vertical: 5.h),
            child: Center(
              child: Text(
                'work summary'.toUpperCase(),
                style: GoogleFonts.inter(
                  color: Colors.white,
                  // Light text for readability
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  //decoration: TextDecoration.underline, // Optional for a stylish look
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: REdgeInsets.only(left: 10.w, bottom: 10.h, right: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: REdgeInsets.all(12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TODAY',
                                style: GoogleFonts.inter(
                                  color: AppColors.appOrange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Obx(() => Text(
                                    '${controller.amountEarnedToday.value} AED',
                                    style: GoogleFonts.inter(
                                      color: Colors.black87,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.appOrange.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              color: AppColors.appOrange,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: REdgeInsets.all(12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'THIS MONTH',
                                style: GoogleFonts.inter(
                                  color: AppColors.appOrange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Obx(() => Text(
                                    '${controller.amountEarnedMonth.value} AED',
                                    style: GoogleFonts.inter(
                                      color: Colors.black87,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.appOrange.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.calendar_month,
                              color: AppColors.appOrange,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget myLogHours(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black87),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 50.h,
            // Reduced height for a more compact design
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
              color: AppColors.appOrange,
            ),
            padding: REdgeInsets.symmetric(vertical: 4.h),
            // Reduced vertical padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    controller.updateSelectedDate(
                      DateTime(
                        controller.selectedDate.value.year,
                        controller.selectedDate.value.month - 1,
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_left,
                      color: Colors.white, size: 30), // Slightly smaller icon
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Obx(() => Text(
                        'Report - ${DateFormat('MMMM yyyy').format(controller.selectedDate.value)}'
                            .toUpperCase(),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16, // Slightly reduced font size
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
                IconButton(
                  onPressed: () {
                    controller.updateSelectedDate(
                      DateTime(
                        controller.selectedDate.value.year,
                        controller.selectedDate.value.month + 1,
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_right,
                      color: Colors.white, size: 30), // Slightly smaller icon
                ),
              ],
            ),
          ),
          //const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              final filteredReports = controller.getFilteredReports();

              //if (filteredReports.isEmpty) {
              if (controller.isLoading.value ==false && filteredReports.isEmpty) {
                return Center(
                  child: Text(
                    'No data found for ${DateFormat('MMMM yyyy').format(controller.selectedDate.value)}',
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),
                );
              }
              return Obx(
                () {
                  if (controller.allReports.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // Ensures the column takes minimal vertical space
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Centers vertically within the column
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Centers horizontally within the column
                        children: [
                          loading(),
                          SizedBox(height: 10),
                          // Space between loading indicator and text
                          Text(
                            "Please Wait...",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: filteredReports.length,
                      shrinkWrap: true,
                      padding: REdgeInsets.symmetric(vertical: 5.h),
                      itemBuilder: (context, index) {
                        filteredReports
                            .sort((a, b) => b.date.compareTo(a.date));
                        MonthlyReportModel model = filteredReports[index];
                        double total =
                            model.data.fold(0, (sum, e) => sum + e.serviceFee);

                        return Padding(
                          padding: REdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: REdgeInsets.all(12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      controller.formatDate(model.date),
                                      style: GoogleFonts.inter(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        //decoration: TextDecoration.underline,
                                        decorationThickness: 1.5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Service Name",
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.w600)),
                                      Text("Amount",
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const Divider(color: Colors.grey),
                                  SizedBox(height: 8.h),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: model.data.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      model.data.sort((a, b) => b.createdDate
                                          .compareTo(a.createdDate));
                                      return Container(
                                        color: index % 2 == 0
                                            ? const Color(0xffF7F7F7)
                                            : Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                 // model.data[index].serviceName,
                                                "${index+1}. ${model.data[index].serviceName}",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.w500),
                                                ),


                                                Spacer(),
                                                Text(
                                                  "${model.data[index].serviceFee} AED  ",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black87),
                                                ),

                                                GestureDetector(
                                                    onTap: () async {
                                                      showDeleteConfirmationDialog(
                                                          context, () {
                                                        controller.deleteItem(
                                                            model.data[index].id +
                                                                '');
                                                      });
                                                    },
                                                    child: Icon(Icons.delete,
                                                        color: AppColors.appOrange,
                                                        size: 20)),

                                                // GestureDetector(
                                                //   onTap: () async {
                                                //     final SharedPreferences prefs =
                                                //     await SharedPreferences.getInstance();
                                                //     prefs.remove("token");
                                                //     prefs.remove("name");
                                                //     Get.offAll(() => const LoginScreen());
                                                //   },
                                              ],
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 12.0),
                                                child: Text(
                                                  "${model.data[index].category} - ${model.data[index].serviceTime}",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black87,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w400),

                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 8.h),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Total: $total AED",
                                      style: GoogleFonts.inter(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    ;
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Confirmation",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this item?",
            style: GoogleFonts.inter(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: GoogleFonts.inter(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appOrange,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Perform delete
              },
              child: Text(
                "Delete",
                style: GoogleFonts.inter(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
