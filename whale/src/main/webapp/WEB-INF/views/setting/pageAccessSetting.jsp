<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>pageAccessSetting</title>
<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="static/js/setting/setting.js"></script>
<script src="static/js/setting/darkMode.js"></script>
<style>
	.setting-body[data-darkmode="0"] .setting-item { display: block; justify-content: space-between; border: none; border-radius: 0px; border-bottom: 1px solid #EAEAEA; }
	.section-top { font-weight: bold; }
	.radio-group { width: 100%; margin-top: 8px; }
	.radio-option { display: flex; align-items: center; justify-content: space-between; margin-bottom: 3px; }
	.radio-option label { margin-bottom: 3px; }
	input[type='radio'] { margin-left: auto; margin-right: 0; -webkit-appearance: none; -moz-appearance: none; appearance: none; width: 13px; height: 13px; border: 1px solid #ccc; border-radius: 50%; outline: none; cursor: pointer; }
	input[type='radio']:checked { background-color: #335580; border: 3px solid #ccc; box-shadow: 0 0 0 1.6px #335580; }
	#back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
	/* ---------------------------------------------------------------------------------------------------------------------------------------------------------------- */
	.setting-body[data-darkmode="1"] .setting-item { display: block; justify-content: space-between; border: none; border-radius: 0px; border-bottom: 1px solid #535353; }
</style>
</head>
<body>
<div class="setting-body">
	<div class="setting-container">
		<div class="setting-header">
		<a href="accessibility" id="back"><img src="static/images/setting/back.png" alt="back"></a>
		페이지 접근 변경
		</div>
		<form>
			<div class="setting-item">
				<div class="section">
					<label class="section-top">마이페이지</label>
					<div class="radio-group">
						<div class="radio-option">
							<label for="mypage-left">왼쪽</label>
								<input type="radio" id="mypage-left" name="mypage" value="left">
						</div>
						<div class="radio-option">
							<label for="mypage-right">오른쪽</label>
								<input type="radio" id="mypage-right" name="mypage" value="right" checked>
						</div>
					</div>
				</div>
			</div>
			<div class="setting-item">
				<div class="section">
					<label class="section-top">알림</label>
					<div class="radio-group">
						<div class="radio-option">
							<label for="notification-left">왼쪽</label>
								<input type="radio" id="notification-left" name="notification" value="left" checked>
						</div>
						<div class="radio-option">
							<label for="notification-right">오른쪽</label>
								<input type="radio" id="notification-right" name="notification" value="right">
						</div>
					</div>
				</div>
			</div>
			<div class="setting-item">
				<div class="section">
					<label class="section-top">설정</label>
					<div class="radio-group">
						<div class="radio-option">
							<label for="setting-left">왼쪽</label>
								<input type="radio" id="setting-left" name="setting" value="left">
						</div>
						<div class="radio-option">
							<label for="setting-right">오른쪽</label>
								<input type="radio" id="setting-right" name="setting" value="right" checked>
						</div>
					</div>
				</div>
			</div>
			<div class="setting-item">
				<div class="section">
					<label class="section-top">음악</label>
					<div class="radio-group">
						<div class="radio-option">
							<label for="music-left">왼쪽</label>
								<input type="radio" id="music-left" name="music" value="left">
						</div>
						<div class="radio-option">
							<label for="music-right">오른쪽</label>
								<input type="radio" id="music-right" name="music" value="right" checked>
						</div>
					</div>
				</div>
			</div>
			<div class="setting-item">
				<div class="section">
					<label class="section-top">메시지</label>
					<div class="radio-group">
						<div class="radio-option">
							<label for="message-left">왼쪽</label>
								<input type="radio" id="message-left" name="message" value="left">
						</div>
						<div class="radio-option">
							<label for="message-right">오른쪽</label>
								<input type="radio" id="message-right" name="message" value="right" checked>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>
<script>
	let mypage = ${mypage};
	let notification = ${notification};
	let setting = ${setting};
	let music = ${music};
	let message = ${message};

	window.onload = function() {
		// DB에서 불러온 값에 따라 라디오 버튼을 체크
		document.getElementById('mypage-left').checked = mypage == 0;
		document.getElementById('notification-left').checked = notification == 0;
		document.getElementById('setting-left').checked = setting == 0;
		document.getElementById('music-left').checked = music == 0;
		document.getElementById('message-left').checked = message == 0;

		document.getElementById('mypage-right').checked = mypage == 1;
		document.getElementById('notification-right').checked = notification == 1;
		document.getElementById('setting-right').checked = setting == 1;
		document.getElementById('music-right').checked = music == 1;
		document.getElementById('message-right').checked = message == 1;

		// 라디오 버튼 값 변경 시 설정 업데이트
		document.querySelector('.setting-container').addEventListener('change', function(event) {
			if(event.target.name === 'mypage' || event.target.name === 'notification' || event.target.name === 'setting' || event.target.name === 'music' || event.target.name === 'message') {
				const settingType = event.target.name; // 변경된 설정 항목 이름을 가져오기
				const selectedValue = event.target.value; // 선택된 값(left 또는 right)을 가져오기

				// 설정 업데이트 함수 호출
				updatePageAccessSetting(settingType, selectedValue);
			}
		});
	}

	// AJAX를 사용해 페이지 접근 설정을 서버에 업데이트하는 함수
	function updatePageAccessSetting(settingType, selectedValue) {
	    $.ajax({
	        url: '/whale/updatePageAccessSetting',
	        type: 'POST',
	        data: {
	            settingType: settingType, // 설정 항목 이름
	            selectedValue: selectedValue // 선택된 값
	        },
			// 요청이 성공했을 때 실행되는 콜백
	        success: function(response) {
	            console.log('응답: ', response.message);
	        },
			// 요청이 실패했을 때 실행되는 콜백
	        error: function(xhr, status, error) {
	            console.error('업데이트 실패: ', error);
	        }
	    });
	}
</script>
</body>
</html>