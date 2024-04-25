import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goski_instructor/const/color.dart';
import 'package:goski_instructor/const/font_size.dart';
import 'package:goski_instructor/const/util/screen_size_controller.dart';
import 'package:goski_instructor/ui/component/goski_bottomsheet.dart';
import 'package:goski_instructor/ui/component/goski_card.dart';
import 'package:goski_instructor/ui/component/goski_container.dart';
import 'package:goski_instructor/ui/component/goski_switch.dart';
import 'package:goski_instructor/ui/component/goski_text.dart';
import 'package:goski_instructor/ui/component/goski_textfield.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();
final screenSizeController = Get.find<ScreenSizeController>();

class UpdateInstructorInfoScreen extends StatefulWidget {
  const UpdateInstructorInfoScreen({super.key});

  @override
  State<UpdateInstructorInfoScreen> createState() =>
      _UpdateInstructorInfoScreenState();
}

class _UpdateInstructorInfoScreenState
    extends State<UpdateInstructorInfoScreen> {
  List<String> certificates = [
    tr('certificate'),
    tr('certificate')
  ]; // 자격증을 렌더링할 리스트
  // List<File> certificateImages = []; // 자격증 이미지 파일 리스트, 나중에 진짜 파일 가져올 때 사용
  List<String> certificateImages = [
    "assets/images/certificate.png",
    "assets/images/certificate.png"
  ]; // 이미지 경로를 저장하는 리스트
  String profileImage = "assets/images/person2.png";
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    return GoskiContainer(
      onConfirm: () => 0,
      buttonName: "update",
      child: SingleChildScrollView(
        child: GoskiCard(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                buildRegisterProfilePhoto(),
                const BuildInterval(),
                const BuildBasicInfo(),
                const BuildInterval(),
                buildSelfIntroduction(),
                Column(
                  children: [
                    Row(
                      children: [
                        GoskiText(
                          text: tr("certificate"),
                          size: labelLarge,
                          isBold: true,
                          isExpanded: true,
                        ),
                        IconButton(
                          onPressed: () => {
                            showGoskiBottomSheet(
                              context: context,
                              child: const SizedBox(
                                height: 400,
                                child: SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: Text("자격증 바텀시트"),
                                  ),
                                ),
                              ),
                            ),
                            addCertificate(tr('certificate')),
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    buildCertificatesList(),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GoskiText(
                              text: tr("certificatePhoto"),
                              size: labelLarge,
                              isBold: true,
                              isExpanded: true,
                            ),
                            IconButton(
                              onPressed: pickCertificateImage,
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        certificateImages.isNotEmpty
                            ? buildCertificateImageList()
                            : Container(),
                      ],
                    ),
                    const BuildInterval(),
                    buildHolidaySetting(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRegisterProfilePhoto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: screenSizeController.getWidthByRatio(0.3),
          height: screenSizeController.getHeightByRatio(0.2),
          decoration: BoxDecoration(
            border: Border.all(color: goskiDarkGray, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(14), // Container borderRadius - 1
            child: profileImage == ""
                ? const Icon(Icons.photo, size: 50, color: Colors.grey)
                : Image.asset(profileImage, fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: screenSizeController.getHeightByRatio(0.005)),
        GestureDetector(
          onTap: pickProfileImage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.photo_outlined),
              GoskiText(
                text: tr("updateProfilePhoto"),
                size: bodySmall,
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSelfIntroduction() {
    return Column(
      children: [
        Row(
          children: [
            GoskiText(
              text: tr('selfIntroduction'),
              size: labelLarge,
              isBold: true,
              isExpanded: true,
            )
          ],
        ),
        const BuildInterval(),
        GoskiTextField(
          hintText: tr('enterSelfIntroduction'),
          maxLines: 3,
        )
      ],
    );
  }

  Widget buildCertificatesList() {
    return Column(
      children: certificates.map((certificate) {
        int index = certificates.indexOf(certificate);
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GoskiTextField(
                    width: screenSizeController.getWidthByRatio(0.6),
                    hintText: certificate,
                    canEdit: false,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => removeCertificate(index),
                ),
              ],
            ),
            const BuildInterval(),
          ],
        );
      }).toList(),
    );
  }

  Widget buildCertificateImageList() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: certificateImages.length,
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Image.asset(
                    certificateImages[index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: -12,
                  top: -10,
                  child: IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: goskiBlack,
                    ),
                    onPressed: () => removeCertificateImage(index),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildHolidaySetting() {
    return Column(
      children: [
        Row(
          children: [
            GoskiText(
              text: tr('holiday'),
              size: labelLarge,
              isBold: true,
              isExpanded: true,
            )
          ],
        ),
        const BuildInterval(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days.map((day) {
            return DayCheckbox(
              day: tr(day),
            );
          }).toList(),
        )
      ],
    );
  }

  Future<void> pickProfileImage() async {
    // 추후에 디바이스에서 사진 가져올 때 사용할 변수들
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      // 일단 assets 폴더에 있는 이미지의 경로를 리스트에 추가
      profileImage = "assets/images/person2.png";
    });
  }

  Future<void> pickCertificateImage() async {
    // 추후에 디바이스에서 사진 가져올 때 사용할 변수들
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      // 일단 assets 폴더에 있는 이미지의 경로를 리스트에 추가
      certificateImages.add("assets/images/certificate.png");
    });
  }

  void removeCertificateImage(int index) {
    setState(() {
      certificateImages.removeAt(index);
    });
  }

  void addCertificate(String certificate) {
    setState(() {
      certificates.add(certificate);
    });
  }

  void removeCertificate(int index) {
    if (index >= 0 && index < certificates.length) {
      setState(() {
        certificates.removeAt(index);
      });
    }
  }
}

class BuildBasicInfo extends StatelessWidget {
  const BuildBasicInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BasicInfoContainer(
          text: "name",
          textField: "enterName",
        ),
        const BuildInterval(),
        Row(
          children: [
            GoskiText(
              text: tr("gender"),
              size: labelLarge,
              isBold: true,
              isExpanded: true,
            ),
            GoskiSwitch(
                items: [tr('male'), tr('female')],
                width: screenSizeController.getWidthByRatio(0.6)),
          ],
        ),
        const BuildInterval(),
        const BasicInfoContainer(
          text: "birthDate",
          textField: "enterBirthDate",
        ),
        const BuildInterval(),
        const BasicInfoContainer(
          text: "phoneNumber",
          textField: "enterPhoneNumber",
        ),
      ],
    );
  }
}

