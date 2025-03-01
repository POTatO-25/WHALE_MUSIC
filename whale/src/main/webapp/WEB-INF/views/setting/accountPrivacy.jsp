<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>accountPrivacy</title>
    <link rel="stylesheet" href="static/css/setting/settingStyle.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script src="static/js/setting/setting.js"></script>
    <script src="static/js/setting/darkMode.js"></script>
    <style>
        .setting-body[data-darkmode="0"] .setting-item { justify-content: space-between; }
        .setting-body[data-darkmode="0"] .setting-grid { grid-template-columns: repeat(2, 1fr); }
        .setting-body[data-darkmode="0"] #privite-toggle-slide { display: none; }
        .setting-body[data-darkmode="0"] label { width: 50px; height: 25px; background-color: #808080; text-indent: -9999px; border-radius: 25px; position: relative; cursor: pointer; transition: 0.5s; }
        .setting-body[data-darkmode="0"] label::after { content: ''; position: absolute; width: 17px; height: 17px; background-color: #e5e5e5; border-radius: 25px; top: 4px; left: 4px; transition: 0.5s; }
        .setting-body[data-darkmode="0"] #privite-toggle-slide:checked + label { background-color: #335580; }
        .setting-body[data-darkmode="0"] #privite-toggle-slide:checked + label::after { left: 29px; }
        .setting-body[data-darkmode="0"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
        /* ------------------------------------------------------------------------------------------------------------------------------------------------- */
        .setting-body[data-darkmode="1"] .setting-item { justify-content: space-between; color: whitesmoke; }
        .setting-body[data-darkmode="1"] .setting-grid { grid-template-columns: repeat(2, 1fr); }
        .setting-body[data-darkmode="1"] #privite-toggle-slide { display: none; }
        .setting-body[data-darkmode="1"] label { width: 50px; height: 25px; background-color: #808080; text-indent: -9999px; border-radius: 25px; position: relative; cursor: pointer; transition: 0.5s; }
        .setting-body[data-darkmode="1"] label::after { content: ''; position: absolute; width: 17px; height: 17px; background-color: #e5e5e5; border-radius: 25px; top: 4px; left: 4px; transition: 0.5s; }
        .setting-body[data-darkmode="1"] #privite-toggle-slide:checked + label { background-color: #335580; }
        .setting-body[data-darkmode="1"] #privite-toggle-slide:checked + label::after { left: 29px; }
        .setting-body[data-darkmode="1"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
    </style>
</head>
<body>
<div class="setting-body">
    <div class="setting-container">
        <div class="setting-header">
            <a href="account" id="back"><img src="static/images/setting/back.png" alt="back"></a>
            계정 공개범위
        </div>
        <div class="setting-grid">
            <div class="setting-item">
                <div class="privacy-txt">
                    <div class="setting-item-text">
                        <p>비공개 계정</p>
                        <p class="sub-text">private account</p>
                    </div>
                </div>
                <input type="checkbox" id="privite-toggle-slide"/>
                <label for="privite-toggle-slide">on/off</label>
            </div>
        </div>
    </div>
</div>
<script>
    var accountPrivacyOn = ${accountPrivacyOn}; // 서버에서 전달된 비공개 계정 여부 값

    window.onload = function () {
        // 비공개 계정이 1이면 토글 버튼을 선택된 상태로 표현
        document.getElementById('privite-toggle-slide').checked = accountPrivacyOn == 1;
    };

    // 토글 버튼 상태가 변경되었을 때 실행
    document.getElementById('privite-toggle-slide').addEventListener('change', function () {
        let accountPrivacy = this.checked ? 1 : 0; // 토글 상태에 따라 1 또는 0 설정

        // AJAX 요청
        const xhr = new XMLHttpRequest(); // 비동기 서버 요청을 처리하기 위해 객체 생성
        xhr.open('POST', '/whale/updatePrivacy', true); // 서버에 POST 요청을 보냄
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded'); // 전송할 데이터 형식 설정
        xhr.send('account_privacy=' + accountPrivacy); // 서버로 데이터 전송

        // 서버 응답 처리
        xhr.onreadystatechange = function () {
            if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
                if (accountPrivacy === 1) {
                    alert("비공개 계정 설정이 완료되었습니다.");
                } else {
                    alert("공개 계정 설징이 완료되었습니다.");
                }
                console.log('Privacy setting updated successfully');
            }
        };

        // 계정이 비공개에서 공개로 전환되는 경우 실행
        if (accountPrivacy === 0) {
            const followNotiXhr = new XMLHttpRequest();
            followNotiXhr.open('POST', '/whale/privateFollowNoti', true);
            followNotiXhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            followNotiXhr.send();

            followNotiXhr.onreadystatechange = function () {
                if (followNotiXhr.readyState == XMLHttpRequest.DONE) {
                    if (followNotiXhr.status == 200) {
                        console.log('Private follow notification sent successfully');
                    } else {
                        console.log('Failed to send private follow notification');
                    }
                }
            };
        }
    });
</script>
</body>
</html>
