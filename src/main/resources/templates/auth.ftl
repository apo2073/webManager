<html>
<head>
    <title>관리자 인증</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }
        .auth-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .error {
            color: red;
        }
        .code {
            color: green;
            font-size: 24px;
            margin: 10px 0;
        }
        input[type="text"] {
            padding: 8px;
            margin: 10px 0;
            width: 200px;
        }
        button {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
    <script>
        function checkAuth(code) {
            setInterval(() => {
                fetch('/check-auth?code=' + code)
                    .then(response => {
                        if (response.redirected) {
                            window.location.href = response.url;
                        }
                    });
            }, 1000);
        }
    </script>
</head>
<body>
<div class="auth-container">
    <h2>관리자 인증</h2>
    <#if error??>
        <p class="error">${error}</p>
    </#if>
    <#if code??>
        <p>인게임에서 다음 명령어를 입력하세요:</p>
        <p class="code">/auth ${code}</p>
        <p>인증이 완료되면 페이지를 새로고침 해주세요...</p>
        <script>checkAuth("${code}");</script>
    <#else>
        <form method="post" action="/request-code">
            <input type="text" name="player" placeholder="플레이어 이름 입력" required>
            <br>
            <button type="submit">인증 코드 받기</button>
        </form>
    </#if>
</div>
</body>
</html>