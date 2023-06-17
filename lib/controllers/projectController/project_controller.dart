import 'dart:convert';
import 'dart:html';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend_grounda/models/projectModel/project_model.dart';
import 'package:frontend_grounda/utils/global_variable.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_web/image_picker_web.dart';

class ProjectController extends GetxController {
  var project = <ProjectsModel>[].obs;
  final Box<dynamic> tokenHiveBox = Hive.box('token');
  var isLoading = false.obs;

  // variable defnation
  var imageUrl = [].obs;
  List purposeList = ["SELL", "RENT"];

  // GetX variables
  var projectID = 0.obs;
  var developerID = 0.obs;
  var catID = 0.obs;
  var token = ''.obs;
  var isPublished = 0.obs;

  var startingPrice = 0.0.obs;
  var endingPrice = 0.0.obs;

  RxString purposeValue = 'SELL'.obs;

  late FocusNode formFocus;
  late FocusNode projectLocalityFocus;
  late FocusNode titleFieldFocus;
  late FocusNode projectAddressFocus;
  late FocusNode cityFieldFocus;

  //<=================== Text Editing Controllers ==================>
  TextEditingController projectTitleController = TextEditingController();
  TextEditingController projectCategoryController = TextEditingController();
  TextEditingController projectAddressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController projectLocalityController = TextEditingController();
  TextEditingController startingPriceController = TextEditingController();
  TextEditingController endingPriceController = TextEditingController();
  TextEditingController advanceController = TextEditingController();
  TextEditingController noOfInstallmentController = TextEditingController();
  TextEditingController monthlyInstallmentController = TextEditingController();
  TextEditingController bedroomController = TextEditingController();
  TextEditingController bathroomController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    token.value = tokenHiveBox.get('token');
    getAll();
    projectLocalityFocus = FocusNode();
    projectLocalityFocus = FocusNode();
    titleFieldFocus = FocusNode();
    projectAddressFocus = FocusNode();
    formFocus = FocusNode();
    cityFieldFocus = FocusNode();
  }

  Future<void> getAll() async {
    isLoading.value = true;
    var response = await http.get(
      Uri.parse(
        baseUrl + allProject,
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    print('Responce on projects is');
    print(response.body);
    if (response.statusCode == 200 && response.body != 'null') {
      project.value = projectsModelFromJson(response.body);
      isLoading.value = false;
    } else {
      Get.snackbar('Error', response.body,
          snackPosition: SnackPosition.BOTTOM, maxWidth: 400);
      isLoading.value = false;
    }
  }

  Future<void> getbyId(String id) async {
    isLoading.value = true;
    var response = await http.get(
      Uri.parse(
        baseUrl + allProject + id,
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200 && response.body != 'null') {
      project.value = projectsModelFromJson(response.body);
      isLoading.value = false;
    } else {
      Get.snackbar('Error', response.body,
          snackPosition: SnackPosition.BOTTOM, maxWidth: 400);
      isLoading.value = false;
    }
  }

  //MultiImage Picker
  getImage() async {
    List<File>? res = await ImagePickerWeb.getMultiImagesAsFile();
    if (res != null) {
      for (var i = 0; i < res.length; i++) {
        String fileName = res[i].name;
        var upload = await FirebaseStorage.instance
            .ref('uploads/post/images/$fileName')
            .putBlob(res[i]);
        final url = upload.ref.getDownloadURL().then((value) {
          imageUrl.add(value);
        });
      }
    }
  }

  Future<void> create(
    String title,
    String address,
    String featuredImage,
    String gallery,
    String locality,
    String city,
    int categoryId,
    int developerId,
    double startingPrice,
    double endingPrice,
    bool status,
  ) async {
    isLoading.value = true;
    var bodyPrepare = {
      "title": title,
      "address": address,
      "featuredImage": featuredImage,
      "gallery": gallery,
      "locality": locality,
      "city": city,
      "categoryId": categoryId,
      "developerId": developerId,
      "startingPrice": startingPrice,
      "endingPrice": endingPrice,
      "status": status
    };

    var response = await http.post(
      Uri.parse(
        baseUrl + createProject,
      ),
      body: jsonEncode(bodyPrepare),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200 && response.body != 'null') {
      project.addAll(projectsModelFromJson(response.body));
      isLoading.value = false;
    } else {
      Get.snackbar('Error', response.body,
          snackPosition: SnackPosition.BOTTOM, maxWidth: 400);
      isLoading.value = false;
    }
  }

  Future<void> updateProject(
    int id,
    String title,
    String address,
    String featuredImage,
    String gallery,
    String locality,
    String city,
    int categoryId,
    int developerId,
    double startingPrice,
    double endingPrice,
    bool status,
  ) async {
    isLoading.value = true;
    var bodyPrepare = {
      "id": id,
      "title": title,
      "address": address,
      "featuredImage": featuredImage,
      "gallery": gallery,
      "locality": locality,
      "city": city,
      "categoryId": categoryId,
      "developerId": developerId,
      "startingPrice": startingPrice,
      "endingPrice": endingPrice,
      "status": status
    };

    var response = await http.put(
      Uri.parse(
        baseUrl + updateProjectUrl,
      ),
      body: jsonEncode(bodyPrepare),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200 && response.body != 'null') {
      getAll();
      isLoading.value = false;
    } else {
      Get.snackbar('Error', response.body,
          snackPosition: SnackPosition.BOTTOM, maxWidth: 400);
      isLoading.value = false;
    }
  }

  Future<void> delete(
    String id,
  ) async {
    isLoading.value = true;
    var response = await http.delete(
      Uri.parse(
        baseUrl + deleteProject + id,
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200 && response.body != 'null') {
      getAll();
      var deletedProjects = jsonDecode(response.body);
      var projects = deletedProjects['name'];
      Get.snackbar('Project Deleted',
          'The Project with name: $projects has been deleted',
          snackPosition: SnackPosition.BOTTOM, maxWidth: 400);
      isLoading.value = false;
    } else {
      Get.snackbar('Error', response.body,
          snackPosition: SnackPosition.BOTTOM, maxWidth: 400);
      isLoading.value = false;
    }
  }
}
