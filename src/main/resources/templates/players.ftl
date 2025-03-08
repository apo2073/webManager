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
            width: 100%;
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
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background-color: #fff;
            width: 50%;
            height: 70%;
            display: flex;
            padding: 20px;
            border-radius: 15px;
            gap: 20px;
        }
        .modal-content img {
            max-width: 150px;
            max-height: 150px;
            border-radius: 15px;
        }
        .modal-content .player-details {
            flex-grow: 1;
        }
        .modal .close-button {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 10px;
            background-color: #ff4d4d;
            color: white;
            border: none;
            border-radius: 50%;
            cursor: pointer;
        }
    </style>
</head>
<body>

<script>
    function openTab(tabName) {
        window.location.href = tabName;
    }

    function showPlayerDetails(player, uuid) {
        const modal = document.getElementById('playerModal');
        const playerImage = document.getElementById('playerImage');
        const playerName = document.getElementById('playerName');
        const playerUUID = document.getElementById('playerUUID');
        const playerInfo = document.getElementById('playerInfo');

        playerImage.src = `https://crafatar.com/renders/body/${uuid}`;
        playerName.innerText = player;
        playerUUID.innerText = uuid;

        fetch(`/player-info?uuid=${uuid}`)
            .then(response => response.json())
            .then(data => {
                playerInfo.innerHTML = data.details;
            });

        modal.style.display = 'flex';
    }

    function closeModal() {
        const modal = document.getElementById('playerModal');
        modal.style.display = 'none';
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
            <div><strong>온라인 플레이어 수: </strong><span>${online}</span></div>
            <div><strong>추방된 플레이어 수: </strong><span>${banned}</span></div>
        </div>
    </div>

    <#assign playersList = players?split(",")>
    <div class="player-grid" id="playerList">
        <#list playersList as player>
            <#assign playerUUID = playerData[player]!''>
            <div class="player-profile">
                <button class="detail-button" onclick="showPlayerDetails('${player}', '${playerUUID}')">⁝</button>
                <img src="https://api.mineatar.io/face/${playerUUID}?scale=16&format=png" alt="${player}의 스킨"><br>
                <strong>${player}</strong><br>
                UUID: ${playerUUID}
            </div>
        </#list>
    </div>
</div>

<div id="playerModal" class="modal">
    <div class="modal-content">
        <img id="playerImage" src="" alt="Player Image">
        <div class="player-details">
            <h2 id="playerName"></h2>
            <p id="playerUUID"></p>
            <div id="playerInfo"></div>
        </div>
    </div>
    <button class="close-button" onclick="closeModal()">×</button>
</div>

</body>
</html>
