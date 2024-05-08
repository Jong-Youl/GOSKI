import 'package:get/get.dart';
import 'package:goski_student/data/model/default_dto.dart';
import 'package:goski_student/data/model/lesson_list_response.dart';
import 'package:goski_student/data/model/sned_message_request.dart';
import 'package:logger/logger.dart';

import '../data/repository/lesson_list_repository.dart';

var logger = Logger();

class LessonListViewModel extends GetxController {
  final LessonListRepository lessonListRepository = Get.find();
  RxList<LessonListItem> lessonList = <LessonListItem>[].obs;
  Rx<SendMessage> message = SendMessage(receiverId: 0, title: '').obs;

  void initMessage(LessonListItem lesson) {
    message.value.receiverId = 34;
        // lesson.instructorId == null ? 0 : lesson.instructorId!;
    message.value.title = '';
    message.value.content = '';
    message.value.image = null;
    message.value.hasImage = false;
  }

  bool isValidMessage() {
    return message.value.receiverId != 0 && message.value.title.isNotEmpty;
  }

  void getUserInfo() async {
    List<LessonListItem> response = await lessonListRepository.getLessonList();

    lessonList.value = response;
  }

  Future<bool> sendMessage() async {
    if (isValidMessage()) {
      DefaultDTO? response =
          await lessonListRepository.sendMessage(message.value);

      logger.w('일단 유효한 메시지');

      if (response != null && response.status == 'success') {
        return true;
      }
    }

    logger.w('일단 유효하지 않은 메시지 ${message.value.toString()}');

    return false;
  }
}
