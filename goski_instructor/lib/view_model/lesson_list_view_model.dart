import 'package:get/get.dart';
import 'package:goski_instructor/data/model/lesson_list_response.dart';

import '../data/repository/lesson_list_repository.dart';

class LessonListViewModel extends GetxController {
  final LessonListRepository lessonListRepository = Get.find();
  RxList<LessonList> lessonList = <LessonList>[].obs;

  // Rx<SendMessage> message = SendMessage(receiverId: 0, title: '').obs;
  Rx<LessonList> selectedLesson = LessonList(
    lessonId: 0,
    teamId: 0,
    teamName: '',
    resortName: '',
    lessonDate: DateTime.now(),
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    duration: 0,
    representativeName: '',
    isDesignated: false,
    studentInfoList: [],
    lessonStatus: '',
    // hasReview: false,
    // studentCount: 0,
  ).obs;
  RxBool isLoadingLessonList = true.obs;

  // void initMessage(LessonList lesson) {
  //   message.value.receiverId = 34;
  //   // lesson.instructorId == null ? 0 : lesson.instructorId!;
  //   message.value.title = '';
  //   message.value.content = '';
  //   message.value.image = null;
  //   message.value.hasImage = false;
  // }

  // bool isValidMessage() {
  //   return message.value.receiverId != 0 && message.value.title.isNotEmpty;
  // }

  Future<void> getLessonList() async {
    isLoadingLessonList.value = true;
    List<LessonList> response = await lessonListRepository.getLessonList();

    lessonList.value = response
        .where((settlement) => settlement.lessonStatus != 'cancelLesson')
        .toList();
    isLoadingLessonList.value = false;
  }

// Future<bool> sendMessage() async {
//   if (isValidMessage()) {
//     DefaultDTO? response =
//         await lessonListRepository.sendMessage(message.value);
//
//     if (response != null && response.status == 'success') {
//       return true;
//     }
//   }
//
//   return false;
// }
}
