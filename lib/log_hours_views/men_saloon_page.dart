import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_saloon/controllers/men_saloon_page_controller.dart';
import 'package:hair_saloon/halper/methods.dart';
import 'package:hair_saloon/models/selected_item_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../halper/app_colors.dart';
import '../services/api_services.dart';

class MenSaloonPage extends StatefulWidget {
  const MenSaloonPage({super.key});

  @override
  _MenSaloonPageState createState() => _MenSaloonPageState();
}

class _MenSaloonPageState extends State<MenSaloonPage> {
  final MenSaloonPageController controller = Get.put(MenSaloonPageController());

  @override
  void initState() {
    super.initState();
    controller.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: loading());
              } else if (controller.allData[0].value!.subCategories.isEmpty) {
                return Center(child:  Text("No Data Available",style: GoogleFonts.poppins(color: Colors.black),));
              } else {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  itemCount: controller.allData[0].value!.subCategories.length,
                  itemBuilder: (context, index) {
                    final data = controller.allData[0].value!.subCategories[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.6,
                                child: Obx(() => Switch(
                                  value: controller.allData[0].value!.subCategories[index].enabled,
                                  onChanged: (value) {
                                    controller.allData[0].value!.subCategories[index].enabled = value;
                                    controller.toggleService(index, value);
                                    setState(() {

                                    });
                                  },
                                  activeColor: Colors.white,
                                  activeTrackColor: AppColors.appOrange,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor: Colors.grey[400],
                                )),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                data.name,
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 130.w,
                            child: Obx(() => TextField(
                              controller: controller.allControllers[index].value ?? TextEditingController(),
                              enabled: controller.allData[0].value!.subCategories[index].enabled,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: 'Enter Amount',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,

                                ),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                controller.updatePrice(index, value);
                              },
                            )),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }),
          ),


          Container(
            color: AppColors.appOrange,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                        () => Text(
                      'Grand Total: ${controller.grandTotal.value.toStringAsFixed(2)} AED',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Obx(() {
                    if(controller.saveLoading.value){
                      return Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size:30
                          )
                      );
                    }else{
                      return ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(AppColors.appBrown),
                            minimumSize: const WidgetStatePropertyAll(Size(80,35))
                        ),
                        onPressed: () {
                          print('Selected Services: ${controller.selectedServices.map((e) => "${e.subCategoryId}: ${e.serviceFee}").toList()}');
                          controller.saveData();
                        },
                        child: Text(
                          'Save',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      );
                    }
                  },),
                ],
              ),
            ),
          ),



        ],
      ),
    );
  }
}