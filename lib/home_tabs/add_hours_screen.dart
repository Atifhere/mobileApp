import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_saloon/auth/login_screen.dart';
import 'package:hair_saloon/controllers/add_hours_screen_controller.dart';
import 'package:hair_saloon/halper/app_colors.dart';
import 'package:hair_saloon/halper/methods.dart';
import 'package:hair_saloon/log_hours_views/men_saloon_page.dart';
import 'package:hair_saloon/log_hours_views/pet_saloon_page.dart';
import 'package:hair_saloon/log_hours_views/women_saloon_page.dart';
import 'package:hair_saloon/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddHoursScreen extends StatefulWidget {
  const AddHoursScreen({super.key});

  @override
  State<AddHoursScreen> createState() => _AddHoursScreenState();
}

class _AddHoursScreenState extends State<AddHoursScreen> {
  AddHoursScreenController controller = Get.put(AddHoursScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.loadService();
    controller.loadName();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.appBrown,
        body: Padding(
          padding: REdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          "Welcome ${controller.name.value}",
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove("token");
                                prefs.remove("name");
                                Get.offAll(() => const LoginScreen());
                              },
                              child: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              )),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "Logout",
                            style: GoogleFonts.poppins(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              myServices(context),
              SizedBox(
                height: 20.h,
              ),
              Expanded(child: myLogHours(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget myServices(BuildContext context) {
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
              color: AppColors.appOrange, // Dark orange background for better contrast
            ),
            padding: REdgeInsets.symmetric(vertical: 5.h),
            child: Center(
              child: Text(
                'My Details',
                style: GoogleFonts.inter(
                  color: Colors.white, // Light text for readability
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline, // Optional for a stylish look
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 7.h,
          ),


          Padding(
            // padding: const EdgeInsets.all(7.0),
            padding: REdgeInsets.only(left: 7.w, top: 2.h, bottom: 2.h, right: 7.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Key section (40%)
                Flexible(
                  flex: 4, // 40% of the row width
                  child: Container(
                    width: double.infinity,
                    color: AppColors.appOrange.withOpacity(0.2), // Color for the key background
                    padding: const EdgeInsets.all(8),

                    child: Text(
                      'Company Name:',
                      style: GoogleFonts.inter(
                        color: AppColors.appOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                //SizedBox(width: 4.w),
                // Value section (60%)
                Flexible(
                  flex: 6, // 60% of the row width
                  child: Container(
                    width: double.infinity,
                    color: Colors.blue.withOpacity(0.2), // Color for the value background
                    padding: const EdgeInsets.all(8),
                   // padding: REdgeInsets.only(left: 2.w, top: 8.h, bottom: 8.h, right: 8.w),

                    child: Obx(
                          () => Text(
                        '${controller.companyName}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),




          Padding(
            // padding: const EdgeInsets.all(7.0),
            padding: REdgeInsets.only(
                left: 7.w, top: 2.h, bottom: 2.h, right: 7.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Key section (40%)
                Flexible(
                  flex: 4, // 40% of the row width
                  child: Container(
                    width: double.infinity,
                    color: AppColors.appOrange.withOpacity(0.2), // Color for the key background
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'This Month Earning:',
                      style: GoogleFonts.inter(
                        color: AppColors.appOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                //SizedBox(width: 4.w),
                // Value section (60%)
                Flexible(
                  flex: 6, // 60% of the row width
                  child: Container(
                    width: double.infinity,
                    color: Colors.blue.withOpacity(0.2), // Color for the value background
                    padding: const EdgeInsets.all(8),
                    child: Obx(
                          () => Text(
                        '${controller.myShareThisMonth} AED',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
           // padding: const EdgeInsets.all(7.0),
            padding: REdgeInsets.only(
                left: 7.w, top: 2.h, bottom: 2.h, right: 7.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Key section (40%)
                Flexible(
                  flex: 4, // 40% of the row width
                  child: Container(
                    width: double.infinity,
                    color: AppColors.appOrange.withOpacity(0.2), // Color for the key background
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'My Share:',
                      style: GoogleFonts.inter(
                        color: AppColors.appOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                //SizedBox(width: 4.w),
                // Value section (60%)
                Flexible(
                  flex: 6, // 60% of the row width
                  child: Container(
                    width: double.infinity,
                    color: Colors.blue.withOpacity(0.2), // Color for the value background
                    padding: const EdgeInsets.all(8),
                    child: Obx(
                          () => Text(
                        '${controller.myPercentageValue}%',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),





          Padding(
            // padding: const EdgeInsets.all(7.0),
            padding: REdgeInsets.only(
                left: 7.w, top: 2.h, bottom: 7.h, right: 7.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Key section (40%)
                Flexible(
                  flex: 4, // 40% of the row width
                  child: Container(
                    width: double.infinity,
                    color: AppColors.appOrange.withOpacity(0.2), // Color for the key background
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Monthly Target:',
                      style: GoogleFonts.inter(
                        color: AppColors.appOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
               // SizedBox(width: 4.w),
                // Value section (60%)
                Flexible(
                  flex: 6, // 60% of the row width
                  child: Container(
                    width: double.infinity,
                    color: Colors.blue.withOpacity(0.2), // Color for the value background
                    padding: const EdgeInsets.all(8),
                    child: Obx(
                          () => Text(
                        '${controller.monthlyTarget} AED',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
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
            padding: REdgeInsets.symmetric(vertical: 5.h),
            child: Center(
                child: Text(
              'Log Hours',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            )),
          ),
          SizedBox(
            height: 20.h,
          ),
          TabBar(
            tabs: const [
              Padding(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                child: Text('Men Salon'),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                child: Text('Women Salon'),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                child: Text('Pet Salon'),
              ),
            ],
            padding: REdgeInsets.only(bottom: 10),
            labelColor: Colors.white,
            labelStyle:
                GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
            unselectedLabelColor: AppColors.appOrange,
            unselectedLabelStyle:
                GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: AppColors.appOrange,
            indicator: BoxDecoration(
              color: AppColors.appOrange,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const Expanded(
            child: TabBarView(children: [
              MenSaloonPage(),
              WomenSaloonPage(),
              PetSaloonPage()
            ]),
          ),
        ],
      ),
    );
  }
}
