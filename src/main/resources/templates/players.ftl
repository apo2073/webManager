<!-- players.ftl -->
<html>
<head>
    <title>WebManager</title>
    <style>
        @font-face { font-family: CookieRun; src: url('/resource/CookieRun.ttf') }
        body {
            font-family: CookieRun, sans-serif;
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
            gap: 20px;
        }

        .player-info {
            font-family: CookieRun, sans-serif;
            width: 100%;
            height: 200px;
            border: 1px solid #ccc;
            border-radius: 15px;
            padding: 10px;
            font-size: 19px;
        }
        .info {
            margin: 20px;
        }
    </style>
</head>
<body>
<script>
    function openTab(tabName) {
        window.location.href=tabName
    }


</script>

<div class="header">
    <div class="nav-item" data-tab="serverInfo" onclick="openTab('/index')">서버 정보</div>
    <div class="nav-item" data-tab="plugins" onclick="openTab('/plugins')">플러그인</div>
    <div class="nav-item active" data-tab="players" onclick="openTab('/players')">플레이어</div>
</div>

<div class="container">
    <div class="player-info">
        <div class="info" style="height: 100%">
            <strong>온라인 플레이어 수: </strong><a>${online}</a>
            <strong>추방된 플레이어 수: </strong><a>${banned}</a>
        </div>
    </div>
    <div class="player-grid" id="playerList"></div>
</div>
</body>
</html>
