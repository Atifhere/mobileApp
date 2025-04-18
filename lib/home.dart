import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hair_saloon/halper/app_colors.dart';
import 'package:hair_saloon/home_tabs/add_hours_screen.dart';
import 'package:hair_saloon/home_tabs/my_work_screen.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;  // Reactive variable to manage the selected index

  final List<Widget> screens = [
    AddHoursScreen(),
    MyWorkScreen(),
  ];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();

    return Scaffold(
      backgroundColor:AppColors.appBrown,
      body: SafeArea(
        child: Obx(
              () => homeController.screens[homeController.selectedIndex.value],
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: homeController.selectedIndex.value,  // Bind the selectedIndex
        onTap: homeController.onItemTapped,
        backgroundColor: AppColors.appOrange,
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColors.appBrown,
        items:  [
          BottomNavigationBarItem(
            //icon: ImageIcon(const AssetImage("images/log_Work_Icon.png"),size: 30.sp,),
            //icon: ImageIcon(const AssetImage("images/today.png"),size: 30.sp,),
            icon: Icon(Icons.timeline,size: 30.sp,),

            label: 'Log Hours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_history_rounded,size: 30.sp,),
            label: 'My Work',
          ),
          // Add more items if needed
        ],
      ),
      ),
    );
  }
}
