package com.tech.whale.setting.service;

import com.tech.whale.setting.dao.SettingDao;
import com.tech.whale.setting.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class SettingService {

    private final SettingDao settingDao;

    @Autowired
    public SettingService(SettingDao settingDao) {
        this.settingDao = settingDao;
    }

    UserInfoDto userInfoDto;
    UserSettingDto userSettingDto;
    UserNotificationDto userNotificationDto;
    StartpageDto startpageDto;
    PageAccessDto pageAccessDto;

    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public UserInfoDto profile(String session_user_id) {
        UserInfoDto userInfoDto = settingDao.getProfile(session_user_id);

        return userInfoDto;
    }

    public String currentPassword(String session_user_id) {
        String dbPassword = settingDao.getCurrentPassword(session_user_id);

        return dbPassword;
    }

    public Map<String, String> compare(String currentPassword, String dbPassword) {
        Map<String, String> response = new HashMap<>(); // 응답 데이터 저장할 Map 객체 생성(key-value)

        // passwordEncoder.mathes() 함수 사용해 입력한 비밀번호(currentPassword)와 DB에 저장된 비밀번호(dbPassword)와 비교
        if (passwordEncoder.matches(currentPassword, dbPassword)) {
            response.put("status", "valid");
        } else {
            response.put("status", "invalid");
        }

        return response;
    }

    public void updatePassword(String session_user_id, String encodedPassword) {
        settingDao.updatePassword(session_user_id, encodedPassword); // 암호화된 새로운 비밀번호 업데이트
        System.out.println("DB 업데이트 완료");
    }

    public String currentProfileImage(String session_user_id) {
        String userProfileImageUrl = settingDao.getCurrentProfileImage(session_user_id);

        return userProfileImageUrl;
    }

    public void updateProfile(String nickname, String email, String userProfileImageUrl, String session_user_id) {
        settingDao.updateProfile(nickname, email, userProfileImageUrl, session_user_id);
        System.out.println("DB 업데이트 완료");
    }

    public void updateSong(String session_user_id, String trackId) {
        // user_info 테이블의 representivesong 필드에 trackId 업데이트
        settingDao.updateRepresentiveSong(session_user_id, trackId);
        System.out.println("대표곡 업데이트 완료");
    }

    public int accountPrivacy(String session_user_id) {
        int accountPrivacy = settingDao.getAccountPrivacyByUserId(session_user_id);

        return accountPrivacy;
    }

    public List<String> followRequestList(String session_user_id) {
        List<String> followList = settingDao.getFollowRequestList(session_user_id);

        return followList;
    }

    public void updateAccountPrivacy(String session_user_id, int accountPrivacy) {
        settingDao.updateAccountPrivacy(session_user_id, accountPrivacy);
    }

    public List<HiddenFeedDto> hiddenFeedList(String session_user_id) {
        List<HiddenFeedDto> hiddenFeedList = settingDao.getHiddenFeedList(session_user_id);

        return hiddenFeedList;
    }

    public List<LikeListDto> filteredPostLikeList(String session_user_id, String orderBy, String postType) {
        List<LikeListDto> postLikeList = settingDao.getFilteredPostLikeList(session_user_id, orderBy, postType);

        return postLikeList;
    }

    public List<CommentListDto> filteredPostCommentList(String session_user_id, String orderBy, String postType) {
        List<CommentListDto> postFeedList = settingDao.getFilteredPostCommentList(session_user_id, orderBy, postType);

        return postFeedList;
    }

    public List<CommentListDto> filteredPostReplyCommentList(String session_user_id, String orderBy, String postType) {
        List<CommentListDto> postFeedCommentList = settingDao.getFilteredPostReplyCommentList(session_user_id, orderBy, postType);

        return postFeedCommentList;
    }

    public UserNotificationDto notificationSetting(String session_user_id) {
        userNotificationDto = settingDao.getNotificationSettingsByUserId(session_user_id);

        return userNotificationDto;
    }

    public void updateNotificationSetting(String session_user_id, int allNotificationOff, int likeNotificationOnoff, int commentNotificationOnoff, int messageNotificationOnoff) {
        settingDao.updateNotificationSettings(session_user_id, allNotificationOff, likeNotificationOnoff, commentNotificationOnoff, messageNotificationOnoff);
        System.out.println("DB 업데이트 성공");
    }

    public void updateLikeNotification(String session_user_id, Optional<Integer> likeNotificationOnoff) {
        settingDao.updateLikeNotification(session_user_id, likeNotificationOnoff.get()); // get()으로 값을 꺼내서 사용
    }

    public void updateCommentNotification(String session_user_id, Optional<Integer> commentNotificationOnoff) {
        settingDao.updateCommentNotification(session_user_id, commentNotificationOnoff.get());
    }

    public void updateMessageNotification(String session_user_id, Optional<Integer> messageNotificationOnoff) {
        settingDao.updateMessageNotification(session_user_id, messageNotificationOnoff.get());
    }

    public UserSettingDto darkmode(String session_user_id) {
        userSettingDto = settingDao.getDarkmode(session_user_id);

        return userSettingDto;
    }

    public void updateDarkmode(String session_user_id, int darkmodeOn) {
        settingDao.updateDarkmode(session_user_id, darkmodeOn);
        System.out.println("DB 업데이트 성공");
    }

    public StartpageDto startpageSetting(String session_user_id) {
        startpageDto = settingDao.getStartpageSetting(session_user_id);

        return startpageDto;
    }

    public ResponseEntity<Map<String, String>> updateStartpageSetting(String session_user_id, String left, String right) {
        try {
            settingDao.updateStartpageSetting(session_user_id, left, right);

            Map<String, String> response = new HashMap<>();
            response.put("message", "업데이트 성공");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> response = new HashMap<>();
            response.put("message", "업데이트 실패");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    public PageAccessDto pageAccessSetting(String session_user_id) {
        pageAccessDto = settingDao.getPageAccessSetting(session_user_id);

        return  pageAccessDto;
    }

    public ResponseEntity<Map<String, String>> updatePageAccessSetting(String session_user_id, String settingType, String selectedValue) {
        try {
            settingDao.updatePageAccessSetting(session_user_id, settingType, selectedValue);

            Map<String, String> response = new HashMap<>();
            response.put("message", "업데이트 성공");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> response = new HashMap<>();
            response.put("message", "업데이트 실패");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
