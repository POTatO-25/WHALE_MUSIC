package com.tech.whale.setting.controllers;

import java.util.*;

import javax.servlet.http.HttpSession;

import com.tech.whale.login.dao.UserDao;
import com.tech.whale.main.models.MainDao;
import com.tech.whale.main.service.MainService;
import com.tech.whale.setting.dto.*;
import com.tech.whale.setting.service.SettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.tech.whale.setting.dao.ReportDao;
import com.tech.whale.streaming.service.StreamingService;

@Controller
public class SettingController {
    UserInfoDto userinfoDto;
    StartpageDto startpageDto;
    UserSettingDto userSettingDto;
    UserNotificationDto userNotificationDto;
    PageAccessDto pageAccessDto;
    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    private final MainService mainService;
    private final StreamingService streamingService;
    private final ReportDao reportDao;
    private final SettingService settingService;
    private final UserDao userDao;
    private final MainDao mainDao;
    private final JdbcTemplate jdbcTemplate;

    // 생성자를 통한 의존성 주입
    @Autowired
    public SettingController(MainService mainService, StreamingService streamingService, ReportDao reportDao,
                             SettingService settingService, UserDao userDao, MainDao mainDao, JdbcTemplate jdbcTemplate) {
        this.mainService = mainService;
        this.streamingService = streamingService;
        this.reportDao = reportDao;
        this.settingService = settingService;
        this.userDao = userDao;
        this.mainDao = mainDao;
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/settingHome")
    public String settingHome() {
        System.out.println("settingHome() ctr");

        return "setting/settingHome";
    }

    @GetMapping("/profileEdit")
    public String profileEdit(HttpSession session, Model model) {
        System.out.println("profileEdit() ctr");
        // 세션에서 가져온 user_id 저장
        String session_user_id = (String) session.getAttribute("user_id");

        // user_id의 정보 가져오기
        UserInfoDto userinfoDto = settingService.profile(session_user_id);
        model.addAttribute("profile", userinfoDto); // model에 저장

        return "setting/profileEdit";
    }

    @GetMapping("/updatePassword")
    public String updatePassword() {
        System.out.println("updatePassword() ctr");

        return "setting/updatePassword";
    }

    @PostMapping("/checkCurrentPassword")
    @ResponseBody
    public Map<String, String> checkCurrentPassword(@RequestParam("current_password") String currentPassword, HttpSession session) {
        System.out.println("checkCurrentPassword() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        // 사용자의 현재 비밀번호 가져오기 위해 service 호출
        String dbPassword = settingService.currentPassword(session_user_id);

        Map<String, String> response = settingService.compare(currentPassword, dbPassword);

        return response;
    }

    @PostMapping("/updateNewPassword")
    @ResponseBody
    public Map<String, String> updateNewPassword(@RequestParam("new_password") String newPassword, HttpSession session) {
        System.out.println("updateNewPassword() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        String encodedPassword = passwordEncoder.encode(newPassword); // encode()를 사용해 입력된 비밀번호를 해싱 처리

        Map<String, String> response = new HashMap<>(); // Map 객체 생성

        settingService.updatePassword(session_user_id, encodedPassword);
        response.put("status", "success");

        return response;
    }

    @PostMapping("/updateProfile")
    public String updateProfile(@RequestParam("user_nickname") String nickname, @RequestParam("user_email") String email,
                                @RequestParam(value = "user_profile_image_url", required = false) String userProfileImageUrl,
                                HttpSession session) {
        System.out.println("updateProfile() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        // 프로필 이미지를 변경하지 않은 경우 DB에 저장된 url 값을 가져오기
        if (userProfileImageUrl == null || userProfileImageUrl.isEmpty()) {
            userProfileImageUrl = settingService.currentProfileImage(session_user_id);
        }

        // DB에 변경한 프로필 정보 업데이트
        settingService.updateProfile(nickname, email, userProfileImageUrl, session_user_id);

        return "redirect:/profileEdit"; // profileEdit 페이지로 리다이렉트
    }

    @GetMapping("/representiveSong")
    public String representiveSong() {
        System.out.println("representiceSong() ctr");

        return "setting/representiveSong";
    }

    @PostMapping(value = "/updateRepresentive", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> updateRepresentive(@RequestBody HashMap<String, Object> map, HttpSession session) {
        System.out.println("updateRepresentive() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        // 스트리밍 검색 기능
        // 클라이언트가 보낸 JSON 데이터를 파싱해서 트랙 정보 추출
        String artistName = ((ArrayList<HashMap<String, String>>) map.get("artists")).get(0).get("name"); // artists 필드는 배열 형식이므로 ArrayList<HashMap<String, String>>로 캐스팅
        String trackName = map.get("name").toString();
        String albumName = ((Map<String, String>) map.get("album")).get("name");
        String albumCover = (((Map<String, ArrayList<HashMap<String, String>>>) map.get("album")).get("images")).get(0).get("url"); // 앨범 객체의 images 배열의 첫 번째 이미지 객체 url 가져오기
        String trackSpotifyId = map.get("id").toString();

        // selectTrackIdService 메소드 호출해서 trackId 가져오기
        String trackId = streamingService.selectTrackIdService(trackSpotifyId, artistName, trackName, albumName, albumCover);
        settingService.updateSong(session_user_id, trackId);

        // 성공 응답 반환
        return ResponseEntity.ok().build();
    }

    @GetMapping("/account")
    public String account() {
        System.out.println("account() ctr");

        return "setting/account";
    }

    @GetMapping("/accountPrivacy")
    public String accountPrivacy(HttpSession session, Model model) {
        System.out.println("accountPrivacy() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        // 비공개 계정 설정 값 가져오기
        int accountPrivacy = settingService.accountPrivacy(session_user_id);
        model.addAttribute("accountPrivacyOn", accountPrivacy);

        return "setting/accountPrivacy";
    }

    @PostMapping
    @ResponseBody
    public String privateFollowNoti(HttpSession session) {
        System.out.println("privateFollowNoti() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        List<String> followList = settingService.followRequestList(session_user_id); // follow_noti 테이블에서 팔로우 요청 보낸 사람 리스트 가져오기

        // 비공개 계정에서 공개로 전환할 때, 기존에 사용자에게 팔로우 수락 요청을 보낸 사람이 있을 경우
        // 1. 사용자 팔로워에 상대방 추가
        // 2. 사용자에게 온 팔로우 수락 요청 알림 삭제
        // 3. 상대방에게 사용자가 팔로우를 수락했다는 알림 보내기
        // 4. 상대방의 팔로우 목록에 사용자가 없으면 상대방에게 맞팔로우 요청 알림 보내기
        for (String follow_id : followList) {
            mainService.privateFollowNotiMainService(session_user_id, follow_id);
        }

        return "success";
    }

    @PostMapping("/updatePrivacy")
    @ResponseBody
    public String updatePrivacy(@RequestParam("account_privacy") int accountPrivacy, HttpSession session) {
        System.out.println("updatePrivacy() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        settingService.updateAccountPrivacy(session_user_id, accountPrivacy); // 비공개 계정 여부 DB 업데이트

        return "success";
    }

    @RequestMapping("/hiddenFeed")
    public String hiddenFeed(HttpSession session, Model model) {
        System.out.println("hiddenFeed() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        // 숨긴 피드 가져오기
        List<HiddenFeedDto> hiddenFeedList = settingService.hiddenFeedList(session_user_id);

        model.addAttribute("hiddenFeedList", hiddenFeedList);

        return "setting/hiddenFeed";
    }

    @GetMapping("/activity")
    public String activity() {
        System.out.println("activity() ctr");

        return "setting/activity";
    }

    @RequestMapping("/likeList")
    public String likeList(@RequestParam(defaultValue = "최신순") String sortOrder, @RequestParam(defaultValue = "게시글") String postType, HttpSession session, Model model) {
        System.out.println("likeList() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        String orderBy = sortOrder.equals("최신순") ? "DESC" : "ASC";

        List<LikeListDto> postLikeList = settingService.filteredPostLikeList(session_user_id, orderBy, postType);

        model.addAttribute("postLikeList", postLikeList);
        model.addAttribute("selectedSortOrder", sortOrder);
        model.addAttribute("selectedPostType", postType);

        return "setting/likeList";
    }

    @RequestMapping("/commentList")
    public String commentList(@RequestParam(defaultValue = "최신순") String sortOrder, @RequestParam(defaultValue = "게시글") String postType, HttpSession session, Model model) {
        System.out.println("commentList() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        String orderBy = sortOrder.equals("최신순") ? "DESC" : "ASC";

        List<CommentListDto> postFeedList = settingService.filteredPostCommentList(session_user_id, orderBy, postType); // 글 정보와 댓글 정보
        List<CommentListDto> postFeedCommentList = settingService.filteredPostReplyCommentList(session_user_id, orderBy, postType); // 답글 정보

        // 게시글과 피드 ID를 각각 중복 없이 저장할 Set 생성
        Set<Integer> uniquePostIds = new HashSet<>(); // 게시글 ID를 저장하는 Set
        Set<Integer> uniqueFeedIds = new HashSet<>(); // 피드 ID를 저장하는 Set

        // 중복 제거된 게시글 또는 피드 데이터를 담을 리스트
        List<CommentListDto> filteredPostFeedCommentList = new ArrayList<>();

        // postFeedList에 있는 각 데이터를 순회하며 중복 제거 작업 수행
        for (CommentListDto dto : postFeedList) {
            // 현재 선택된 postType이 게시글이고, Set(uniquePostIds)에 현재 게시글 ID(dto.getPost_id())를 추가했을 때 중복이 아니라면
            // 중복되지 않은 게시글 데이터를 결과 리스트에 추가
            if ("게시글".equals(postType) && uniquePostIds.add(dto.getPost_id())) {
                filteredPostFeedCommentList.add(dto);
                // 현재 선택된 postType이 피드이고, Set(uniqueFeedIds)에 현재 피드 ID(dto.getFeed_id())를 추가했을 때 중복이 아니라면
                // 중복되지 않은 피드 데이터를 결과 리스트에 추가
            } else if ("피드".equals(postType) && uniqueFeedIds.add(dto.getFeed_id())) {
                filteredPostFeedCommentList.add(dto);
            }
        }

        model.addAttribute("postFeedList", filteredPostFeedCommentList); // 중복 제거된 리스트
        model.addAttribute("postFeedCommentList", postFeedCommentList);
        model.addAttribute("selectedSortOrder", sortOrder);
        model.addAttribute("selectedPostType", postType);

        return "setting/commentList";
    }

    @RequestMapping("/notification")
    public String notification(HttpSession session, Model model) {
        System.out.println("notification() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        // DB에 저장된 알림 상태 가져오기
        userNotificationDto = settingService.notificationSetting(session_user_id);

        model.addAttribute("allNotificationOff", userNotificationDto.getAll_notification_off());
        model.addAttribute("likeNotificationOn", userNotificationDto.getLike_notification_onoff());
        model.addAttribute("commentNotificationOn", userNotificationDto.getComment_notification_onoff());
        model.addAttribute("messageNotificationOn", userNotificationDto.getMessage_notification_onoff());

        return "setting/notification";
    }

    @PostMapping("/updateNotifications")
    @ResponseBody
    public String updateNotifications(@RequestParam("all_notification_off") int allNotificationOff, @RequestParam("like_notification_onoff") int likeNotificationOnoff, @RequestParam("comment_notification_onoff") int commentNotificationOnoff, @RequestParam("message_notification_onoff") int messageNotificationOnoff, HttpSession session) {
        System.out.println("updateNotifications() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        settingService.updateNotificationSetting(session_user_id, allNotificationOff, likeNotificationOnoff, commentNotificationOnoff, messageNotificationOnoff);

        return "success";
    }

    @PostMapping("/updateIndividualNotification")
    @ResponseBody
    public String updateIndividualNotification(@RequestParam("like_notification_onoff") Optional<Integer> likeNotificationOnOff, @RequestParam("comment_notification_onoff") Optional<Integer> commentNotificationOnOff, @RequestParam("message_notification_onoff") Optional<Integer> messageNotificationOnOff, HttpSession session) {
        // 각각의 매개변수를 Optional<Integer> 타입으로 전달
        System.out.println("updateIndividualNotification() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        // 각 알림 상태에 따라 DB 업데이트 처리
        if (likeNotificationOnOff.isPresent()) { // isPresent()를 사용해 값이 있는지 여부를 확인(값이 존재하면 true, 값이 없으면 false)
            settingService.updateLikeNotification(session_user_id, likeNotificationOnOff);
        }
        if (commentNotificationOnOff.isPresent()) {
            settingService.updateCommentNotification(session_user_id, commentNotificationOnOff);
        }
        if (messageNotificationOnOff.isPresent()) {
            settingService.updateMessageNotification(session_user_id, messageNotificationOnOff);
        }

        return "success";
    }

    @RequestMapping("/accessibility")
    public String accessibility(HttpSession session, Model model) {
        System.out.println("accessibility() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        // DB에서 다크모드 설정 값 가져오기
        userSettingDto = settingService.darkmode(session_user_id);

        model.addAttribute("darkmodeOn", userSettingDto.getDarkmode_setting_onoff());

        return "setting/accessibility";
    }

    @PostMapping("/updateDarkmode")
    @ResponseBody
    public String updateDarkmode(@RequestParam("darkmode_setting_onoff") int darkmodeOn, HttpSession session) {
        System.out.println("updateDarkmode() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        // DB에 다크모드 설정 값 업데이트
        settingService.updateDarkmode(session_user_id, darkmodeOn);

        return "success";
    }

    @RequestMapping("/startpageSetting")
    public String startpageSetting(HttpSession session, Model model) {
        System.out.println("startpageSetting() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        startpageDto = settingService.startpageSetting(session_user_id);

        model.addAttribute("music", startpageDto.getStartpage_music_setting());
        model.addAttribute("feed", startpageDto.getStartpage_feed_setting());
        model.addAttribute("community", startpageDto.getStartpage_community_setting());
        model.addAttribute("message", startpageDto.getStartpage_message_setting());

        return "setting/startpageSetting";
    }

    @PostMapping("/updateStartpageSetting")
    @ResponseBody
    public void updateStartpageSetting(@RequestBody Map<String, String> request, @SessionAttribute("user_id") String session_user_id) {
        System.out.println("updateStartpageSetting() ctr");

        String left = request.get("left"); // 클라이언트에서 보낸 json 데이터에서 left 키의 값을 가져오기
        String right = request.get("right"); // 클라이언트에서 보낸 json 데이터에서 right 키의 값을 가져오기

        settingService.updateStartpageSetting(session_user_id, left, right);
    }

    @RequestMapping("/pageAccessSetting")
    public String pageAccessSetting(HttpSession session, Model model) {
        System.out.println("pageAccessSetting() ctr");
        String session_user_id = (String) session.getAttribute("user_id");

        // DB에서 페이지 접근 설정 값 가져오기
        pageAccessDto = settingService.pageAccessSetting(session_user_id);

        model.addAttribute("mypage", pageAccessDto.getPage_access_mypage());
        model.addAttribute("notification", pageAccessDto.getPage_access_notification());
        model.addAttribute("setting", pageAccessDto.getPage_access_setting());
        model.addAttribute("music", pageAccessDto.getPage_access_music());
        model.addAttribute("message", pageAccessDto.getPage_access_message());

        return "setting/pageAccessSetting";
    }

    @PostMapping("/updatePageAccessSetting")
    @ResponseBody
    public void updatePageAccessSetting(@RequestParam("settingType") String settingType, @RequestParam("selectedValue") String selectedValue, @SessionAttribute("user_id") String session_user_id) {
        System.out.println("updatePageAccessSetting() ctr");

        settingService.updatePageAccessSetting(session_user_id, settingType, selectedValue);
    }

    @RequestMapping("/report")
    public String report(HttpSession session, Model model,
                         @RequestParam(value = "p", required = false) String post_id,
                         @RequestParam(value = "f", required = false) String feed_id,
                         @RequestParam(value = "fc", required = false) String feed_comments_id,
                         @RequestParam(value = "pc", required = false) String post_comments_id,
                         @RequestParam(value = "m", required = false) String message_id) {
        String now_id = (String) session.getAttribute("user_id");
        String report_tag = "";
        String userId = "";

        if (post_id != null) {
            report_tag = "게시글 신고";
            userId = reportDao.getPostUser(post_id);
            model.addAttribute("report_type_id", post_id);
        } else if (feed_id != null) {
            userId = reportDao.getFeedUser(feed_id);
            report_tag = "피드 신고";
            model.addAttribute("report_type_id", feed_id);
        } else if (feed_comments_id != null) {
            userId = reportDao.getFeedCommentsUser(feed_comments_id);
            report_tag = "피드 댓글 신고";
            model.addAttribute("report_type_id", feed_comments_id);
        } else if (post_comments_id != null) {
            userId = reportDao.getPostCommentsUser(post_comments_id);
            report_tag = "게시글 댓글 신고";
            model.addAttribute("report_type_id", post_comments_id);
        } else if (message_id != null) {
            userId = reportDao.getMessageUser(message_id);
            report_tag = "메시지 신고";
            model.addAttribute("report_type_id", message_id);
        }

        model.addAttribute("userId", userId);
        model.addAttribute("report_tag", report_tag);
        model.addAttribute("now_id", now_id);
        return "report/report";
    }

    @RequestMapping("/reportDo")
    public String reportDo(HttpSession session,
                           @RequestParam("now_id") String now_id,
                           @RequestParam("report_tag") String report_tag,
                           @RequestParam("report_type_id") String report_type_id,
                           @RequestParam("report_why") String report_why,
                           @RequestParam("userId") String userId) {

        String reportText = "";
        String reportImg = "";

        if (report_tag.equals("게시글 신고")) {
            ReportDto reportDto = reportDao.getReportPost(report_type_id);
            reportText = reportDto.getReport_text();
            reportDao.reportPost(report_type_id, now_id, report_why, report_tag, reportText, userId);
        } else if (report_tag.equals("피드 신고")) {
            ReportDto reportDto = reportDao.getReportFeed(report_type_id);
            reportText = reportDto.getReport_text();
            reportImg = reportDto.getReport_img_url();
            reportDao.reportFeed(report_type_id, now_id, report_why, report_tag, reportText, reportImg, userId);
        } else if (report_tag.equals("피드 댓글 신고")) {
            ReportDto reportDto = reportDao.getReportFeedComments(report_type_id);
            reportText = reportDto.getReport_text();
            reportDao.reportFeedComments(report_type_id, now_id, report_why, report_tag, reportText, userId);
        } else if (report_tag.equals("게시글 댓글 신고")) {
            ReportDto reportDto = reportDao.getReportPostComments(report_type_id);
            reportText = reportDto.getReport_text();
            reportDao.reportPostComments(report_type_id, now_id, report_why, report_tag, reportText, userId);
        } else if (report_tag.equals("메시지 신고")) {
            ReportDto reportDto = reportDao.getReportMessage(report_type_id);
            reportText = reportDto.getReport_text();
            reportDao.reportMessage(report_type_id, now_id, report_why, report_tag, reportText, userId);

        }

        return "redirect:/profileHome?u="+(String) session.getAttribute("user_id");
    }

    @RequestMapping("/deleteAccount")
    public String deleteAccount(HttpSession session) {
        System.out.println("deleteAccount ctr()");
        String session_user_id = (String) session.getAttribute("user_id");

        if (session_user_id == null) {
            // 세션에 user_id가 없으면 로그인 페이지로 리다이렉트
            return "redirect:/";
        }
        return "setting/deleteAccount";
    }

    @PostMapping("/deleteAccountMethod")
    @Transactional
    public String deleteAccountMethod(HttpSession session, @RequestParam("password") String password, Model model) {
        System.out.println("deleteAccountMethod ctr()");
        String sessionUserId = (String) session.getAttribute("user_id");

        // session에 아이디가 없을 경우
        if (sessionUserId == null) {
            model.addAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/login"; // login 페이지로 리다이렉트
        }

        // 암호화된 현재 비밀번호 가져오기
        String storedPassword = userDao.getPasswordByUsername(sessionUserId);

        // 입력한 비밀번호와 DB의 암호화된 비밀번호 비교
        if (!passwordEncoder.matches(password, storedPassword)) {
            // 비밀번호가 일치하지 않을 경우
            model.addAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            return "setting/deleteAccount";
        }

        try {
            // 탈퇴 전 팔로잉 관계 해제
            List<String> followingUsers = userDao.selectFollowingUsers(sessionUserId); // 탈퇴한 사용자를 팔로우 중인 사용자 목록 조회
            for (String userId : followingUsers) {
                userDao.doUnfollowing(userId, sessionUserId); // 각각의 팔로워에 대해 언팔로우 처리
            }
            // 모든 관련 테이블에서 user_id 변경 처리
            deleteUserAndUpdateReferences(sessionUserId); // 새로운 메서드로 ID 업데이트와 관련 데이터 정리 수행

            System.out.println("사용자 삭제 완료");
            session.invalidate();  // 세션 무효화

            model.addAttribute("successMessage", "회원 탈퇴가 완료되었습니다.");
            return "setting/deleteAccountResult";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMessage", "회원 탈퇴 중 오류가 발생했습니다.");
            return "setting/deleteAccount";
        }
    }

    @GetMapping("/deleteAccountResult")
    public String deleteAccountResult() {
        System.out.println("deleteAccountResult ctr()");

        return "setting/deleteAccountResult";
    }

    @Transactional
    public void deleteUserAndUpdateReferences(String userId) {
        String newUserId = "delete" + (int) (Math.random() * 100000);

        try {
            // 참조 테이블 데이터 임시 삭제
            userDao.deleteUserPageAccessSettingByUserId(userId);
            userDao.deleteUserNotiOnoffByUserId(userId);
            userDao.deleteUserStartpageSettingByUserId(userId);
            userDao.deleteUserSettingByUserId(userId);
            userDao.deleteUserProfileByUserId(userId);
            userDao.deleteUserFollowByUserId(userId);
            // userDao.deleteUserIdInMessageByUserId(userId);
            // userDao.deleteUserIdInMessageRoomUserByUserId(userId);
            mainDao.deleteFollowNotiUserId(userId);
            mainDao.deleteFollowNotiTargetId(userId);

            // user_info 테이블의 user_id 업데이트
            String updateNicknameSql = "UPDATE user_info SET user_nickname = '탈퇴한 사용자' WHERE user_id = ?"; // JDBC를 이용한 강제 SQL 실행
            String updateStatusSql = "UPDATE user_info SET user_status = 2 WHERE user_id = ?";
            String updateEmailSql = "UPDATE user_info SET USER_EMAIL = '' WHERE user_id = ?";
            // String disableFollowConstraintSql = "ALTER TABLE FOLLOW_NOTI DISABLE CONSTRAINT SYS_C007581";
            // String enableFollowConstraintSql = "ALTER TABLE FOLLOW_NOTI ENABLE CONSTRAINT SYS_C007581";
            String disableMessageConstraintSql = "ALTER TABLE MESSAGE DISABLE CONSTRAINT MESSAGE6_FR_KEY";
            String enableMessageConstraintSql = "ALTER TABLE MESSAGE ENABLE CONSTRAINT MESSAGE6_FR_KEY";

            // jdbcTemplate.execute(disableFollowConstraintSql);
            jdbcTemplate.execute(disableMessageConstraintSql);
            jdbcTemplate.update(updateNicknameSql, userId);
            jdbcTemplate.update(updateStatusSql, userId);
            jdbcTemplate.update(updateEmailSql, userId);

            userDao.changeUserInfoByUserId(userId, newUserId);

            // 참조 테이블에 새로운 user_id로 데이터 삽입
            userDao.insertUserNotiOnoffWithNewUserId(newUserId);
            userDao.insertUserPageAccessSettingWithNewUserId(newUserId);
            userDao.insertUserStartpageSettingWithNewUserId(newUserId);
            userDao.insertUserSettingByUserId(newUserId);
            userDao.insertUserProfileWithNewUserId(newUserId);
            userDao.insertUserFollowWithNewUserId(newUserId);
            // userDao.insertUserIdInMessageWithNewUserId(newUserId);
            // userDao.insertUserIdInMessageRoomUserWithNewUserId(newUserId);
            userDao.changeUserIdInMessage(userId, newUserId);
            userDao.changeUserIdInMessageRoomUser(userId, newUserId);

            // jdbcTemplate.execute(enableFollowConstraintSql);
            jdbcTemplate.execute(enableMessageConstraintSql);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
