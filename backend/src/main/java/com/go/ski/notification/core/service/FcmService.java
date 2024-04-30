package com.go.ski.notification.core.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.go.ski.common.constant.FileUploadPath;
import com.go.ski.common.exception.ApiExceptionFactory;
import com.go.ski.common.util.S3Uploader;
import com.go.ski.notification.core.domain.Notification;
import com.go.ski.notification.core.repository.NotificationRepository;
import com.go.ski.notification.support.dto.FcmMessageDTO;
import com.go.ski.notification.support.dto.FcmSendRequestDTO;
import com.go.ski.notification.support.exception.NotificationExceptionEnum;
import com.go.ski.user.core.model.User;
import com.go.ski.user.core.repository.UserRepository;
import com.go.ski.user.support.exception.UserExceptionEnum;
import com.google.auth.oauth2.GoogleCredentials;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import reactor.netty.http.server.HttpServerRequest;

import java.io.IOException;
import java.util.List;

import static com.go.ski.common.constant.FileUploadPath.NOTIFICATION_IMAGE_PATH;

@Slf4j
@RequiredArgsConstructor
@Service
public class FcmService {

    private static final String PREFIX_ACCESS_TOKEN = "Bearer ";
    private static final String PREFIX_FCM_REQUEST_URL = "https://fcm.googleapis.com/v1/projects/";
    private static final String POSTFIX_FCM_REQUEST_URL = "/messages:send";
    private static final String FIREBASE_KEY_PATH = "goSkiAccountKey.json";
    private static final String GOOGLE_AUTH_URL ="https://www.googleapids.com/auth/cloud-platform";

    @Value("${firebase.project.id}")
    private String projectId;

    private final S3Uploader s3Uploader;
    private final UserRepository userRepository;
    private final NotificationRepository notificationRepository;

    @Transactional
    public void sendMessageTo(FcmSendRequestDTO fcmSendRequestDTO) {
        String message = makeMessage(fcmSendRequestDTO);
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
        httpHeaders.add(HttpHeaders.AUTHORIZATION, PREFIX_ACCESS_TOKEN + getAccessToken());

        HttpEntity<String> httpEntity = new HttpEntity<>(message,httpHeaders);

        String fcmRequestUrl = PREFIX_FCM_REQUEST_URL + projectId + POSTFIX_FCM_REQUEST_URL;

        ResponseEntity<String> response = restTemplate.exchange(
            fcmRequestUrl,
            HttpMethod.POST,
            httpEntity,
            String.class
        );

        log.info("FcmService - response : {}",response.getStatusCode());

        if(response.getStatusCode().isError()){
            throw ApiExceptionFactory.fromExceptionEnum(NotificationExceptionEnum.FIREBASE_CONNECTION_ERROR);
        }


        String imageUrl = fcmSendRequestDTO.getImage() != null ?
                s3Uploader.uploadFile(NOTIFICATION_IMAGE_PATH.path, fcmSendRequestDTO.getImage()) :
                null;

        Notification notification = Notification.of(fcmSendRequestDTO,imageUrl);
        notificationRepository.save(notification);
    }

    @Transactional
    public String makeMessage(FcmSendRequestDTO fcmSendRequestDTO) {
        User sender = userRepository.findById(fcmSendRequestDTO.getSenderId())
                .orElseThrow(()->ApiExceptionFactory.fromExceptionEnum(UserExceptionEnum.WRONG_REQUEST));

        String targetToken = getToken(fcmSendRequestDTO.getReceiverId(), fcmSendRequestDTO.getDeviceType());

        FcmMessageDTO fcmMessageDTO = FcmMessageDTO.builder()
                .message(FcmMessageDTO.Message.builder()
                        .token(targetToken)
                        .data(FcmMessageDTO.Data.builder()
                                .senderId(fcmSendRequestDTO.getSenderId())
                                .senderName(sender.getUserName())
                                .title(fcmSendRequestDTO.getTitle())
                                .content(fcmSendRequestDTO.getContent())
                                .imageUrl(null)
                                .notificationType(fcmSendRequestDTO.getNotificationType())
                                .build()
                        ).build())
                .validateOnly(false).build();

        ObjectMapper objectMapper = new ObjectMapper();

        try {
            return objectMapper.writeValueAsString(fcmMessageDTO);
        } catch (JsonProcessingException e) {
            throw ApiExceptionFactory.fromExceptionEnum(NotificationExceptionEnum.CONVERTING_JSON_ERROR);
        }
    }

    private String getAccessToken() {
        try{
            GoogleCredentials googleCredentials =  GoogleCredentials
                    .fromStream(new ClassPathResource(FIREBASE_KEY_PATH).getInputStream())
                    .createScoped(List.of(GOOGLE_AUTH_URL));

            googleCredentials.refreshIfExpired();
            return googleCredentials.getAccessToken().getTokenValue();
        } catch(IOException e){
            throw ApiExceptionFactory.fromExceptionEnum(NotificationExceptionEnum.GOOGLE_REQUEST_TOKEN_ERROR);
        }

    }

    public String getToken(Integer userId, String type) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> ApiExceptionFactory.fromExceptionEnum(UserExceptionEnum.WRONG_REQUEST));
        return type.equals("web") ? user.getFcmWeb() : user.getFcmMobile();
    }

}
