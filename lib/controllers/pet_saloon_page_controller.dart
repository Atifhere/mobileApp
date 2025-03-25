import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../halper/methods.dart';
import '../home.dart';
import '../models/category_model.dart';
import '../models/selected_item_model.dart';
import '../services/api_services.dart';
import 'add_hours_screen_controller.dart';

class PetSaloonPageController extends GetxController {
  RxList<Rxn<CategoryModel>> allData = RxList();
  final ApiServices services = ApiServices();
  RxBool isLoading = false.obs;
  RxBool saveLoading = false.obs;

  RxList<Rxn<TextEditingController>> allControllers = RxList();
  RxList<SelectedItemModel> selectedServices = RxList<SelectedItemModel>();
  RxInt grandTotal = 0.obs;

  AddHoursScreenController controller = Get.find();
  HomeController homeController = Get.find();

  void loadData() async {
    isLoading(true);
    try {
      allData.value = (await services.getCategories()).map((category) => Rxn<CategoryModel>(category)).toList();
      if (allData.length > 2 && allData[2].value != null && allData[2].value!.subCategories.isNotEmpty) {
        allData[2].value!.subCategories.sort((a, b) => a.sequence.compareTo(b.sequence));
        int subCategoryLength = allData[2].value!.subCategories.length;
        allControllers.value = List.generate(
          subCategoryLength,
              (index) => Rxn<TextEditingController>(TextEditingController()),
        );

        // Pre-populate controllers with existing service fees, if any
        for (int i = 0; i < subCategoryLength; i++) {
          final subCategory = allData[2].value!.subCategories[i];
          final selectedItem = selectedServices.firstWhereOrNull((item) => item.subCategoryId == subCategory.id);
          if (selectedItem != null && selectedItem.serviceFee > 0) {
            allControllers[i].value!.text = selectedItem.serviceFee.toString();
          }
        }
      }
    } catch (e) {
      showError("Failed to load data: $e");
    } finally {
      isLoading(false);
    }
  }

  void toggleService(int index, bool isActive) {
    final subCategory = allData[2].value!.subCategories[index];
    if (isActive) {
      if (!selectedServices.any((item) => item.subCategoryId == subCategory.id)) {
        selectedServices.add(SelectedItemModel(
          subCategoryId: subCategory.id,
          serviceFee: 0,
        ));
      }
    } else {
      selectedServices.removeWhere((item) => item.subCategoryId == subCategory.id);
      allControllers[index].value!.clear();
    }
    updateGrandTotal();
  }

  void updatePrice(int index, String value) {
    final subCategory = allData[2].value!.subCategories[index];
    final price = double.tryParse(value) ?? 0.0;
    final selectedItem = selectedServices.firstWhereOrNull((item) => item.subCategoryId == subCategory.id);
    if (selectedItem != null) {
      selectedItem.serviceFee = price.toInt();
      updateGrandTotal();
    } else if (price > 0) {
      showError("Enable the service before setting a price.");
    }
  }

  void updateGrandTotal() {
    grandTotal.value = selectedServices.fold(0, (sum, item) => sum + item.serviceFee);
  }

  Future<void> saveData() async {
    if (grandTotal.value == 0) {
      showError("Please enter some amount.");
      return;
    }

    for (var selectedItem in selectedServices) {
      final index = allData[2].value!.subCategories.indexWhere((sub) => sub.id == selectedItem.subCategoryId);
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
    try {
      final response = await services.logWork(allData[2].value!.id, selectedServices);
      final Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
      if (response.statusCode == 200) {
        showSuccess(responseData['message']);
        homeController.onItemTapped(1);
        controller.amountEarnedMonth.value =
            (int.parse(controller.amountEarnedMonth.value) + grandTotal.value).toString();
        controller.amountEarnedToday.value =
            (int.parse(controller.amountEarnedToday.value) + grandTotal.value).toString();

        // Reset state after saving
        grandTotal.value = 0;
        selectedServices.clear();
        int subCategoryLength = allData[2].value!.subCategories.length;
        allControllers.value = List.generate(
          subCategoryLength,
              (index) => Rxn<TextEditingController>(TextEditingController()),
        );
      } else {
        showError(responseData['errorMessage']);
      }
    } catch (e) {
      showError("Failed to save data: $e");
    } finally {
      saveLoading(false);
    }
  }

  @override
  void onClose() {
    for (var controller in allControllers) {
      controller.value?.dispose();
    }
    super.onClose();
  }
}