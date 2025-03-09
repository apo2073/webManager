<html>
<head>
    <title>WebManager</title>
    <style>
        body {
            font-family: Arial, sans-serif;
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
        .info {
            margin: 20px;
        }
        .container {
            display: flex;
            margin: 20px;
            gap: 20px;
            flex-direction: column;
        }
        .plugin-info {
            font-family: CookieRun, sans-serif;
            width: 90%;
            height: 200px;
            border: 1px solid #ccc;
            border-radius: 15px;
            padding: 10px;
            font-size: 19px;
        }
        .plugin-profile {
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
        .plugin-profile::-webkit-scrollbar {
            display: none;
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
        .plugin-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
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
        } catch (e) {console.log(e)}
    }

    function openTab(tabName) {
        window.location.href=tabName
    }

    window.onload = function() {
        document.getElementById('plugins').classList.add('active');
        document.querySelector('.nav-item[data-tab="plugins"]').classList.add('active');
    };
</script>

<div class="header">
    <div class="nav-item" data-tab="serverInfo" onclick="openTab('/index')">서버 정보</div>
    <div class="nav-item active" data-tab="plugins" onclick="openTab('/plugins')">플러그인</div>
    <div class="nav-item" data-tab="players" onclick="openTab('/players')">플레이어</div>
</div>

<div class="container">
    <div class="plugin-info">
        <div class="info" style="height: 100%">
            <div><strong>총 플러그인 수: </strong><span>${count}</span></div>
        </div>
    </div>

    <#assign pluginList = plugins?split(",")>
    <div class="plugin-grid" id="pluginList">
        <#list pluginList as plugin>
            <div class="plugin-profile">
                <button class="detail-button" onclick="">⁝</button>
                <img src="https://placehold.co/128x128"><br>
                <strong>${plugin}</strong><br>
            </div>
        </#list>
    </div>
</div>
</body>
</html>
