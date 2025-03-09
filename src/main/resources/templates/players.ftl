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
            flex-direction: column;
        }
        .player-info {
            font-family: CookieRun, sans-serif;
            width: 90%;
            height: 200px;
            border: 1px solid #ccc;
            border-radius: 15px;
            padding: 10px;
            font-size: 19px;
        }
        .player-profile {
            font-family: CookieRun, sans-serif;
            width: 15%;
            height: 200px;
            border: 1px solid #ccc;
            border-radius: 15px;
            padding: 10px;
            font-size: 19px;
            overflow-y: scroll;
            max-height: 100vh;
            position: relative;
        }
        .detail-button {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 5px 10px;
            cursor: pointer;
            pointer-events: auto;
            font-size: 15px;
            background-color: #fff;
            border: none;
            border-radius: 50%;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            transition: background-color 0.3s, transform 0.3s;
        }
        .player-profile::-webkit-scrollbar {
            display: none;
        }
        .info {
            margin: 20px;
        }
        .player-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
    </style>
</head>
<body>

<script>
    function openTab(tabName) {
        window.location.href = tabName;
    }
</script>

<div class="header">
    <div class="nav-item" data-tab="serverInfo" onclick="openTab('/index')">서버 정보</div>
    <div class="nav-item" data-tab="plugins" onclick="openTab('/plugins')">플러그인</div>
    <div class="nav-item active" data-tab="players" onclick="openTab('/players')">플레이어</div>
</div>

<div class="container">
    <div class="player-info">
        <div class="info" style="height: 90%">
            <div><strong>온라인 플레이어 수: </strong><span>${online}</span></div>
            <div><strong>추방된 플레이어 수: </strong><span>${banned}</span></div>
        </div>
    </div>

    <#assign playersList = players?split(",")>
    <div class="player-grid" id="playerList">
        <#list playersList as player>
            <#assign playerUUID = playerData[player]!''>
            <div class="player-profile">
                <button class="detail-button" onclick="">⁝</button>
                <img src="https://api.mineatar.io/face/${playerUUID}?scale=16&format=png"><br>
                <strong>${player}</strong><br>
                UUID: ${playerUUID}
            </div>
        </#list>
    </div>
    <#--https://crafatar.com/renders/body/6b24e259-9fd7-47c8-a1db-af00f2fded55-->
</div>

</body>
</html>
