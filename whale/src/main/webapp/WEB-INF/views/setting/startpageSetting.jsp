<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>startpageSetting</title>
<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="static/js/setting/setting.js"></script>
<script src="static/js/setting/darkMode.js"></script>
<style>
   .setting-body[data-darkmode="0"] .setting-item { padding: 5px 10px; border-bottom: none; justify-content: space-between; border: none; border-radius: 0px; }
   .setting-body[data-darkmode="0"] .option { text-align: left; flex: 1; margin: 20px; }
   .setting-body[data-darkmode="0"] .option img { width: 300px; height: 300px; max-width: 100%; max-height: 300px; object-fit: contain; }
   .setting-body[data-darkmode="0"] .radio-group { display: flex; flex-direction: column; }
   .setting-body[data-darkmode="0"] .radio-group label { margin-bottom: 5px; }
   .setting-body[data-darkmode="0"] .leftright { margin-bottom: 5px; font-weight: bold; }
   .setting-body[data-darkmode="0"] input[type='radio'] { -webkit-appearance: none; -moz-appearance: none; appearance: none; width: 13px; height: 13px; border: 1px solid #ccc; border-radius: 50%; outline: none; cursor: pointer; margin-right: 7px; }
   .setting-body[data-darkmode="0"] input[type='radio']:checked { background-color: #335580; border: 3px solid #ccc; box-shadow: 0 0 0 1.6px #335580; }
   .setting-body[data-darkmode="0"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
   /* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
   .setting-body[data-darkmode="1"] .setting-item { padding: 5px 10px; border-bottom: none; justify-content: space-between; border: none; border-radius: 0px; }
   .setting-body[data-darkmode="1"] .option { text-align: left; flex: 1; margin: 20px; }
   .setting-body[data-darkmode="1"] .option img { width: 300px; height: 300px; max-width: 100%; max-height: 300px; object-fit: contain; }
   .setting-body[data-darkmode="1"] .radio-group { display: flex; flex-direction: column; }
   .setting-body[data-darkmode="1"] .radio-group label { margin-bottom: 5px; }
   .setting-body[data-darkmode="1"] .leftright { margin-bottom: 5px; font-weight: bold; }
   .setting-body[data-darkmode="1"] input[type='radio'] { -webkit-appearance: none; -moz-appearance: none; appearance: none; width: 13px; height: 13px; border: 1px solid #ccc; border-radius: 50%; outline: none; cursor: pointer; margin-right: 7px; }
   .setting-body[data-darkmode="1"] input[type='radio']:checked { background-color: #335580; border: 3px solid #ccc; box-shadow: 0 0 0 1.6px #335580; }
   .setting-body[data-darkmode="1"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
</style>
</head>
<body>
<div class="setting-body">
   <div class="setting-container">
      <div class="setting-header">
      <a href="accessibility" id="back"><img src="static/images/setting/back.png" alt="back"></a>
      시작페이지 설정
      </div>
         <div class="setting-item">
            <div class="option">
               <div class="leftright" >왼쪽</div>
               <img src="static/images/setting/startpage_${music == 1 ? 'music' : feed == 1 ? 'feed' : community == 1 ? 'community' : 'message'}.png" id="left-image" alt="left-image" />
               <div class="radio-group">
                  <label><input type="radio" id="left-music" name="left" value="music" onclick="changeImage('music', 'left');" />음악</label>
                  <label><input type="radio" id="left-feed" name="left" value="feed" onclick="changeImage('feed', 'left');" />피드</label>
                  <label><input type="radio" id="left-community" name="left" value="community" onclick="changeImage('community', 'left');" />커뮤니티</label>
                  <label><input type="radio" id="left-message" name="left" value="message" onclick="changeImage('message', 'left');" />메시지</label>
               </div>
            </div>
            <div class="option">
               <div class="leftright">오른쪽</div>
               <img src="static/images/setting/startpage_${music == 2 ? 'music' : feed == 2 ? 'feed' : community == 2 ? 'community' : 'message'}.png" id="right-image" alt="right-image" />
               <div class="radio-group">
                  <label><input type="radio" id="right-music" name="right" value="music" onclick="changeImage('music', 'right');" />음악</label>
                  <label><input type="radio" id="right-feed" name="right" value="feed" onclick="changeImage('feed', 'right');" />피드</label>
                  <label><input type="radio" id="right-community" name="right" value="community" onclick="changeImage('community', 'right');" />커뮤니티</label>
                  <label><input type="radio" id="right-message" name="right" value="message" onclick="changeImage('message', 'right');" />메시지</label>
               </div>
            </div>
         </div>
   </div>
</div>
<script>
   let music = ${music};
   let feed = ${feed};
   let community = ${community};
   let message = ${message};

   window.onload = function() {
       document.getElementById('left-music').checked = music == 1;
       document.getElementById('left-feed').checked = feed == 1;
       document.getElementById('left-community').checked = community == 1;
       document.getElementById('left-message').checked = message == 1;

       document.getElementById('right-music').checked = music == 2;
       document.getElementById('right-feed').checked = feed == 2;
       document.getElementById('right-community').checked = community == 2;
       document.getElementById('right-message').checked = message == 2;

       // 라디오 버튼 값 변경 시 설정 업데이트
       document.querySelector('.setting-container').addEventListener('change', function(event) {
           if (event.target.name === 'left' || event.target.name === 'right') {
               updateStartpageSetting();
           }
       });
   }

   // 이미지 변경 함수
   function changeImage(value, side) {
       const imageId = side === 'left' ? 'left-image' : 'right-image'; // 왼쪽 또는 오른쪽 이미지 ID 결정
       const imageElement = document.getElementById(imageId); // 이미지 요소 가져오기

      // 선택된 값에 따라 이미지 src 업데이트
       switch (value) {
           case 'music':
               imageElement.src = 'static/images/setting/startpage_music.png';
               break;
           case 'feed':
               imageElement.src = 'static/images/setting/startpage_feed.png';
               break;
           case 'community':
               imageElement.src = 'static/images/setting/startpage_community.png';
               break;
           case 'message':
               imageElement.src = 'static/images/setting/startpage_message.png';
               break;
       }
   }
   
   // 설정 업데이트 함수
   function updateStartpageSetting() {
      // 현재 체크된 왼쪽과 오른쪽 라디오 버튼의 값을 가져옴
       const leftValue = document.querySelector('input[name="left"]:checked').value;
       const rightValue = document.querySelector('input[name="right"]:checked').value;

       // ajax 요청
       $.ajax({
           url: '/whale/updateStartpageSetting', // 요청을 보낼 URL
           type: 'POST',
           data: JSON.stringify({ // 데이터를 JSON 형식으로 변환
               left: leftValue, // 왼쪽 설정값
               right: rightValue // 오른쪽 설정값
           }),
           contentType: 'application/json',
           // 요청 성공 시 실행
           success: function(response) {
               console.log('응답: ', response.message);
           },
           // 요청 실패 시 실행
           error: function(xhr, status, error) {
               console.log('업데이트 실패: ', error);
           }
       });
   }
</script>
</body>
</html>