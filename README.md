# Whale music - 음악 스트리밍 서비스 프로젝트

Spotify Api를 사용하여 다양한 음악을 스트리밍하고, 음악과 관련된 내용을 나눌 수 있는 커뮤니티 플랫폼입니다. 로그인/회원가입, 음악 스트리밍, 피드/커뮤니티, 메세지/프로필, 환경설정, 관리자 등의 기능을 갖추고 두개의 탭을 양쪽에 배치하여 음악 스트리밍 서비스를 즐기면서도 메시지, 커뮤니티, 피드 등의 기능을 이용함에 어떠한 제약이 없도록 설계했습니다. 백엔드는 Java와 Spring, Node.js를 사용하고, 프론트엔드는 Vue.js와 Jsp를 활용하였습니다. 데이터는 Spotify Api를 통해 수집하거나 Oracle에 저장하여 사용합니다.

[프로젝트 목표]
* Spotify API 사용: 외부 데이터를 활용, 가공하는 방법을 배우고 익힘
* 커뮤니티 사이트 구축: 음악 게시판, 피드, 메세지 기능 등을 추가하여 음악 커뮤니티 기능을 만들고자 함

[프로젝트 개요]
* 기간: 2024.09.02 ~ 2024.11.20
* 팀원: 백엔드 5명
* 사용기술: Java, Spring, Oracle, MyBatis, Jsp, JavaScript
* 담당: 환경설정(프로필 편집, 비밀번호 변경, 숨긴 피드, 좋아요 목록(게시글, 피드), 댓글 목록(게시글, 피드), 계정 공개범위, 알림, 시작페이지 설정, 다크모드)

## 담당 기능
### 1. 프로필 편집
- 프로필 이미지, 닉네임, 비밀번호, 대표곡, 이메일 등을 변경할 수 있는 페이지
![프로필편집](https://github.com/user-attachments/assets/90847ac0-afc9-4470-90ea-f8aa0ef61c3d)

### 2. 비밀번호 변경
- 비밀번호를 변경할 수 있는 페이지
![비밀번호변경1](https://github.com/user-attachments/assets/d7dbddd5-e24a-468e-8bed-ce82e0319cf1)
비밀번호를 변경하기 위해서는 현재 비밀번호를 입력한 후, 입력한 비밀번호가 DB에 저장된 비밀번호와 일치할 경우 새로운 비밀번호 입력 필드 표시

### 3. 숨긴 피드
- 사용자가 숨긴 피드를 확인할 수 있는 페이지
![숨긴피드](https://github.com/user-attachments/assets/1b4c2e5b-c106-40fa-be69-b44374aa7889)

### 4. 좋아요 목록
- 사용자가 숨긴 피드를 확인할 수 있는 페이지
![좋아요목록](https://github.com/user-attachments/assets/61a003f4-c291-4af0-8e87-6a15d0bcb600)
![좋아요목록피드](https://github.com/user-attachments/assets/b5828fe4-6e1c-4e95-a736-274b24f9814b)

### 5. 계정 공개범위
- 계정의 공개범위를 변경할 수 있는 페이지
![계정공개범위](https://github.com/user-attachments/assets/a5009617-5599-45bb-b246-efe68bf0415b)

### 6. 댓글 목록
- 사용자가 게시물, 피드에 작성한 댓글을 확인할 수 있는 페이지
![댓글목록](https://github.com/user-attachments/assets/ee607112-20f8-4a21-bf4f-33b7286bab04)

### 7. 알림 / 시작페이지 설정
- 알림 상태와 WHALE의 시작 페이지를 사용자가 원하는대로 설정할 수 있는 페이지
![알림설정및시작페이지설정](https://github.com/user-attachments/assets/acce5a03-44fe-468a-b892-819b7c238390)

### 8. 다크모드
- 다크모드를 설정할 수 있는 페이지
![다크모드](https://github.com/user-attachments/assets/f929bc2a-86f1-48a2-8295-4e9fbc003371)
