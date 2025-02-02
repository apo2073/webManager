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
        .container {
            display: flex;
            margin: 20px;
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

</div>
</body>
</html>
