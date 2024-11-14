<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>messageHome</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/message/messageHome.css" />
	<style>
		.container {
			padding: 20px 20px;
		}

		.scroll-content {
			flex: 1;
			overflow-y: auto;
		}

		.header {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 30px;
		}

		.left {
			display: flex;
			align-items: center;
		}

		.nowId {
			font-size: 25px;
			line-height: 30px;
		}

		#back img, #new-chat img {
			display: block;
			width: 30px;
			height: 30px;
			margin-right: 25px;
		}

		.room-list {
			display: flex;
			align-items: center;
			margin: 25px 0px;
			padding: 0px 20px 0 30px;
		}

		.user-nickname {
			font-weight: bold;
		}

		.room-list img {
			width: 50px;
			height: 50px;
			border-radius: 50%;
			margin-right: 10px;
		}

		.room-list a{
			display: flex;
			width: 100%;
			text-decoration: none;
			color: black;
		}

		.new-message {
			display: flex;
			font-weight: bold;
			line-height: 30px;
		}

		.before-message {
			display: flex;
			line-height: 30px;
		}

		.diff {
			font-weight: normal;
			display: flex;
			color: #999999;
		}

		a {
			text-decoration: none;
			color: black;
		}

		a:visited, a:hover, a:focus, a:active {
			color: black;
			text-decoration: none;
		}

		.chat {
			display: flex;
			flex-direction: column;
			width: 100%;
			position: relative;
		}

		.chatout {
			width: 30px;
			display: flex;
			align-items: center;
			justify-content: center;
		}

		.chatout img {
			width: 20px;
			height: 20px;
			cursor: pointer;
			align-items: center;
		}
		/* 모달 스타일 */
		.modal {
			display: none; /* 초기에는 숨김 */
			position: fixed;
			z-index: 1000;
			left: 0;
			top: 0;
			width: 100%;
			height: 100%;
			background-color: rgba(0, 0, 0, 0.5);
			justify-content: center;
			align-items: center;
		}

		.modal-content {
			background-color: #fff;
			border-radius: 8px;
			text-align: center;
			width: 80%;
			max-width: 200px;
			max-height: 20px;
		}

		.modal-content button {
			background-color: white;
			color: #FF4848;
			font-size: 16px;
			border: none;
			border-radius: 5px;
			cursor: pointer;
			margin: 0px;
		}
	</style>
</head>
<body>
<div class="container">
	<div class="header">
		<div></div>
		<div class="left">
			<div class="nowId">메시지</div>
		</div>
		<a href="${pageContext.request.contextPath}/message/newChat" id="new-chat">
			<img src="${pageContext.request.contextPath}/static/images/message/newchatIcon.png" id="newchat" alt="newchatIcon">
		</a>
	</div>

	<div class="scroll-content" id="chatList">
		<c:forEach var="list" items="${allChatList}">
			<div class="room-list" id="chat-${list.user_id}" data-unread-count="${list.unread_message_count}">
				<a href="${pageContext.request.contextPath}/messageGo?u=${list.user_id}" style="width: 100%; display: flex;">
					<img src="${list.user_image_url}" alt="user-img">
					<div class="chat">
						<div class="user-nickname">
							<span>${list.user_nickname}</span>
						</div>
						<c:choose>
							<c:when test="${list.last_message_sender_id == now_id}">
								<div class="before-message">
									<span>${list.last_message_text}</span>&nbsp;&nbsp;
									<div class="diff">${list.time_difference}</div>
								</div>
							</c:when>
							<c:otherwise>
								<c:if test="${list.unread_message_count > 0}">
									<div class="new-message">
										<span>새 메시지 ${list.unread_message_count}개</span>&nbsp;&nbsp;
										<div class="diff">${list.time_difference}</div>
									</div>
								</c:if>
								<c:if test="${list.unread_message_count == 0}">
									<div class="before-message">
										<span>${list.last_message_text}</span>&nbsp;&nbsp;
										<div class="diff">${list.time_difference}</div>
									</div>
								</c:if>
							</c:otherwise>
						</c:choose>
					</div>
				</a>
				<div class="chatout">
					<div href="javascript:void(0);" onclick="openModal('${list.message_room_id}')">
						<img src="${pageContext.request.contextPath}/static/images/message/out.png" alt="chatout">
					</div>
				</div>
			</div>
		</c:forEach>
	</div>
	<!-- 모달 -->
	<div class="modal" id="modal">
		<div class="modal-content">
			<button onclick="leaveChat()">채팅방 나가기</button>
		</div>
	</div>
