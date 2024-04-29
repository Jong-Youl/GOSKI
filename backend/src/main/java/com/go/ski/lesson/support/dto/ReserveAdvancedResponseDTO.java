package com.go.ski.lesson.support.dto;

import com.go.ski.lesson.support.vo.CertificateInfoVO;
import com.go.ski.team.core.model.Permission;
import com.go.ski.user.core.model.Instructor;
import com.go.ski.user.core.model.User;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class ReserveAdvancedResponseDTO {
    private Integer instructorId;
    private String userName;
    private Integer position;
    private String description;
    private List<CertificateInfoVO> certificateInfoVOs;
    private Integer cost;
    private Double rating;
    private Integer ratingCount;

    public ReserveAdvancedResponseDTO(User user, Instructor instructor, Permission permission, List<CertificateInfoVO> certificateInfoVOs) {
        instructorId = instructor.getInstructorId();
        userName = user.getUserName();
        position = permission.getPosition();
        description = instructor.getDescription();
        this.certificateInfoVOs = certificateInfoVOs;
    }
}
