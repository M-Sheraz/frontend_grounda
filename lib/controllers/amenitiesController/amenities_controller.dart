import 'dart:convert';

import 'package:frontend_grounda/models/amenetiesModel/ameneties_model.dart';
import 'package:frontend_grounda/utils/global_variable.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class AmenitiesController extends GetxController {
  var amenities = <AmenitiesModel>[].obs;
  final Box<dynamic> tokenHiveBox = Hive.box('token');
  var token = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    token.value = tokenHiveBox.get('token');
    getAll();
  }

  Future<void> getAll() async {
    isLoading.value = true;
    var response = await http.get(
      Uri.parse(
        baseUrl + getAmenities,
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200 && response.body != 'null') {
      amenities.value = amenitiesModelFromJson(response.body);
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
        baseUrl + getAmenities + id,
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200 && response.body != 'null') {
      amenities.value = amenitiesModelFromJson(response.body);
      isLoading.value = false;
    } else {
      Get.snackbar('Error', response.body,
          snackPosition: SnackPosition.BOTTOM, maxWidth: 400);
      isLoading.value = false;
    }
  }

  Future<void> create(
    String name,
    String slug,
    bool isPublished,
    int catId,
    String description,
  ) async {
    isLoading.value = true;
    var bodyPrepare = {
      "name": name,
      "slug": slug,
      "description": description,
      "published": isPublished,
      "categoryId": catId
    };

    var response = await http.post(
      Uri.parse(
        baseUrl + createAmenities,
      ),
      body: jsonEncode(bodyPrepare),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200 && response.body != 'null') {
      amenities.addAll(amenitiesModelFromJson(response.body));
      isLoading.value = false;
    } else {
      Get.snackbar('Error', response.body,
          snackPosition: SnackPosition.BOTTOM, maxWidth: 400);
      isLoading.value = false;
    }
  }

  Future<void> updateAmenities(
    int id,
    String name,
    String slug,
    bool isPublished,
    int catId,
    String description,
  ) async {
    isLoading.value = true;
    var bodyPrepare = {
      "id": id,
      "name": name,
      "slug": slug,
      "description": description,
      "published": isPublished,
      "categoryId": catId
    };

    var response = await http.put(
      Uri.parse(
        baseUrl + updateAmenites,
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
        baseUrl + deleteAmenities + id,
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200 && response.body != 'null') {
      getAll();
      var deletedAmenities = jsonDecode(response.body);
      var amenities = deletedAmenities['name'];
      Get.snackbar('Amenity Deleted',
          'The Amenity with name: $amenities has been deleted',
          snackPosition: SnackPosition.BOTTOM, maxWidth: 400);
      isLoading.value = false;
    } else {
      Get.snackbar('Error', response.body,
          snackPosition: SnackPosition.BOTTOM, maxWidth: 400);
      isLoading.value = false;
    }
  }
}
