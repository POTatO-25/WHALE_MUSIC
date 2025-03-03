<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>likeList</title>
    <link rel="stylesheet" href="static/css/setting/settingStyle.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script src="static/js/setting/setting.js"></script>
    <script src="static/js/setting/darkMode.js"></script>
    <style>
        .setting-container { display: flex; flex-direction: column; overflow: hidden; }
        .scroll-content { flex: 1; overflow-y: auto; }
        .like-list { margin-left: 20px; margin-right: 20px; }
        .dropdown { position: relative; display: inline-block; z-index: 10; }
        .image-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; padding: 5px 5px; }
        .image-item { position: relative; width: 100%; overflow: hidden; }
        .image-item::before { content: ""; display: block; padding-top: 100%; }
        .image-item img { position: absolute; top: 0; left: 0; border-radius: 3px; width: 100%; height: 100%; object-fit: cover; }
        .no-like-message { color: #ccc; }
        a { text-decoration: none; color: black; }
        a:visited, a:hover, a:focus, a:active { color: black; text-decoration: none; }
        #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
        .post-list-writer { display: flex; justify-content: space-between; align-items: center; }
        .setting-body[data-darkmode="0"] .setting-item { display: inline-block; border-bottom: none; margin: 0px; border: none; }
        .setting-body[data-darkmode="0"] .dropbtn { display: block; border: 2px solid #ccc; border-radius: 4px; background-color: #fcfcfc; font-weight: 400; color: rgb(124, 124, 124); padding: 12px; width: 100px; height: 45px; text-align: left; cursor: pointer; font-size: 12px; z-index: 1; position: relative; margin-right: 3px; }
        .setting-body[data-darkmode="0"] .dropdown-content { position: absolute; display: none; font-weight: 400; background-color: #fcfcfc; min-width: 100px; border-radius: 8px; height: 50px; box-shadow: 0px 0px 10px 3px rgba(190, 190, 190, 0.6); z-index: 20; }
        .setting-body[data-darkmode="0"] .dropdown-content div { display: block; text-decoration: none; color: rgb(37, 37, 37); font-size: 12px; padding: 12px 20px; }
        .setting-body[data-darkmode="0"] .dropdown-content div:hover { background-color: rgb(226, 226, 226); }
        .setting-body[data-darkmode="0"] .dropdown-content.show { display: block; }
        .setting-body[data-darkmode="0"] .post-list { display: block; align-items: center; margin-bottom: 10px; justify-content: space-between; padding: 10px; border: 1px solid #ddd; border-radius: 8px; }
        .setting-body[data-darkmode="0"] .cnt-date-container { display: flex; justify-content: space-between; align-items: center; margin-top: 5px; }
        .setting-body[data-darkmode="0"] .cnt-date-container .views, .total-like, .total-comment { display: flex; align-items: center; gap: 2px; margin-right: 7px; }
        .setting-body[data-darkmode="0"] .cnt-date-container .date { color: #888; margin-left: auto; }
        .setting-body[data-darkmode="0"] .cnt-date-container img { margin: 0; width: 19px; height: 19px; }
        .setting-body[data-darkmode="0"] .total-like img { filter: drop-shadow(0px 0px 0px #000); scale: 1.6; }
        .setting-body[data-darkmode="0"] .total-like .filter { filter: drop-shadow(0px 0px 0px #000); display: flex; }
        .setting-body[data-darkmode="0"] .total-comment img { filter: drop-shadow(0px 0px 0px #000); scale: 1.4; }
        .setting-body[data-darkmode="0"] .total-comment .filter { filter: drop-shadow(1px 0px 0px #000); display: flex; }
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        .setting-body[data-darkmode="1"] .setting-item { display: inline-block; border-bottom: none; margin: 0px; border: none; }
        .setting-body[data-darkmode="1"] .dropbtn { display: block; border: 2px solid #335580; border-radius: 4px; background-color: rgb(46, 46, 46); font-weight: 400; color: whitesmoke; padding: 12px; width: 100px; height: 45px; text-align: left; cursor: pointer; font-size: 12px; z-index: 1; position: relative; margin-right: 3px; }
        .setting-body[data-darkmode="1"] .dropdown-content { position: absolute; display: none; font-weight: 400; background-color: rgb(46, 46, 46); min-width: 100px; border-radius: 8px; height: 50px; box-shadow: 0px 0px 10px 3px #335580; z-index: 20; }
        .setting-body[data-darkmode="1"] .dropdown-content div { display: block; text-decoration: none; color: whitesmoke; font-size: 12px; padding: 12px 20px; }
        .setting-body[data-darkmode="1"] .dropdown-content div:hover { background-color: rgb(46, 46, 46); }
        .setting-body[data-darkmode="1"] .dropdown-content.show { display: block; }
        .setting-body[data-darkmode="1"] .post-list { display: block; align-items: center; margin-bottom: 10px; justify-content: space-between; padding: 10px; color: whitesmoke; border: 1px solid #335580; border-radius: 8px; }
        .setting-body[data-darkmode="1"] .cnt-date-container { display: flex; justify-content: space-between; align-items: center; margin-top: 5px; }
        .setting-body[data-darkmode="1"] .cnt-date-container .views, .total-like, .total-comment { display: flex; align-items: center; gap: 2px; margin-right: 7px; }
        .setting-body[data-darkmode="1"] .cnt-date-container .date { color: #888; margin-left: auto; }
        .setting-body[data-darkmode="1"] .cnt-date-container img { margin: 0; width: 19px; height: 19px; filter: invert(1); }
        .setting-body[data-darkmode="1"] .total-like img { filter: drop-shadow(1px 0px 0px #fff); scale: 1.6; }
        .setting-body[data-darkmode="1"] .total-like .filter { filter: drop-shadow(1px 0px 0px #fff); display: flex; }
        .setting-body[data-darkmode="1"] .total-comment img { filter: drop-shadow(1px 0px 0px #fff); scale: 1.4; }
        .setting-body[data-darkmode="1"] .total-comment .filter { filter: drop-shadow(1px 0px 0px #fff); display: flex; }
    </style>
    <style id="darkmode-scrollbar-styles"></style>
</head>
<body>
<div class="setting-body">
    <div class="setting-container">
        <div class="setting-header">
            <a href="activity" id="back"><img src="static/images/setting/back.png" alt="back"></a>
            좋아요
        </div>
        <div class="scroll-content">
            <form id="filterForm" action="/whale/likeList" method="get">
                <!-- 숨겨진 필드에 드롭다운 선택 값을 저장 -->
                <input type="hidden" name="sortOrder" id="sortOrder" value="${selectedSortOrder}">
                <input type="hidden" name="postType" id="postType" value="${selectedPostType}">

                <div class="setting-item">
                    <!-- 정렬 순서 드롭다운 -->
                    <div class="dropdown">
                        <button type="button" class="dropbtn" onclick="toggleDropdown(this)">
                            <span class="dropbtn_content">${selectedSortOrder}</span>
                        </button>
                        <div class="dropdown-content">
                            <div onclick="updateSelection('sortOrder', '최신순', this)">최신순</div>
                            <div onclick="updateSelection('sortOrder', '오래된순', this)">오래된순</div>
                        </div>
                    </div>

                    <!-- 게시물 유형 드롭다운 -->
                    <div class="dropdown">
                        <button type="button" class="dropbtn" onclick="toggleDropdown(this)">
                            <span class="dropbtn_content">${selectedPostType}</span>
                        </button>
                        <div class="dropdown-content">
                            <div onclick="updateSelection('postType', '게시글', this)">게시글</div>
                            <div onclick="updateSelection('postType', '피드', this)">피드</div>
                        </div>
                    </div>
                </div>
            </form>
            <!-- 좋아요 게시물 출력 -->
            <div class="like-list">
                <c:choose>
                    <c:when test="${empty postLikeList}">
                        <div class="no-like-message">좋아요 목록이 없습니다.</div>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${selectedPostType == '게시글'}">
                                <c:forEach var="post" items="${postLikeList }">
                                    <a href="/whale/communityDetail?c=${post.community_id}&p=${post.post_id}">
                                        <div class="post-list">
                                            <div class="post-list-writer">
                                                <div>${post.post_tag_text}&nbsp;${post.post_title}</div>
                                                <div>${post.user_id}</div>
                                            </div>
                                            <div class="cnt-date-container">
                                                <div class="views"><img src="static/images/setting/views.png" alt="views-img">${post.post_cnt}</div>
                                                <div class="total-like"><div class="filter"><img src="static/images/btn/like_btn.png" alt="like-btn"></div>${post.total_like_count}</div>
                                                <div class="total-comment"><div class="filter"><img src="static/images/btn/comment_btn.png" alt="comment-btn"></div>${post.total_comment_count}</div>
                                                <div class="date">${post.post_date}</div>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </c:when>
                            <c:when test="${selectedPostType == '피드'}">
                                <div class="image-grid">
                                    <c:forEach var="feed" items="${postLikeList }">
                                        <div class="image-item">
                                            <a href="/whale/feedDetail?f=${feed.feed_id}"><img id="feed-img" src="${feed.feed_img_url}" alt="feed_img"></a>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
<script>
    // 드롭다운 토글 함수
    function toggleDropdown(button) {
        const dropdownContent = button.nextElementSibling; // 버튼의 다음 형제요소(dropdown-content) 가져오기
        closeAllDropdowns(); // 다른 드롭다운 닫기
        dropdownContent.classList.add('show'); // 드롭다운 열기

        // 현재 버튼의 텍스트 가져오기
        const currentValue = button.querySelector('.dropbtn_content').innerText;

        // 드롭다운 버튼의 현재 텍스트 값에 따라 표시해야 할 반대 옵션 정의(현재 드롭다운 버튼에 표시된 텍스트와 다른 값을 표시하기 위해 사용)
        const optionPairs = {
            '최신순': '오래된순', // 최신순이 선택된 경우, 오래된순을 표시
            '오래된순': '최신순',
            '게시글': '피드',
            '피드': '게시글'
        };

        const options = dropdownContent.querySelectorAll('div'); // 드롭다운 메뉴 안의 모든 옵션 요소 가져오기
        options.forEach(option => {
            // 각 옵션의 텍스트가 반대 옵션과 일치하면 표시('block'), 그렇지 않으면 숨기기('none')
            option.style.display = option.innerText === optionPairs[currentValue] ? 'block' : 'none';
        });
    }

    // 선택한 값을 hidden 필드에 설정하고 드롭다운 닫기
    function updateSelection(field, value, element) {
        document.getElementById(field).value = value; // 선택한 값을 hidden 필드에 값으로 설정

        // 선택한 값으로 드롭다운 버튼의 텍스트를 변경
        const dropbtn = element.closest('.dropdown').querySelector('.dropbtn_content');
        dropbtn.innerText = value; // 선택한 값으로 드롭다운 버튼의 텍스트 변경

        // 모든 드롭다운 메뉴 닫기
        closeAllDropdowns();

        // 폼 제출
        document.getElementById('filterForm').submit();
    }

    // 모든 드롭다운 닫기
    function closeAllDropdowns() {
        document.querySelectorAll('.dropdown-content.show').forEach(function (dropdown) {
            dropdown.classList.remove('show'); // 'show' 클래스를 제거해서 드롭다운 메뉴 숨기기
        });
    }

    // 외부 클릭 시 드롭다운 닫기
    window.onclick = function (event) {
        if (!event.target.matches('.dropbtn')) { // 클릭된 요소가 드롭다운 버튼이 아니면
            closeAllDropdowns(); // 모든 드롭다운 메뉴 닫기
        }
    };

    // 스크롤바
    document.addEventListener("DOMContentLoaded", function () {
        // localStorage의 darkmodeOn 값 확인
        const darkmodeOn = localStorage.getItem("darkmodeOn");

        // darkmodeOn 값에 따라 스크롤바 스타일을 적용
        const styleSheet = document.getElementById("darkmode-scrollbar-styles");
        if (darkmodeOn === "1") {
            styleSheet.innerHTML = `
            .scroll-content::-webkit-scrollbar { display: block; width: 8px; }
            .scroll-content::-webkit-scrollbar-track { background: #2e2e2e; }
            .scroll-content::-webkit-scrollbar-thumb { background-color: #555; border-radius: 4px; }
            .scroll-content { overflow-y: auto; scroll-behavior: smooth; }
        `;
        } else {
            styleSheet.innerHTML = `
            .scroll-content::-webkit-scrollbar { display: block; width: 8px; }
            .scroll-content::-webkit-scrollbar-track { background: #fff; }
            .scroll-content::-webkit-scrollbar-thumb { background-color: #ccc; border-radius: 4px; }
            .scroll-content { overflow-y: auto; scroll-behavior: smooth; }
        `;
        }
    });
</script>
</body>
</html>