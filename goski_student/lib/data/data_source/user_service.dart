import 'dart:convert';

import 'package:get/get.dart';
import 'package:goski_student/const/util/custom_dio.dart';
import 'package:goski_student/data/data_source/main_service.dart';
import 'package:goski_student/data/model/default_dto.dart';
import 'package:goski_student/main.dart';

class UserService extends GetxService {
  Future<void> sendFCMTokenToServer(String fcmToken) async {
    try {
      dynamic response = await CustomDio.dio.post(
        '$baseUrl/notification/token',
        data: jsonEncode(<String, String>{
          'token': fcmToken,
          'tokenType': "MOBILE",
        }),
      );
      if (response.data['status'] == "success") {
        logger.d('FCMToken successfully sent to the server');
        logger.d("response: ${response.data}");
      } else {
        logger.e('Failed to send FCMToken to the server: ${response.data}');
      }
    } catch (e) {
      logger.e('Error sending FCMToken to the server: $e');
    }
  }

  Future<DefaultDTO?> requestResign() async {
    try {
      dynamic response = await CustomDio.dio.delete(
          '$baseUrl/user/resign',
      );

      if (response.data['status'] == "success") {
        logger.d('UserService - requestResign - 응답 성공');
        DefaultDTO defaultDTO =
        DefaultDTO.fromJson(response.data as Map<String, dynamic>);
        return defaultDTO;
      } else {
        logger.e('UserService - requestResign - 응답 실패 ${response.body}');
      }
    } catch (e) {
      logger.e('UserService - requestResign - 응답 실패 $e');
    }

    return null;
  }
}
