import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../halper/methods.dart';
import '../home.dart';
import '../models/category_model.dart';
import '../models/selected_item_model.dart';
import '../services/api_services.dart';
import 'add_hours_screen_controller.dart';

class WomenSaloonPageController  extends GetxController{

  RxList<Rxn<CategoryModel>> allData = RxList();
  final ApiServices services = ApiServices();
  RxBool isLoading = false.obs;
  RxBool saveLoading = false.obs;

  RxList<Rxn<TextEditingController>> allControllers = RxList();
  RxList<SelectedItemModel> selectedServices = RxList<SelectedItemModel>();
  RxInt grandTotal = 0.obs;

  AddHoursScreenController controller=Get.find();
  HomeController homeController=Get.find();




  void loadData() async {
    isLoading(true);
    allData.value = (await services.getCategories()).map((category) => Rxn<CategoryModel>(category)).toList();
    allData[1].value!.subCategories.sort((a, b) => a.sequence.compareTo(b.sequence));

    if (allData.isNotEmpty && allData[1].value != null) {
      int subCategoryLength = allData[1].value!.subCategories.length;
      allControllers.value = List.generate(
        subCategoryLength,
            (index) => Rxn<TextEditingController>(TextEditingController()),
      );
    }

    isLoading(false);
  }

  // Toggle item in selectedServices
  void toggleService(int index, bool isActive) {
    final subCategory = allData[1].value!.subCategories[index];
    if (isActive) {
      // Add to selectedServices if not already present
      if (!selectedServices.any((item) => item.subCategoryId == subCategory.id)) {
        selectedServices.add(SelectedItemModel(
          subCategoryId: subCategory.id,
          serviceFee: 0,
        ));
      }
    } else {
      // Remove from selectedServices
      selectedServices.removeWhere((item) => item.subCategoryId == subCategory.id);
      allControllers[index].value!.clear();
    }
    updateGrandTotal();
  }

  // Update price in selectedServices when TextField changes
  void updatePrice(int index, String value) {
    final subCategory = allData[1].value!.subCategories[index];
    final price = double.tryParse(value) ?? 0.0;
    final selectedItem = selectedServices.firstWhereOrNull((item) => item.subCategoryId == subCategory.id);
    if (selectedItem != null) {
      selectedItem.serviceFee= price.toInt();
      updateGrandTotal();
    }
  }

  // Calculate and update grandTotal
  void updateGrandTotal() {
    grandTotal.value = selectedServices.fold(0, (sum, item) => sum + item.serviceFee);
  }

  Future<void> saveData()async{
    if(grandTotal.value==0){
      showError("Please Enter Some Amount.");
      return;
    }
    // Check each selected service's input value
    for (var selectedItem in selectedServices) {
      final index = allData[1].value!.subCategories
          .indexWhere((sub) => sub.id == selectedItem.subCategoryId);
      if (index != -1) {
        final controller = allControllers[index].value!;
        final value = double.tryParse(controller.text) ?? 0.0;

        if (value <= 5) {
          showError("Each service amount must be greater than 5 AED");
          return;
        }
        if (value > 1000) {
          showError("Each service amount must be less than or equal to 1000 AED");
          return;
        }
      }
    }

    saveLoading(true);
    await services.logWork(allData[1].value!.id, selectedServices).then((value) {
      final Map<String,dynamic> response=value.data as Map<String,dynamic>;
      if(value.statusCode==200){
        showSuccess(response['message']);
        homeController.onItemTapped(1);
        print(value.statusCode);
        print(value.data);
      }else{
        showError(response['errorMessage']);

      }
    },);
    controller.amountEarnedMonth.value=(int.parse(controller.amountEarnedMonth.value)+grandTotal.value).toString();
    controller.amountEarnedToday.value=(int.parse(controller.amountEarnedToday.value)+grandTotal.value).toString();

    grandTotal.value=0;
    int subCategoryLength = allData[1].value!.subCategories.length;
    allControllers.value = List.generate(
      subCategoryLength,
          (index) => Rxn<TextEditingController>(TextEditingController()),
    );
    saveLoading(false);
  }


  @override
  void onClose() {
    for (var controller in allControllers) {
      controller.value?.dispose();
    }
    super.onClose();
  }

}