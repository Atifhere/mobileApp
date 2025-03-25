class SelectedItemModel {

  late String subCategoryId;
  late int serviceFee;

  SelectedItemModel({required this.subCategoryId, required this.serviceFee});


  Map<String, dynamic> toJson() {
    return {
      "subCategoryId": subCategoryId,
      "serviceFee": serviceFee,
    };
  }

}