class BasicInfoContainer extends StatelessWidget {
  final String text;
  final String textField;
  const BasicInfoContainer({
    required this.text,
    required this.textField,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GoskiText(
          text: tr(text),
          size: labelLarge,
          isBold: true,
          isExpanded: true,
        ),
        GoskiTextField(
          width: screenSizeController.getWidthByRatio(0.6),
          hintText: tr(textField),
        ),
      ],
    );
  }
}

class BuildInterval extends StatelessWidget {
  const BuildInterval({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenSizeController.getHeightByRatio(0.016),
    );
  }
}

class DayCheckbox extends StatefulWidget {
  final String day;

  const DayCheckbox({
    super.key,
    required this.day,
  });

  @override
  State<DayCheckbox> createState() => _DayCheckboxState();
}

class _DayCheckboxState extends State<DayCheckbox> {
  bool isChecked = false; // 기본값은 false

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GoskiText(
          text: tr(widget.day),
          size: bodyMedium,
          isBold: true,
        ),
        Transform.translate(
          offset: const Offset(
              0.0, -10.0), // Checkbox가 기본적으로 차지하고 있는 padding이 있어서 수동으로 위치 조정
          child: Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value ?? isChecked;
              });
            },
            activeColor: goskiBlack,
          ),
        ),
      ],
    );
  }
}
