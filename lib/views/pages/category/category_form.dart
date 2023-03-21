// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_grounda/controllers/themeController/theme_change_controller.dart';
import 'package:frontend_grounda/utils/constants.dart';
import 'package:frontend_grounda/widgets/buttons.dart';
import 'package:frontend_grounda/widgets/text_ediotor.dart';
import 'package:frontend_grounda/widgets/text_fields.dart';

import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class CategoryForm extends GetView<ThemeChangeController> {
  CategoryForm(
      {required this.categoryNameController,
      required this.categorySlugController,
      required this.categoryStatusController,
      required this.descriptionController,
      required this.dropDownList,
      required this.dropDownValue,
      required this.onChange,
      required this.statusChanges,
      required this.formSubmit,
      required this.statusValue,
      required this.uploadImages,
      super.key});
  double width = Get.width;
  double height = Get.height;
  String dropDownValue;
  dynamic onChange;
  dynamic statusChanges;
  dynamic formSubmit;
  bool statusValue;
  dynamic uploadImages;
  List<DropdownMenuItem<String>> dropDownList;
  TextEditingController categoryNameController;
  TextEditingController categorySlugController;
  TextEditingController categoryStatusController;

  QuillEditorController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create Category",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: height * 0.03,
        ),

        DropdownButton(
          borderRadius: BorderRadius.circular(15),
          hint: const Text("Select Parent Category"),
          isExpanded: true,
          value: dropDownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: Theme.of(context).textTheme.bodyMedium,
          underline: Container(
            height: 2,
            color: kDarkColor,
          ),
          onChanged: onChange,
          items: dropDownList,
        ),

        SizedBox(
          height: height * 0.03,
        ),
        DefaultTextField(
          hintText: "Category Name",
          labelText: "Category Name",
          isPassword: false,
          textEditingController: categoryNameController,
        ),
        SizedBox(
          height: height * .02,
        ),
        DefaultTextField(
          hintText: "Category Slug",
          labelText: "Category Slug",
          isPassword: false,
          textEditingController: categorySlugController,
        ),
        SizedBox(
          height: height * .02,
        ),
        // TODO; Add rich text editor
        Expanded(child: TextEditor(controller: descriptionController)),

        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 0.0),
          child: Transform.scale(
            scale: .8,
            child: Row(
              children: [
                Text(
                  "Status",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(
                  width: width * .01,
                ),
                CupertinoSwitch(
                  activeColor: kPrimaryColor,
                  value: statusValue,
                  onChanged: statusChanges,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: height * .02,
        ),
        DefaultButton(
          primaryColor: kPrimaryColor,
          hoverColor: kDarkColor,
          buttonText: "Add Picture",
          width: width * .2,
          height: height * .05,
          onPressed: uploadImages,
        ),
        SizedBox(
          height: height * .02,
        ),
        DefaultButton(
          primaryColor: kPrimaryColor,
          hoverColor: kDarkColor,
          buttonText: "Submit",
          width: width * .2,
          height: height * .05,
          onPressed: formSubmit,
        ),
      ],
    );
  }
}
