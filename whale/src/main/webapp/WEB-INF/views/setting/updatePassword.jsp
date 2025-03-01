<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updatePassword</title>
	<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
	<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<script src="static/js/setting/setting.js"></script>
	<script src="static/js/setting/darkMode.js"></script>
	<style>
		.setting-body[data-darkmode="0"] button { background-color: transparent; border: none; cursor: pointer; margin-left: 5px; color: #335580; }
		.setting-body[data-darkmode="0"] button:hover { color: black; }
		.setting-body[data-darkmode="0"] a { text-decoration: none; color: black; }
		.setting-body[data-darkmode="0"] a:visited, .setting-body[data-darkmode="0"] a:hover, .setting-body[data-darkmode="0"] a:focus, .setting-body[data-darkmode="0"] a:active { color: black; text-decoration: none; }
		.setting-body[data-darkmode="0"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
		.setting-body[data-darkmode="0"] .complete-btn { font-size: 20px; position: absolute; top: 15px; color: black; right: 7px; background-color: transparent; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; }
		.setting-body[data-darkmode="0"] .complete-btn:hover { color: #5A5A5A; }
		.setting-body[data-darkmode="0"] #password-fields { display: block; margin-top: 20px; justify-content: center; }
		.setting-body[data-darkmode="0"] .input-container { display: flex; flex-direction: column; min-height: 40px; margin: 20px auto 0 auto; width: fit-content; }
		.setting-body[data-darkmode="0"] .input-row { display: flex; align-items: center; }
		.setting-body[data-darkmode="0"] #password_hint, .setting-body[data-darkmode="0"] #password_match_hint { display: flex; margin-top: 3px; font-size: 10px; margin-left: 3px; }
		.setting-body[data-darkmode="0"] #pass-check { font-size: 10px; margin-top: 3px; margin-left: 5px; }
		.setting-body[data-darkmode="0"] input[type="password"] { padding: 5px; background-color: #FCFCFC; border: none; border-bottom: 2px solid #ccc; outline: none; }
		.setting-body[data-darkmode="0"] input[type="password"]:focus { border-bottom: 2px solid #7E7E7E; }
		.setting-body[data-darkmode="0"] .checkmark-icon { width: 17px; height: 17px; margin-left: 5px; }
		.setting-body[data-darkmode="0"] .checkmark-icon img { width: 100%; height: 100%; }
		/* ----------------------------------------------------------------------------------------------------------------------------------------------- */
		.setting-body[data-darkmode="1"] button { background-color: transparent; border: none; cursor: pointer; margin-left: 5px; color: whitesmoke; }
		.setting-body[data-darkmode="1"] button:hover { color: lightgray; }
		.setting-body[data-darkmode="1"] a { text-decoration: none; color: black; }
		.setting-body[data-darkmode="1"] a:visited, a:hover, a:focus, a:active { color: black; text-decoration: none; }
		.setting-body[data-darkmode="1"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
		.setting-body[data-darkmode="1"] .complete-btn { font-size: 20px; position: absolute; top: 15px; color: black; right: 7px; background-color: transparent; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; }
		.setting-body[data-darkmode="1"] .complete-btn:hover { color: lightgray; }
		.setting-body[data-darkmode="1"] #password-fields { display: block; margin-top: 20px; justify-content: center; }
		.setting-body[data-darkmode="1"] .input-container { display: flex; flex-direction: column; min-height: 40px; margin: 20px auto 0 auto; width: fit-content; }
		.setting-body[data-darkmode="1"] .input-row { display: flex; align-items: center; }
		.setting-body[data-darkmode="1"] #password_hint, .setting-body[data-darkmode="1"]  #password_match_hint { display: flex; margin-top: 3px; font-size: 10px; margin-left: 3px; }
		.setting-body[data-darkmode="1"] #pass-check { font-size: 10px; margin-top: 3px; margin-left: 5px; }
		.setting-body[data-darkmode="1"] input[type="password"] { padding: 5px; color: whitesmoke; background-color: rgb(46, 46, 46); border: none; border-bottom: 2px solid #ccc; outline: none; }
		.setting-body[data-darkmode="1"] input[type="password"]:focus { border-bottom: 2px solid #f1f1f1; }
		.setting-body[data-darkmode="1"] .checkmark-icon { width: 17px; height: 17px; margin-left: 5px; }
		.setting-body[data-darkmode="1"] .checkmark-icon img { width: 100%; height: 100%; }
	</style>
	<script>
		// 페이지가 완전히 로드된 후 실행되는 초기화 함수
		$(document).ready(function() {
			// 완료 버튼 숨기기
			$("#completeBtn").hide();
		});

		// 사용자가 입력한 현재 비밀번호 확인 함수
		function checkCurrentPassword(current_password) {
			// ajax 요청
			$.ajax({
				url: "/whale/checkCurrentPassword",
				type: "POST",
				data: { current_password: current_password }, // 사용자가 입력한 비밀번호를 data에 current_password로 담아서 보냄

				// 서버 응답을 성공적으로 받은 경우 실행될 콜백 함수
				success: function(response) {
					if (response.status === "valid") {
						// 현재 비밀번호 컨테이너 숨기기
						$("#current-password-container").hide();
						// 새로운 비밀번호 입력 필드와 확인 필드 표시
						$("#new-password-container").show();
						$("#confirm-password-container").show();
						// 새로운 비밀번호 입력 및 확인 필드에 유효성 검사 이벤트 바인딩
						$("#update_password, #check_password").on("input", validatePassword);
					} else {
						$("#pass-check").text("현재 비밀번호 불일치").css("color", "#FF6C6C");
						$("#current_password").val("");
					}
				},
				// 서버 요청 중 에러 발생 시 실행될 콜백 함수
				error: function(xhr, status, error) {
					console.error("오류: ", error);
				}
			});
		}

		// 비밀번호 유효성 검사 함수
		function validatePassword() {
			// 각 필드의 값 가져오기
			let currentPassword = $("#current_password").val(); // 현재 비밀번호
			let newPassword = $("#update_password").val(); // 새로운 비밀번호
			let checkPassword = $("#check_password").val(); // 비밀번호 확인
			// 비밀번호 정규식 : 8자리 이상, 대문자, 소문자, 숫자, 특수문자 포함 필수
			let passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;

			// 체크마크 및 힌트를 표시할 html 요소 가져오기
			let password_checkmark_1 = $("#password_checkmark_1"); // 새로운 비밀번호 체크마크
			let password_checkmark_2 = $("#password_checkmark_2"); // 비밀번호 확인 체크마크
			let passwordHint = $("#password_hint"); // 새로운 비밀번호 입력에 대한 힌트
			let password_match_hint = $("#password_match_hint"); // 비밀번호 확인에 대한 힌트

			// 필드 크기에 따라 힌트 크기를 조정하는 resize 함수
			function resize() {
				var inputWidth = $('#update_password').width(); // 새로운 비밀번호 필드의 너비
				var inputWidth2 = $('#check_password').width(); // 비밀번호 확인 필드의 너비
				$('#password_hint').css({'width': (inputWidth-5)+'px'}); // 힌트 너비를 입력 필드에 맞게 조정
				$('#password_match_hint').css({'width': (inputWidth2-5)+'px'}); // 힌트 너비를 입력 필드에 맞게 조정
			};

			// 새로운 비밀번호 유효성 검사
			if (newPassword.length === 0) {
				// 새로운 비밀번호 필드가 비어있는 경우
				passwordHint.html(""); // 힌트 비우기
				password_checkmark_1.html(""); // 체크마크 제거
			} else if (currentPassword === newPassword) {
				// 새로운 비밀번호가 현재 비밀번호와 동일한 경우
				passwordHint.text("현재 비밀번호 사용 불가능").css("color", "#FF6C6C"); // 힌트 표시
				password_checkmark_1.html(""); // 체크마크 제거
			} else if (!passwordRegex.test(newPassword)) {
				// 새로운 비밀번호가 정규식 조건을 만족하지 않는 경우
				passwordHint.text("특수문자, 대소문자, 숫자를 포함한 8자리 이상 입력하세요.").css("color", "#FF6C6C"); // 힌트 표시
				password_checkmark_1.html(""); // 체크마크 제거
				$(document).ready(() => {resize();}); // 입력 필드 크기에 맞게 힌트 크기 조정
			} else {
				// 새로운 비밀번호가 유효한 경우
				passwordHint.html(""); // 힌트 비우기
				password_checkmark_1.html('<img src="static/images/setting/passcheck.png" alt="일치">'); // 체크마크 추가
			}

			// 새로운 비밀번호 필드와 비밀번호 확인 필드의 값 일치 여부 검사
			if (newPassword.length === 0 || checkPassword.length === 0) {
				// 필드가 비어있으면
				password_match_hint.html(""); // 힌트 비우기
				password_checkmark_2.html(""); // 체크마크 제거
			} else if ((currentPassword === newPassword) && (newPassword === checkPassword)) {
				// 현재 비밀번호와 새로운 비밀번호가 같으면서 확인 비밀번호도 일치하는 경우
				password_match_hint.text("현재 비밀번호 사용 불가능").css("color", "#FF6C6C"); // 힌트 표시
				password_checkmark_2.html(""); // 체크마크 제거
			} else if (newPassword === checkPassword && passwordRegex.test(newPassword)) {
				// 새로운 비밀번호와 확인 비밀번호가 일치하고 정규식 조건을 만족하는 경우
				password_match_hint.html(""); // 힌트 비우기
				password_checkmark_2.html('<img src="static/images/setting/passcheck.png" alt="일치">'); // 체크마크 추가
				$("#completeBtn").show(); // 완료 버튼 표시
			} else {
				password_checkmark_2.html(""); // 체크마크 제거
				password_match_hint.text("불일치").css("color", "#FF6C6C"); // 힌트 표시
			}
		}

		// 비밀번호 변경 요청 처리하는 함수
		function updatePassword() {
			let newPassword = $("#update_password").val();

			// 서버에 새로운 비밀번호 전송
			$.ajax({
				url: "/whale/updateNewPassword",
				type: "POST",
				data: { new_password: newPassword }, // 새로운 비밀번호를 서버에 전달

				// 서버 응답이 성공적일 때 실행되는 콜백 함수
				success: function(response) {
					// JSON 응답 처리
					if (response.status === "success") {
						alert("비밀번호가 성공적으로 변경되었습니다.");
						window.location.href = "/whale/profileEdit"; // profileEdit 페이지로 리다이렉트
					} else {
						alert("비밀번호 변경에 실패했습니다.");
					}
				},
				// 서버 요청 중 오류 발생 시 실행되는 콜백 함수
				error: function(xhr, status, error) {
					console.error("오류: ", error);
					alert("비밀번호 변경 요청에 실패했습니다: " + xhr.responseText);
				}
			});
		}
	</script>
</head>
<body>
<div class="setting-body">
	<div class="setting-container">
		<div class="setting-header">
			<a href="profileEdit" id="back"><img src="static/images/setting/back.png" alt="back"></a>
			비밀번호 변경
			<button type="button" id="completeBtn" class="complete-btn" style="display: none;" onclick="updatePassword();">완료</button>
		</div>
		<div id="password-fields">
			<!-- 현재 비밀번호 컨테이너 -->
			<div id="current-password-container" class="input-container">
				<div class="input-row">
					<input type="password" id="current_password" name="current_password" placeholder="현재 비밀번호" />
					<button type="button" name="current_pass_checkbtn" onclick="checkCurrentPassword($('#current_password').val());">확인</button>
				</div>
				<span id="pass-check" class="hint-icon"> </span>
			</div>
			<!-- 새로운 비밀번호 컨테이너 (초기에 숨김 처리) -->
			<div id="new-password-container" class="input-container" style="display: none;">
				<div class="input-row">
					<input type="password" id="update_password" name="update_password" placeholder="변경할 비밀번호" />
					<span id="password_checkmark_1" class="checkmark-icon"></span>
				</div>
				<span id="password_hint" class="hint-icon"> </span>
			</div>
			<!-- 비밀번호 확인 컨테이너 (초기에 숨김 처리) -->
			<div id="confirm-password-container" class="input-container" style="display: none;">
				<div class="input-row">
					<input type="password" id="check_password" name="check_password" placeholder="변경할 비밀번호 확인" />
					<span id="password_checkmark_2" class="checkmark-icon"></span>
				</div>
				<span id="password_match_hint" class="hint-icon"> </span>
			</div>
		</div>
	</div>
</div>
</body>
</html>