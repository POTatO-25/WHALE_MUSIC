<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>notification</title>
<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="static/js/setting/setting.js"></script>
<script src="static/js/setting/darkMode.js"></script>
<style>
	.setting-body[data-darkmode="0"] .setting-item { justify-content: space-between; border: none; border-bottom: 1px solid #eaeaea; border-radius: 0px; }
	.toggle-slide { display: none; }
	label { width: 50px; height: 25px; background-color: #808080; text-indent: -9999px; border-radius: 25px; position: relative; cursor: pointer; transition: 0.5s; }
	label::after { content: ''; position: absolute; width: 17px; height: 17px; background-color: #e5e5e5; border-radius: 25px; top: 4px; left: 4px; transition: 0.5s; }
	.toggle-slide:checked + label { background-color: #335580; }
	.toggle-slide:checked + label::after { left: 29px; }
	#back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
	/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
	.setting-body[data-darkmode="1"] .setting-item { justify-content: space-between; border: none; border-bottom: 1px solid #535353; border-radius: 0px; }
</style>
</head>
<body>
<div class="setting-body">
	<div class="setting-container">
	    <div class="setting-header">
	    <a href="settingHome" id="back"><img src="static/images/setting/back.png" alt="back"></a>
	    알림
	    </div>
	    <div class="setting-item">
	        모든 알림 해제
	        <input type="checkbox" id="toggle-allnotificationoff" class="toggle-slide" />
	        <label for="toggle-allnotificationoff"></label>
	    </div>
	    <div class="setting-item">
	        좋아요
	        <input type="checkbox" id="toggle-likeon" class="toggle-slide" />
	        <label for="toggle-likeon"></label>
	    </div>
	    <div class="setting-item">
	        댓글
	        <input type="checkbox" id="toggle-commenton" class="toggle-slide" />
	        <label for="toggle-commenton"></label>
	    </div>
	    <div class="setting-item">
	        메시지
	        <input type="checkbox" id="toggle-messageon" class="toggle-slide" />
	        <label for="toggle-messageon"></label>
	    </div>
	</div>
</div>
<script>
	// JSP에서 서버로부터 받은 알림 설정 값을 자바스크립트 변수로 전달
	let allNotificationOff= ${allNotificationOff};
	let likeNotificationOn = ${likeNotificationOn};
	let commentNotificationOn = ${commentNotificationOn};
	let messageNotificationOn = ${messageNotificationOn};

	// 페이지 로드 시, 서버에서 전달받은 값을 각 토글 스위치의 초기 상태 설정
	window.onload = function() {
		document.getElementById('toggle-allnotificationoff').checked = allNotificationOff == 1;
		document.getElementById('toggle-likeon').checked = likeNotificationOn == 1;
		document.getElementById('toggle-commenton').checked = commentNotificationOn == 1;
		document.getElementById('toggle-messageon').checked = messageNotificationOn == 1;
	};

	// 모든 알림 해제 토글 버튼에 변경 이벤트 리스너 추가
	document.getElementById('toggle-allnotificationoff').addEventListener('change', function() {
		// 현재 토글 상태 확인해서 값 설정
	    let allNotificationOff = this.checked ? 1 : 0;
	
	    // AJAX 요청
	    const xhr = new XMLHttpRequest(); // 서버에 요청을 보내기 위한 XMLHttpRequest 객체 생성
	    xhr.open('POST', '/whale/updateNotifications', true);
	    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	
	    // 서버로 데이터 전송
		if(allNotificationOff === 1) { // 모든 알림 해제 토글 버튼이 켜질 경우, 나머지 3개의 버튼의 값을 0으로 보내기
	    	xhr.send('all_notification_off=' + allNotificationOff + '&like_notification_onoff=0&comment_notification_onoff=0&message_notification_onoff=0');
		} else { // 모든 알림 해제 토글 버튼이 꺼질 경우, 나머지 3개의 버튼의 값을 1로 보내기
	    	xhr.send('all_notification_off=' + allNotificationOff + '&like_notification_onoff=1&comment_notification_onoff=1&message_notification_onoff=1');
		}

		// 서버 응답 상태 변경 시 호출되는 이벤트 핸들러 정의
	    xhr.onreadystatechange = function() {
			// 요청 완료 상태 확인
	        if (xhr.readyState === XMLHttpRequest.DONE) {
				// HTTP 응답 상태가 200일 때(성공)
	            if (xhr.status === 200) {
	                console.log('Notification settings updated in DB.');
	            } else {
	                console.error('Error updating notification settings. Status:', xhr.status, 'Response:', xhr.responseText);
	            }
	        }
	    };

		// 모든 알림 해제 토글 버튼이 켜진 경우
	    if (allNotificationOff) {
	        console.log('모든 알림 해제 ON');
	        
	        // 나머지 세 개의 알림을 OFF 상태로 설정
	        document.getElementById('toggle-likeon').checked = false;
	        document.getElementById('toggle-commenton').checked = false;
	        document.getElementById('toggle-messageon').checked = false;

	        // 나머지 세 개의 알림을 비활성화 상태로 설정
	        document.getElementById('toggle-likeon').disabled = true;
	        document.getElementById('toggle-commenton').disabled = true;
	        document.getElementById('toggle-messageon').disabled = true;
	    } else {
	        console.log('모든 알림 해제 OFF');

	        // 나머지 세 개의 알림을 ON 상태로 설정
			document.getElementById('toggle-likeon').checked = true;
			document.getElementById('toggle-commenton').checked = true;
			document.getElementById('toggle-messageon').checked = true;

	        // 나머지 세 개의 알림을 활성화 상태로 설정
	        document.getElementById('toggle-likeon').disabled = false;
	        document.getElementById('toggle-commenton').disabled = false;
	        document.getElementById('toggle-messageon').disabled = false;
	    }
	});

	// 좋아요 알림 토글버튼 change 이벤트 리스너
	document.getElementById('toggle-likeon').addEventListener('change', function() {
		// 좋아요 알림의 상태 전달(체크 여부에 따라 true/false)
		updateIndividualNotification('like_notification_onoff', this.checked);
	});
	// 댓글 알림 토글버튼 변경 change 리스너
	document.getElementById('toggle-commenton').addEventListener('change', function() {
		// 댓글 알림의 상태 전달(체크 여부에 따라 true/false)
		updateIndividualNotification('comment_notification_onoff', this.checked);
	});
	// 메시지 알림 토글버튼 변경 change 리스너
	document.getElementById('toggle-messageon').addEventListener('change', function() {
		// 메시지 알림의 상태 전달(체크 여부에 따라 true/false)
		updateIndividualNotification('message_notification_onoff', this.checked);
	});

	// 알림 개별 설정 업데이트 함수
	function updateIndividualNotification(notificationType, isOn) {
		const xhr = new XMLHttpRequest();
		xhr.open('POST', '/whale/updateIndividualNotification', true);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(notificationType + "=" + (isOn ? 1 : 0));

		// 요청 상태 변경 시 호출되는 이벤트 핸들러
		xhr.onreadystatechange = function() {
			// 요청이 완료되었는지 확인
			if(xhr.readyState === XMLHttpRequest.DONE) {
				// 응답 상태가 200일 경우 성공 메시지를 로그에 출력
				if(xhr.status === 200) {
					console.log(notificationType + ' setting updated in DB.');
				} else {
					console.error('Error updating ' + notificationType + ' setting. Status:', xhr.status, 'Response:', xhr.responseText);
				}
			}
		};
	}
</script>
</body>
</html>
