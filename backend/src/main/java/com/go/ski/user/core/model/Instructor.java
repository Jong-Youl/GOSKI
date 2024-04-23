package com.go.ski.user.core.model;

import com.go.ski.user.support.vo.InstructAvailable;
import jakarta.persistence.*;
import lombok.*;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = PROTECTED)
@Getter
@Table
public class Instructor {
    @Id
    private int userId; // User의 PK를 여기서도 PK로 사용

    @MapsId // User의 userId를 Instructor의 PK로 매핑
    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Setter
    private String description;

    @Setter
    private InstructAvailable isInstructAvailable;

    @Setter
    @Column(nullable = false, columnDefinition = "INT DEFAULT 0")
    private int dayoff;
}
