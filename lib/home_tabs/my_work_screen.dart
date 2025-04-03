import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_saloon/controllers/my_work_screen_controller.dart';
import 'package:hair_saloon/halper/app_colors.dart';
import 'package:hair_saloon/models/monthly_report_model.dart';
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
        padding: REdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            myServices(context),
            SizedBox(height: 20.h),
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
                  topRight: Radius.circular(5), topLeft: Radius.circular(5)),
              color: AppColors.orangeComYello,
            ),
            padding: REdgeInsets.symmetric(vertical: 5.h),
            child: Center(
              child: Text(
                'My Service',
                style: GoogleFonts.inter(
                  color: Colors.black87,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                 // decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: REdgeInsets.only(left: 10.w, bottom: 10.h, right: 10.w,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.lightBlue[100],
                    child: Padding(
                      padding:
                      REdgeInsets.only(left: 8.w, top: 8.h, bottom: 8.h,right: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TODAY',
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.h),
                              Obx(() => Text(
                                '${controller.amountEarnedToday.value} AED',
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )),
                            ],
                          ),
                          Icon(Icons.calendar_view_day,color: AppColors.appOrange,size: 30,),

                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.yellow[50],
                    child: Padding(
                      padding:
                      REdgeInsets.only(left: 8.w, top: 8.h, bottom: 8.h,right: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'THIS MONTH',
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.h),
                              Obx(() => Text(
                                '${controller.amountEarnedMonth.value} AED',
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )),
                            ],
                          ),
                          Icon(Icons.calendar_view_month,color: AppColors.appOrange,size: 30,),

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
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5), topLeft: Radius.circular(5)),
              color: AppColors.appOrange,
            ),
            padding: REdgeInsets.symmetric(vertical: 0.h),
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
                  icon: const Icon(Icons.arrow_left, color: Colors.white,size: 40,),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Obx(() => Text(
                    'Report - ${DateFormat('MMMM yyyy').format(controller.selectedDate.value)}',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
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
                  icon: Icon(Icons.arrow_right, color: Colors.white,size: 40),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              final filteredReports = controller.getFilteredReports();
              if (filteredReports.isEmpty) {
                return Center(
                  child: Text(
                    'No data found for ${DateFormat('MMMM yyyy').format(controller.selectedDate.value)}',
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),
                );
              }
              return Obx(() {
                if(controller.allReports.isEmpty){
                  return Center(child: loading());
                }else{
                  return ListView.builder(
                    itemCount: filteredReports.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      filteredReports.sort((a, b) => b.date.compareTo(a.date),);
                      MonthlyReportModel model = filteredReports[index];
                      double total=0;
                      for(var e in model.data){
                        total+=e.serviceFee;
                      }

                      return SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Padding(
                          padding: REdgeInsets.symmetric(horizontal: 15),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: REdgeInsets.only(
                                  left: 15.w,
                                  top: 15.h,
                                  bottom: 15.h,
                                  right: 15.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      controller.formatDate(model.date),
                                      style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Service Name",style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.bold),),
                                      Text("Amount",style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  const Divider(color: Colors.black,),
                                  SizedBox(height: 10.h),
                                  ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: model.data.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      model.data.sort((a, b) => b.createdDate.compareTo(a.createdDate),);
                                      return Container(
                                        color: index % 2 == 0 ? const Color(0xffE0E0E0) : Colors.white,
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              model.data[index].serviceName,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text(
                                              "${model.data[index].serviceFee} AED",
                                              style: GoogleFonts.poppins(color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10.h,),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "Total : $total AED",
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },);
            }),
          ),
        ],
      ),
    );
  }

}