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
    </style>
</head>
<body>
<script>
    async function test() {
        try {
            const response = await fetch('/button-test', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' }
            });
            if (!response.ok) throw new Error('서버 응답 오류');
            const result = await response.text();
            alert(result);
        } catch (e) {console.log(e)}
    }

    function openTab(tabName) {
        window.location.href=tabName
    }

    window.onload = function() {
        document.getElementById('serverInfo').classList.add('active');
        document.querySelector('.nav-item[data-tab="serverInfo"]').classList.add('active');
    };
</script>

<#--<button name="test" onclick="test()">${btn}</button>-->

<div class="header">
    <div class="nav-item active" data-tab="serverInfo" onclick="openTab('/index')">서버 정보</div>
    <div class="nav-item" data-tab="plugins" onclick="openTab('/plugins')">플러그인</div>
    <div class="nav-item" data-tab="players" onclick="openTab('/players')">플레이어</div>
</div>

<div class="container">
    <div class="left-pane">
        <div id="serverInfo" class="tab-content active">
            <script>
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
                window.onload = fetchServerLogs;
            </script>
            <h2>서버 로그</h2>
            <div class="log">
                <div id="serverLogs" style="height: 100%;">${logs}</div>
            </div>

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
</body>
</html>
