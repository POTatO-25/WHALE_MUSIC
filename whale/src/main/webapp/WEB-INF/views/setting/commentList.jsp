<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>commentList</title>
	<link rel="stylesheet" href="static/css/setting/settingStyle.css" />
	<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<script src="static/js/setting/setting.js"></script>
	<script src="static/js/setting/darkMode.js"></script>
	<style>
		.setting-body[data-darkmode="0"] .setting-container { display: flex; flex-direction: column; overflow: hidden; }
		.setting-body[data-darkmode="0"] .scroll-content { flex: 1; overflow-y: auto; }
		.setting-body[data-darkmode="0"] .setting-item { display: inline-block; border-bottom: none; margin: 0px; border: none; }
		.setting-body[data-darkmode="0"] .dropdown { position: relative; display: inline-block; }
		.setting-body[data-darkmode="0"] .dropbtn { display: block; border: 2px solid #ccc; border-radius: 4px; background-color: #fcfcfc; font-weight: 400; color: rgb(124, 124, 124); padding: 12px; width: 100px; height: 45px; text-align: left; cursor: pointer; font-size: 12px; z-index: 1; position: relative; margin-right: 3px; }
		.setting-body[data-darkmode="0"] .dropdown-content { position: absolute; display: none; font-weight: 400; background-color: #fcfcfc; min-width: 100px; border-radius: 8px; height: 50px; box-shadow: 0px 0px 10px 3px rgba(190, 190, 190, 0.6); z-index: 20; }
		.setting-body[data-darkmode="0"] .dropdown-content div { display: block; text-decoration: none; color: rgb(37, 37, 37); font-size: 12px; padding: 12px 20px; }
		.setting-body[data-darkmode="0"] .dropdown-content div:hover { background-color: rgb(226, 226, 226); }
		.setting-body[data-darkmode="0"] .dropdown-content.show { display: block; }
		.setting-body[data-darkmode="0"] .post-list { display: block; margin-bottom: 10px; margin-left: 20px; margin-right: 20px; padding: 10px 10px; border: 1px solid #ccc; border-radius: 8px; }
		.setting-body[data-darkmode="0"] .no-comment-message { margin-left: 20px; color: #ccc; }
		.setting-body[data-darkmode="0"] a { text-decoration: none; color: black; }
		.setting-body[data-darkmode="0"] a:visited, .setting-body[data-darkmode="0"] a:hover, .setting-body[data-darkmode="0"] a:focus, .setting-body[data-darkmode="0"] a:active { color: black; text-decoration: none; }
		.setting-body[data-darkmode="0"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
		.setting-body[data-darkmode="0"] #feed-list, .setting-body[data-darkmode="0"] #post-list { margin-left: 20px; margin-right: 20px; }
		.setting-body[data-darkmode="0"] .feed-item { display: flex; align-items: center; margin-bottom: 10px; justify-content: space-between; padding: 10px; border: 1px solid #ddd; border-radius: 8px; }
		.setting-body[data-darkmode="0"] .post-item { display: flex; flex-direction: column; margin-bottom: 10px; justify-content: space-between; padding: 15px 10px; border: 1px solid #ddd; border-radius: 8px; }
		.setting-body[data-darkmode="0"] #feed-img { width: 100%; max-height: 50px; max-width: 50px; border-radius: 6px; margin-left: auto; }
		.setting-body[data-darkmode="0"] .comments-section { margin-top: 10px; padding-left: 10px; margin-bottom: 10px; }
		.setting-body[data-darkmode="0"] .comment, .setting-body[data-darkmode="0"] .reply { display: flex; align-items: center; margin-bottom: 5px; }
		.setting-body[data-darkmode="0"] .reply { margin-left: 40px; }
		.setting-body[data-darkmode="0"] .comment-img, .setting-body[data-darkmode="0"] .reply-img, .setting-body[data-darkmode="0"] .owner-image { width: 30px; height: 30px; border-radius: 50%; margin-right: 10px; }
		.setting-body[data-darkmode="0"] .comment-text, .reply-text { background-color: #f1f1f1; padding: 8px 12px; border-radius: 20px; }
		.post-list-writer { display: flex; justify-content: space-between; align-items: center; }
		.setting-body[data-darkmode="0"] .text-date-container { display: flex; justify-content: space-between; align-items: center; margin-top: 5px; }
		.setting-body[data-darkmode="0"] .text-date-container .date { color: #888; margin-left: auto; }
		/* --------------------------------------------------------------------------------------------------------------------------- */
		.setting-body[data-darkmode="1"] .setting-container { display: flex; flex-direction: column; overflow: hidden; }
		.setting-body[data-darkmode="1"] .scroll-content { flex: 1; overflow-y: auto; }
		.setting-body[data-darkmode="1"] .setting-item { display: inline-block; border-bottom: none; margin: 0px; border: none; }
		.setting-body[data-darkmode="1"] .dropdown { position: relative; display: inline-block; }
		.setting-body[data-darkmode="1"] .dropbtn { display: block; border: 2px solid #335580; border-radius: 4px; background-color: rgb(46, 46, 46); font-weight: 400; color: whitesmoke; padding: 12px; width: 100px; height: 45px; text-align: left; cursor: pointer; font-size: 12px; z-index: 1; position: relative; margin-right: 3px; }
		.setting-body[data-darkmode="1"] .dropdown-content { position: absolute; display: none; font-weight: 400; background-color: rgb(46, 46, 46); min-width: 100px; border-radius: 8px; height: 50px; box-shadow: 0px 0px 10px 3px #335580; z-index: 20; }
		.setting-body[data-darkmode="1"] .dropdown-content div { display: block; text-decoration: none; color: whitesmoke; font-size: 12px; padding: 12px 20px; }
		.setting-body[data-darkmode="1"] .dropdown-content div:hover { background-color: rgb(46, 46, 46); }
		.setting-body[data-darkmode="1"] .dropdown-content.show { display: block; }
		.setting-body[data-darkmode="1"] .post-list { display: block; margin-bottom: 10px; margin-left: 20px; margin-right: 20px; padding: 10px 10px; border: 1px solid #ccc; border-radius: 8px; }
		.setting-body[data-darkmode="1"] .no-comment-message { margin-left: 20px; color: #ccc; }
		.setting-body[data-darkmode="1"] a { text-decoration: none; color: black; }
		.setting-body[data-darkmode="1"] a:visited, .setting-body[data-darkmode="1"] a:hover, .setting-body[data-darkmode="1"] a:focus, .setting-body[data-darkmode="1"] a:active { color: black; text-decoration: none; }
		.setting-body[data-darkmode="1"] #back { position: absolute; left: 15px; top: 55%; transform: translateY(-50%); }
		.setting-body[data-darkmode="1"] #feed-list, .setting-body[data-darkmode="1"] #post-list { margin-left: 20px; margin-right: 20px; }
		.setting-body[data-darkmode="1"] .feed-item { display: flex; align-items: center; margin-bottom: 10px; justify-content: space-between; padding: 10px; color: whitesmoke; border: 1px solid #335580; border-radius: 8px; }
		.setting-body[data-darkmode="1"] .post-item { display: flex; flex-direction: column; margin-bottom: 10px; justify-content: space-between; padding: 15px 10px; color: whitesmoke; border: 1px solid #335580; border-radius: 8px; }
		.setting-body[data-darkmode="1"] #feed-img { width: 100%; max-height: 50px; max-width: 50px; border-radius: 6px; margin-left: auto; }
		.setting-body[data-darkmode="1"] .comments-section { margin-top: 10px; padding-left: 10px; margin-bottom: 10px; }
		.setting-body[data-darkmode="1"] .comment, .setting-body[data-darkmode="1"] .reply { display: flex; align-items: center; margin-bottom: 5px; }
		.setting-body[data-darkmode="1"] .reply { margin-left: 40px; }
		.setting-body[data-darkmode="1"] .comment-img, .setting-body[data-darkmode="1"] .reply-img, .setting-body[data-darkmode="1"] .owner-image { width: 30px; height: 30px; border-radius: 50%; margin-right: 10px; }
		.setting-body[data-darkmode="1"] .comment-text, .setting-body[data-darkmode="1"] .reply-text { background-color: #335580; color: whitesmoke; padding: 8px 12px; border-radius: 20px; }
		.setting-body[data-darkmode="1"] .post-list-writer { display: flex; justify-content: space-between; align-items: center; }
		.setting-body[data-darkmode="1"] .text-date-container { display: flex; justify-content: space-between; align-items: center; margin-top: 5px; }
		.setting-body[data-darkmode="1"] .text-date-container .date { color: #888; margin-left: auto; }
	</style>
	<style id="darkmode-scrollbar-styles"></style>
</head>
<body>
<div class="setting-body">
	<div class="setting-container">
		<div class="setting-header">
			<a href="activity" id="back"><img src="static/images/setting/back.png" alt="back"></a>
			댓글
		</div>
		<div class="scroll-content">
			<form id="filterForm" action="/whale/commentList" method="get">
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
			<!-- 댓글 목록 출력 -->
			<div id="comment-list">
				<c:choose>
					<c:when test="${empty postFeedList && empty postFeedCommentList}">
						<div class="no-comment-message">댓글 목록이 없습니다.</div>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${selectedPostType == '게시글'}">
								<c:forEach var="post" items="${postFeedList }">
									<a href="/whale/communityDetail?c=${post.community_id}&p=${post.post_id}">
										<div id="post-list">
											<div class="post-item">
												<div class="post-list-writer">
													<div>${post.post_tag_text}&nbsp;${post.post_title}</div>
													<div>${post.post_owner_id}</div>
												</div>
												<div class="text-date-container">
													<div class="date">${post.post_date}</div>
												</div>
											</div>
											<div class="comments-section">
												<c:forEach var="comment" items="${postFeedCommentList}">
													<c:if test="${post.post_id == comment.re_post_id}">
														<div class="${comment.re_post_parent_comments_id != null ? 'reply' : 'comment'}">
															<img src="${comment.re_post_commenter_image}" alt="commenter_img" class="comment-img">
															<div class="comment-text">
																<span>${comment.re_post_commenter_id}</span>: ${comment.re_post_comments_text}
															</div>
														</div>
													</c:if>
												</c:forEach>
											</div>
										</div>
									</a>
								</c:forEach>
							</c:when>
							<c:when test="${selectedPostType == '피드'}">
								<c:forEach var="feed" items="${postFeedList}">
									<a href="/whale/feedDetail?f=${feed.feed_id}">
										<div id="feed-list">
											<div class="feed-item">
												<img src="${feed.feed_owner_image}" alt="owner_image" class="owner-image">
												<div class="owner-id" style="font-weight: bold; margin-right: 4px; font-size: 19px;">${feed.feed_owner_id}</div> ${feed.feed_text}
												<c:if test="${feed.feed_img_url != null}">
													<img src="${feed.feed_img_url}" alt="feed_img" id="feed-img">
												</c:if>
											</div>
											<div class="comments-section">
												<c:forEach var="comment" items="${postFeedCommentList}">
													<c:if test="${feed.feed_id == comment.re_feed_id}">
														<div class="${comment.re_parent_comments_id != null ? 'reply' : 'comment'}">
															<img src="${comment.re_commenter_image}" alt="commenter_img" class="comment-img">
															<div class="comment-text">
																<span>${comment.re_commenter_id}</span>: ${comment.re_feed_comments_text}
															</div>
														</div>
													</c:if>
												</c:forEach>
											</div>
										</div>
									</a>
								</c:forEach>
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
		closeAllDropdowns();
		dropdownContent.classList.add('show'); // 드롭다운 열기

		// 현재 버튼의 텍스트 가져오기
		const currentValue = button.querySelector('.dropbtn_content').innerText;

		// 드롭다운 버튼의 현재 텍스트 값에 따라 표시해야 할 반대 옵션 정의(현재 드롭다운 버튼에 표시된 텍스트와 다른 값을 표시하기 위해 사용)
		const optionPairs = {
			'최신순': '오래된순',
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
		document.getElementById(field).value = value;

		// 선택한 값으로 드롭다운 버튼의 텍스트를 변경
		const dropbtn = element.closest('.dropdown').querySelector('.dropbtn_content');
		dropbtn.innerText = value; // 선택한 값으로 드롭다운 버튼의 텍스트 변경

		closeAllDropdowns(); // 모든 드롭다운 메뉴 닫기

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
