import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_saloon/controllers/pet_saloon_page_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../halper/app_colors.dart';
import '../halper/methods.dart';

class PetSaloonPage extends StatefulWidget {
  const PetSaloonPage({super.key});

  @override
  State<PetSaloonPage> createState() => _PetSaloonPageState();
}

class _PetSaloonPageState extends State<PetSaloonPage> {
  final PetSaloonPageController controller = Get.put(PetSaloonPageController());

  @override
  void initState() {
    super.initState();
    controller.loadData();
    controller.selectedServices.clear();

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
              } else if (controller.allData[2].value!.subCategories.isEmpty) {
                return Center(child:  Text("No Data Available",style: GoogleFonts.poppins(color: Colors.black),));
              } else {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  itemCount: controller.allData[2].value!.subCategories.length,
                  itemBuilder: (context, index) {
                    final data = controller.allData[2].value!.subCategories[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text (Name)
                            Expanded(
                              child: Text(
                                data.name,
                                style: GoogleFonts.inter(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),

                            // Amount Input
                            SizedBox(
                              width: 100.w, // Reduced width for a compact look
                              child: Obx(() => TextField(
                                controller: controller.allControllers[index].value ?? TextEditingController(),
                                enabled: controller.allData[2].value!.subCategories[index].enabled,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'Enter Amount',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[600],
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: AppColors.appOrange, width: 1.2),
                                  ),
                                ),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
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
                            // Text(
                            //   " AED",
                            //   style: GoogleFonts.inter(
                            //     color: Colors.black87,
                            //     fontWeight: FontWeight.w500,
                            //     fontSize: 8.sp,
                            //   ),
                            // ),
                            // Switch at the end
                            Transform.scale(
                              scale: 0.7, // Reduced size for a more compact look
                              child: Obx(() => Switch(
                                value: controller.allData[2].value!.subCategories[index].enabled,
                                onChanged: (value) {
                                  controller.allData[2].value!.subCategories[index].enabled = value;
                                  controller.toggleService(index, value);
                                  setState(() {});
                                },
                                activeColor: Colors.white,
                                activeTrackColor: AppColors.appOrange,
                                inactiveThumbColor: Colors.grey[300],
                                inactiveTrackColor: Colors.grey[400],
                              )),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),


          Container(
            color: AppColors.appOrange,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Grand Total Text
                Obx(
                      () => Text(
                    'Grand Total: ${controller.grandTotal.value.toStringAsFixed(2)} AED',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                ),

                // Save Button or Loading Animation
                Obx(() {
                  if (controller.saveLoading.value) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 30,
                      ),
                    );
                  } else {
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appBrown,
                        minimumSize: const Size(80, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        print('Selected Services: ${controller.selectedServices.map((e) => "${e.subCategoryId}: ${e.serviceFee}").toList()}');
                        controller.saveData();
                      },
                      icon: const Icon(Icons.save, size: 18, color: Colors.white),
                      label: Text(
                        'Save',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),



        ],
      ),
    );
  }
}