</div>
<!-- Home WebSocket 클라이언트 -->
<script>
	const now_id = '${now_id}';

	// WebSocket 연결 설정
	const protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
	const socketUrl = protocol + "25.5.112.217:9002/whale/home?userId=" + now_id;
	const socket = new WebSocket(socketUrl);

	console.log(socketUrl);
	socket.onopen = function() {
		console.log("Home WebSocket 연결 성공");
	};

	socket.onmessage = function(event) {
		console.log("새 메시지 수신:", event.data);
		const homeMessage = JSON.parse(event.data);
		updateChatList(homeMessage);
	};

	socket.onclose = function(event) {
		console.log("Home WebSocket 연결 종료:", event);
	};

	socket.onerror = function(error) {
		console.error("Home WebSocket 오류:", error);
	};

	function updateChatList(homeMessage) {
		const senderId = homeMessage.senderId;
		const messageType = homeMessage.messageType;
		let messageText = homeMessage.messageText;
		const timeDifference = homeMessage.timeDifference;
		const userImageUrl = homeMessage.userImageUrl;
		const messageRoomId = homeMessage.messageRoomId;
		const senderNickname = homeMessage.senderNickname;

		const chatElement = document.getElementById('chat-' + senderId);
		console.log(messageType);
		console.log(chatElement);
		if (chatElement) {
			const unreadBefore = parseInt(chatElement.getAttribute('data-read-id')) || 0;
			let unreadCount = parseInt(chatElement.getAttribute('data-unread-count')) || 0;
			unreadCount += 1;
			chatElement.setAttribute('data-unread-count', unreadCount);

			if (messageType === 'IMAGE') {
				messageText = "이미지를 보냈습니다.";
			} else if (messageType === 'LINK') {
				messageText = "링크를 보냈습니다.";
			} else if (messageType === 'MUSIC') {
				messageText = "음악을 보냈습니다.";
			} else if (messageType === 'TEXT') {
				if (messageText.length > 40) {
					messageText = messageText.substring(0, 40) + "...";
				}
			} else {
				messageText = "알 수 없는 메시지 유형입니다.";
			}

			let newMessageHTML = '';
			const totalUnreadCount = unreadCount + unreadBefore;
			if (totalUnreadCount > 0) {
				newMessageHTML = `
                    <div class="new-message">
                        <span>새 메시지 \${totalUnreadCount}개</span>&nbsp;&nbsp;
                        <div class="diff">\${timeDifference}</div>
                    </div>
                `;
			} else {
				newMessageHTML = `
                    <div class="before-message">
                        <span>\${messageText}</span>&nbsp;&nbsp;
                        <div class="diff">\${timeDifference}</div>
                    </div>
                `;
			}

            const chatDivElement = chatElement.querySelector('.chat');

            // 기존 메시지 컨테이너 찾기 (.new-message 또는 .before-message)
            const existingMessage = chatDivElement.querySelector('.new-message') || chatDivElement.querySelector('.before-message');

            if (existingMessage) {
                // 메시지 컨테이너만 업데이트
                existingMessage.outerHTML = newMessageHTML;
            } else {
                // 메시지 컨테이너가 없으면 새로 추가
                chatDivElement.insertAdjacentHTML('beforeend', newMessageHTML);
            }

			const chatList = document.getElementById('chatList');
			const parentA = chatElement.parentElement;
			if (chatList.contains(parentA)) {
			    chatList.removeChild(parentA);
			    chatList.prepend(parentA);
			}
		} else {
			const chatList = document.getElementById('chatList');
			const newChatHTML = `
				<div class="room-list" id="chat-\${senderId}" data-unread-count="1">
                	<a href="${pageContext.request.contextPath}/messageGo?u=\${senderId}">
                        <img src="\${userImageUrl}" alt="user-img">
                        <div class="chat">
                            <div class="user-nickname">
                                <span>\${senderNickname}</span>
                            </div>
                            <div class="new-message">
                                <span>새 메시지 1개</span>&nbsp;&nbsp;
                                <div class="diff">\${timeDifference}</div>
                            </div>
                        </div>
                	</a>
					<div class="chatout">
						<div href="javascript:void(0);" onclick="openModal('\${messageRoomId}')">
							<img src="${pageContext.request.contextPath}/static/images/message/out.png" alt="chatout">
						</div>
					</div>
				</div>
            `;
			chatList.insertAdjacentHTML('afterbegin', newChatHTML);
		}
	}
	// 모달 열기
	function openModal(message_room_id) {
		currentMessageRoomId = message_room_id;
		document.getElementById("modal").style.display = "flex";
	}

	// 모달 닫기
	function closeModal() {
		document.getElementById("modal").style.display = "none";
	}

	// 모달 창 바깥 클릭 시 닫기
	window.onclick = function(event) {
		const modal = document.getElementById("modal");
		if (event.target === modal) {
			closeModal();
		}
	};

	// 채팅방 나가기
	function leaveChat() {
		if (currentMessageRoomId) {
			fetch(`${pageContext.request.contextPath}/message/deleteChatList?currentMessageRoomId=\${currentMessageRoomId}`, {
				method: 'GET',
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded'
				},
			})
	            .then(response => response.json())
	            .then(result => {
	                if (result.success === true) { // Controller가 "success" 반환 시
	                    console.log("채팅방 나가기 성공");
	                    closeModal();
	                    location.reload();
	                    
	                    // 채팅방 DOM 요소 찾기 및 제거
	                    const chatElementToRemove = document.querySelector(`div.room-list[data-message-room-id="\${currentMessageRoomId}"]`);
	                    if (chatElementToRemove) {
	                        const parentA = chatElementToRemove.closest('a');
	                        if (parentA) {
	                            parentA.remove();
	                            console.log(`채팅방 \${currentMessageRoomId}이(가) 목록에서 제거되었습니다.`);
	                        }
	                    }
	                } else {
	                    console.error("채팅방 나가기 실패");
	                }
	            })
	            .catch(error => console.error("Error:", error));
	    }
	}

</script>
</body>
</html>
