package com.go.ski.lesson.support.dto;

import com.go.ski.payment.core.model.Lesson;
import com.go.ski.payment.core.model.LessonInfo;
import lombok.Getter;

@Getter
public class UserLessonResponseDTO extends LessonResponseDTO {
    Integer instructorId;
    String instructorName;
    String profileUrl;

    public UserLessonResponseDTO(Lesson lesson, LessonInfo lessonInfo) {
        super(lesson, lessonInfo);
        instructorId = lesson.getInstructor().getInstructorId();
        instructorName = lesson.getInstructor().getUser().getUserName();
        profileUrl = lesson.getInstructor().getUser().getProfileUrl();
    }
}