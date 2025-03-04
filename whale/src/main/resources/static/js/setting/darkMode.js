document.addEventListener("DOMContentLoaded", function () {
    // 다크 모드 처리가 필요한 요소들을 객체로 정의하여 배열에 담음
    const elements = [
        {
            element: document.querySelector('.setting-body'), // settingElement
            extraInit: null,
            extraMessageHandler: null
        },
        {
            element: document.querySelector('.feed-container'), // feedElement
            extraInit: null,
            extraMessageHandler: null
        },
        {
            element: document.querySelector('.container'), // communityElement
            extraInit: null,
            extraMessageHandler: function(darkmodeOn, element) {
                // initializeEmojiPicker 함수가 정의되어 있는지 확인 후 호출
                if (typeof initializeEmojiPicker === 'function') {
                    initializeEmojiPicker(); // 이모지 선택기 재초기화(messageRoom)
                }
            }
        },
        {
            element: document.querySelector('.content-wrapper'), // communityPostElement
            extraInit: null,
            extraMessageHandler: null
        },
        {
            element: document.querySelector('.modal'), // communityPostModalElement
            extraInit: null,
            extraMessageHandler: null
        },
        {
            element: document.querySelector('.container'), // communityReg
            extraInit: null,
            extraMessageHandler: null
        },
        {
            element: document.querySelector('.streamingBody'), // streamingElement
            extraInit: function(darkmodeOn, isDarkMode, element) {
                const bodyClass = document.body.classList.contains("dark") ? "dark" : "light";
                if (page !== 'home') {
                    if (bodyClass === "dark") {
                        console.log("Dark theme is active");

                        const updateBackground = () => {
                            const mainContent = document.querySelector('.mainContent');
                            if (mainContent) {
                                function getRandomColor() {
                                    const r = Math.floor(Math.random() * 256);
                                    const g = Math.floor(Math.random() * 256);
                                    const b = Math.floor(Math.random() * 256);
                                    console.log("Generated RGB values:", r, g, b);
                                    return `rgb(${r}, ${g}, ${b})`;
                                }

                                const randomColor = getRandomColor();
                                console.log("Random color:", randomColor);
                                mainContent.style.backgroundImage = `linear-gradient(${randomColor} 0%, rgb(17, 18, 17) 100%)`;
                                console.log("Background image:", mainContent.style.backgroundImage);
                            } else {
                                console.error('mainContent 요소를 찾을 수 없습니다.');
                            }
                        };
                        updateBackground(); // dark 모드일 때 배경 업데이트
                    } else if (bodyClass === "light") {
                        console.log("Light theme is active");

                        const updateBackground = () => {
                            const mainContent = document.querySelector('.mainContent');
                            if (mainContent) {
                                function getRandomColor() {
                                    const r = Math.floor(Math.random() * 256);
                                    const g = Math.floor(Math.random() * 256);
                                    const b = Math.floor(Math.random() * 256);
                                    console.log("Generated RGB values:", r, g, b);
                                    return `rgb(${r}, ${g}, ${b})`;
                                }

                                const randomColor = getRandomColor();
                                console.log("Random color:", randomColor);
                                mainContent.style.backgroundImage = `linear-gradient(${randomColor} 0%, rgb(249, 250, 249) 100%)`;
                                console.log("Background image:", mainContent.style.backgroundImage);
                            } else {
                                console.error('mainContent 요소를 찾을 수 없습니다.');
                            }
                        };
                        updateBackground(); // light 모드일 때 배경 업데이트
                    }
                }
            },
            extraMessageHandler: null
        },
        {
            element: document.querySelector('.searchHomeBody'), // searchElement
            extraInit: null,
            extraMessageHandler: null
        },
        {
            element: document.querySelector('#messageMenuModal'), // messageElement
            extraInit: null,
            extraMessageHandler: null
        }
    ];

    let darkmodeOn = localStorage.getItem('darkmodeOn') || "0";

    // 다크모드 설정에 따른 스크롤바 스타일 업데이트 함수
    const updateScrollbarStyle = () => {
        const styleSheet = document.getElementById("darkmode-scrollbar-styles");
        if (styleSheet) {
            if (darkmodeOn === "1") {
                styleSheet.innerHTML = `
                    html::-webkit-scrollbar {display: block; width: 8px;}
                    html::-webkit-scrollbar-track {background: #2e2e2e;}
                    html::-webkit-scrollbar-thumb {background-color: #555; border-radius: 4px;}
                    html {width: 100%; height: 190px; overflow-y: auto; scroll-behavior: smooth; display: flex; flex-direction: column;}
                `;
            } else {
                styleSheet.innerHTML = `
                    html::-webkit-scrollbar {display: block; width: 8px;}
                    html::-webkit-scrollbar-track {background: #fff;}
                    html::-webkit-scrollbar-thumb {background-color: #ccc; border-radius: 4px;}
                    html {width: 100%; height: 190px; overflow-y: auto; scroll-behavior: smooth; display: flex; flex-direction: column;}
                `;
            }
        }
    };

    // 요소에 대한 초기 설정 함수
    const initialize = (elementObj) => {
        const element = elementObj.element;
        if (element) {
            element.setAttribute("data-darkmode", darkmodeOn); // data-darkmode 속성 설정
            const isDarkMode = darkmodeOn === "1";
            element.classList.toggle("dark", isDarkMode); // 다크 모드가 활성화되어 있으면 "dark" 클래스를 추가
            element.classList.toggle("light", !isDarkMode); // 다크 모드가 비활성화되어 있으면 "light" 클래스를 추가

            if (elementObj.extraInit) {
                elementObj.extraInit(darkmodeOn, isDarkMode, element);
            }
        }
    };

    // elements 배열의 각 요소에 대해 initialize 함수 적용
    elements.forEach(initialize);

    // 다른 창이나 탭에서 localStorage의 darkmodeOn 키에 변경 사항이 발생하면 다크 모드 상태를 동기화
    window.addEventListener('storage', function (event) {
        if (event.key === 'darkmodeOn') { // 변경된 키가 darkmodeOn인지 확인
            darkmodeOn = event.newValue || "0"; // darkmodeOn 변수 업데이트

            // 요소에 변경사항 적용
            elements.forEach(function(elementObj) {
                const element = elementObj.element;
                if (element) {
                    element.setAttribute("data-darkmode", darkmodeOn); // 'data-darkmode' 속성에 현재 다크 모드 상태를 설정
                    const isDark = darkmodeOn === "1";
                    element.classList.toggle("dark", isDark); // 다크 모드 활성화 여부에 따라 'dark' 클래스를 추가하거나 제거
                    element.classList.toggle("light", !isDark);
                    if (elementObj.extraMessageHandler) {
                        elementObj.extraMessageHandler(darkmodeOn, element);
                    }
                }
            });
            updateScrollbarStyle(); // 스크롤바 스타일 업데이트
        }
    });

    // 초기 페이지 로드 시 스크롤바 스타일 적용
    updateScrollbarStyle();
});
