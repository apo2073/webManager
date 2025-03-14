<html>
<head>
    <title>WebManager</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

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
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
            padding: 0 10px;
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
            margin: 80px 20px 20px;
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
        .modal.fade .modal-dialog {
            transform: translate(-50%, -55%);
            opacity: 0;
            transition: all 0.1s ease-out;
        }
        .modal.in .modal-dialog {
            transform: translate(-50%, -50%);
            opacity: 1;
        }
        .modal-content {
            background-color: #fafafa;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            display: flex;
            padding: 20px;
            width: 500px;
        }
        .modal-header {
            background-color: #f0f0f0;
            border-bottom: 1px solid #ddd;
            padding: 10px;
            position: absolute;
            top: 0;
            left: 0;
            width: 105%;
            height: 10%;
            text-align: center;
        }
        .modal-title {
            font-family: CookieRun, sans-serif;
            font-size: 15px;
            margin: 0;
        }
        .modal-body {
            background-color: #fafafa;
            font-size: 19px;
            display: flex;
            flex: 1;
            padding: 20px 10px;
            margin-top: 60px;
        }
        .modal-body .left-section {
            flex: 1;
            padding-right: 20px;
            border-right: 2px solid #ddd;
        }
        .modal-body .right-section {
            flex: 2;
            padding-left: 20px;
        }
        .left-section img {
            width: 100%;
            border-radius: 10px;
        }
        .modal-dialog {
            background-color: #fafafa;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: auto;
            max-width: 500px;
            margin: 0;
        }
        .close {
            border: none;
            background: transparent;
            font-size: 30px;
            font-weight: bold;
            color: #000;
            opacity: 0.7;
        }
        .close:hover {
            opacity: 1;
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
                <button class="detail-button" data-toggle="modal" data-target="#playerModal" data-player="${player}" data-uuid="${playerUUID}">⁝</button>
                <img src="https://api.mineatar.io/face/${playerUUID}?scale=16&format=png" alt="player head image"><br>
                <strong>${player}</strong><br>
                UUID: ${playerUUID}
            </div>
        </#list>
    </div>

    <div class="modal fade" id="playerModal" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">상세 정보</h4>
                </div>
                <div class="modal-body">
                    <div class="left-section">
                        <img id="playerBodyImage" src="" alt="Player Body Image">
                    </div>
                    <div class="right-section">
                        <p id="playerAdditionalInfo"></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $('#playerModal').on('show.bs.modal', function (event) {
        const button = $(event.relatedTarget);
        const uuid = button.data('uuid');
        const modal = $(this);

        $.ajax({
            url: '/player-info?uuid=' + uuid,
            method: 'GET',
            success: function(response) {
                const playerInfo = JSON.parse(response);
                modal.find('#playerAdditionalInfo').html(playerInfo.name + "<br>" + playerInfo.uuid);
            },
            error: function() {
                modal.find('#playerAdditionalInfo').html('플레이어 정보를 가져오는 데 실패했습니다.');
            }
        });

        modal.find('#playerBodyImage').attr('src', 'https://crafatar.com/renders/body/' + uuid);
    });
</script>

</body>
</html>
