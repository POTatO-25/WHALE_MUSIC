<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>profileEdit</title>
    <link rel="stylesheet" href="static/css/setting/settingStyle.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script src="static/js/setting/setting.js"></script>
    <script src="static/js/setting/darkMode.js"></script>
    <style>
        .setting-body[data-darkmode="0"] #deleteAccountForm { display: flex; flex-direction: column; margin-top: 15px; justify-content: center; align-items: center; }
        .setting-body[data-darkmode="0"] input[type="password"] { width: 100%; padding: 5px; background-color: #FCFCFC; border: none; border-bottom: 2px solid #ccc; outline: none; }
        .setting-body[data-darkmode="0"] input[type="password"]:focus { border-bottom: 2px solid #7E7E7E; }
        .setting-body[data-darkmode="0"] .complete-btn { font-size: 20px; position: absolute; top: 15px; right: 7px; color: black; background-color: transparent; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; }
        .setting-body[data-darkmode="0"] .complete-btn:hover { color: #5A5A5A; }
        .setting-body[data-darkmode="0"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
        /* ---------------------------------------------------------------------------------------------------------------------------------------------------- */
        .setting-body[data-darkmode="1"] #deleteAccountForm { display: flex; flex-direction: column; margin-top: 15px; justify-content: center; align-items: center; }
        .setting-body[data-darkmode="1"] input[type="password"] { width: 100%; padding: 5px; color: whitesmoke; background-color: rgb(46, 46, 46); border: none; border-bottom: 2px solid #ccc; outline: none; }
        .setting-body[data-darkmode="1"] input[type="password"]:focus { border-bottom: 2px solid #f1f1f1; }
        .setting-body[data-darkmode="1"] .complete-btn { font-size: 20px; position: absolute; top: 15px; right: 7px; color: black; background-color: transparent; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; }
        .setting-body[data-darkmode="1"] .complete-btn:hover { color: lightgray; }
        .setting-body[data-darkmode="1"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
    </style>
</head>
<body>
<div class="setting-body">
    <div class="setting-container">
        <div class="setting-header">
            <a href="account" id="back"><img src="static/images/setting/back.png" alt="back"></a>
            회원 탈퇴
            <button type="button" id="completeBtn" style="display: none;" class="complete-btn">완료</button>
        </div>
        <form id="deleteAccountForm">
            <table>
                <tr>
                    <td>그동안 감사했습니다. 또 만나요!</td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script>
    $(document).ready(function () {
        // 페이지가 열린 후 2초 뒤 sendMessageToParent 함수 호출
        setTimeout(() => {
            // 부모 창에 탈퇴 성공 메시지를 보내는 함수
            function sendMessageToParent() {
                var message = {
                    type: "success",
                    text: "${successMessage}"
                };
                // 부모 창에 메시지 전송
                parent.postMessage(message, "*");
            }

            // 메시지 전송 후, 부모 창에서 처리하도록 호출
            sendMessageToParent();
        }, 2000);
    });
</script>
</body>
</html>