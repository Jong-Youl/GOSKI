package com.go.ski.schedule.core.controller;

import com.go.ski.common.response.ApiResponse;
import com.go.ski.schedule.core.service.ScheduleService;
import com.go.ski.schedule.support.dto.CreateScheduleRequestDTO;
import com.go.ski.schedule.support.vo.ReserveScheduleVO;
import com.go.ski.team.core.model.Team;
import com.go.ski.user.core.model.User;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/v1/schedule")
@RestController
public class ScheduleController {
    private final ScheduleService scheduleService;

    @GetMapping("/mine")
    public ResponseEntity<ApiResponse<?>> getMySchedule(HttpServletRequest request) {
        log.info("본인 스케줄 조회");
        User user = (User) request.getAttribute("user");
        return ResponseEntity.status(HttpStatus.OK).body(ApiResponse.success(scheduleService.getMySchedule(user)));
    }

    @GetMapping("/{teamId}/{lessonDate}")
    public ResponseEntity<ApiResponse<?>> getTeamSchedule(HttpServletRequest request, @PathVariable int teamId, @PathVariable LocalDate lessonDate) {
        log.info("팀 스케줄 조회: {}, {}", teamId, lessonDate);
        User user = (User) request.getAttribute("user");
        return ResponseEntity.status(HttpStatus.OK).body(ApiResponse.success(scheduleService.getTeamSchedule(user, teamId, lessonDate)));
    }

    @PostMapping("/create")
    public ResponseEntity<ApiResponse<?>> createSchedule(@RequestBody CreateScheduleRequestDTO createScheduleRequestDTO) {
        log.info("스케줄 등록: {}", createScheduleRequestDTO);
        Team team = Team.builder().teamId(createScheduleRequestDTO.getTeamId()).build();
        ReserveScheduleVO reserveScheduleVO = new ReserveScheduleVO(createScheduleRequestDTO);
        if (scheduleService.scheduleCaching(team, reserveScheduleVO)) {
            scheduleService.createSchedule(reserveScheduleVO);
        }
        return ResponseEntity.status(HttpStatus.OK).body(ApiResponse.success(null));
    }

}