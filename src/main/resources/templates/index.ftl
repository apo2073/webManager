<html>
<head>
    <title>WebManager</title>
    <style>
        body {
            font-family: Arial, sans-serif, Jua;
            margin: 0;
            padding: 0;
        }
        .header {
            width: 100%;
            height: 50px;
            background-color: #f0f0f0;
            text-align: center;
            line-height: 50px;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        .nav-item {
            cursor: pointer;
            padding: 0 15px;
            transition: background-color 0.3s;
            border-radius: 5px;
        }
        .nav-item:hover {
            background-color: #e0e0e0;
        }
        .nav-item.active {
            background-color: #d0d0d0;
        }
        .container {
            display: flex;
            margin: 20px;
            gap: 30px;
        }
        .left-pane {
            width: 60%;
            margin-top: 30px;
        }
        .right-pane {
            width: 40%;
            margin-left: 20px;
            margin-top: 30px;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
        .log {
            width: 100%;
            height: 450px;
            border: 1px solid #ccc;
            background-color: #fafafa;
            border-radius: 15px;
            padding: 10px;
            font-family: monospace;
            font-size: 14px;
            white-space: pre-wrap;
            overflow-y: auto;
            display: block;
        }
        .info {
            margin-bottom: 20px;
        }
        .header-info {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        .reload-btn {
            background: none;
            border: 1px solid #ccc;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            cursor: pointer;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 2px;
        }
        .reload-btn:hover {
            background-color: #f0f0f0;
        }
        .command-btn {
            background: none;
            border: 1px solid #ccc;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            cursor: pointer;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 10px;
        }
        .command-btn:hover {
            background-color: #f0f0f0;
        }
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }
        .modal-overlay.active {
            display: block;
        }
        .command-modal {
            display: none;
            position: fixed;
            top: 70%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 80%;
            max-width: 800px;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            padding: 20px;
            z-index: 1100;
        }
        .command-modal.active {
            display: block;
        }
        .command-input {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            font-family: monospace;
        }
        .suggestions {
            position: absolute;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            max-height: 150px;
            overflow-y: auto;
            width: 80%;
            max-width: 800px;
            z-index: 1200;
            display: none;
        }
        .suggestions div {
            padding: 5px 10px;
            cursor: pointer;
        }
        .suggestions div:hover {
            background-color: #f0f0f0;
        }
    </style>
</head>
<body>
<script>
    function openTab(tabName) {
        window.location.href = tabName;
    }

    window.onload = function() {
        document.getElementById('serverInfo').classList.add('active');
        document.querySelector('.nav-item[data-tab="serverInfo"]').classList.add('active');
        fetchServerLogs();
    };

    function openCommandModal() {
        document.querySelector('.modal-overlay').classList.add('active');
        document.querySelector('.command-modal').classList.add('active');
        const input = document.querySelector('.command-input');
        input.value = '';
        input.focus();
    }

    function closeCommandModal() {
        document.querySelector('.modal-overlay').classList.remove('active');
        document.querySelector('.command-modal').classList.remove('active');
        document.querySelector('.suggestions').style.display = 'none';
    }

    async function fetchTabCompletions(input) {
        try {
            const response = await fetch('/tabComp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: 'input=' + encodeURIComponent(input)
            });
            const suggestions = await response.json();
            showSuggestions(suggestions);
        } catch (e) {
            showSuggestions([]);
        }
    }

    function showSuggestions(suggestions) {
        const suggestionBox = document.querySelector('.suggestions');
        suggestionBox.innerHTML = '';
        if (suggestions.length > 0) {
            suggestions.forEach(suggestion => {
                const div = document.createElement('div');
                div.textContent = suggestion;
                div.onclick = () => {
                    document.querySelector('.command-input').value = suggestion;
                    suggestionBox.style.display = 'none';
                };
                suggestionBox.appendChild(div);
            });
            suggestionBox.style.display = 'block';
        } else {
            suggestionBox.style.display = 'none';
        }
    }

    async function fetchServerLogs() {
        try {
            const response = await fetch('/logs');
            if (!response.ok) return;
            const logBox = document.getElementById('serverLogs');
            logBox.innerHTML = await response.text();
            logBox.parentElement.scrollTop = logBox.parentElement.scrollHeight;
        } catch (e) {
            console.error('로그 가져오기 실패:', e);
        }
    }
    setInterval(fetchServerLogs, 1000);

    document.addEventListener('DOMContentLoaded', () => {
        const input = document.querySelector('.command-input');
        const suggestionBox = document.querySelector('.suggestions');

        document.querySelector('.command-btn').addEventListener('click', openCommandModal);
        document.querySelector('.modal-overlay').addEventListener('click', closeCommandModal);

        input.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                closeCommandModal();
            } else if (e.key === 'Tab') {
                e.preventDefault();
                fetchTabCompletions(input.value);
            }
        });

        input.addEventListener('input', () => {
            fetchTabCompletions(input.value);
        });

        document.addEventListener('click', (e) => {
            if (!input.contains(e.target) && !suggestionBox.contains(e.target)) {
                suggestionBox.style.display = 'none';
            }
        });
    });
</script>

<div class="header">
    <div class="nav-item active" data-tab="serverInfo" onclick="openTab('/index')">서버 정보</div>
    <div class="nav-item" data-tab="plugins" onclick="openTab('/plugins')">플러그인</div>
    <div class="nav-item" data-tab="players" onclick="openTab('/players')">플레이어</div>
</div>

<div class="container">
    <div class="left-pane">
        <div id="serverInfo" class="tab-content active">
            <h2>서버 로그</h2>
            <div class="log">
                <div id="serverLogs" style="height: 100%;">${logs}</div>
            </div>
            <button class="command-btn">⌨</button>
        </div>
    </div>

    <div class="right-pane">
        <div class="header-info">
            <h2>서버 정보</h2>
            <button class="reload-btn" onclick="window.location.reload()">⟳</button>
        </div>
        <div class="info">
            <strong>서버 상태: </strong> 온라인 <a style="color: #97ee8d">●</a>
        </div>
        <div class="info">
            <strong>서버 버전: </strong> ${version!'null'}
        </div>
        <div class="info">
            <strong>MOTD: </strong> ${motd!'서버 MOTD 정보 없음'}
        </div>
        <div class="info">
            <strong>플레이어: </strong> ${onlinePlayers!'0'}/${maxPlayers}
        </div>
    </div>
</div>

<div class="modal-overlay"></div>
<div class="command-modal">
    <label>
        <input type="text" class="command-input" placeholder="명령어를 입력하세요...">
    </label>
    <div class="suggestions"></div>
</div>
</body>
</html>