<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WealthTrack — Secure Login</title>
    <meta name="description" content="Login to WealthTrack to manage your financial assets and portfolio.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-brand">
        <div class="brand-icon"><i class="fas fa-landmark"></i></div>
        <h1>WealthTrack</h1>
        <p>Personal Asset Management</p>
    </div>

    <div class="auth-card">
        <h2>Welcome back</h2>
        <p class="subtitle">Please enter your details to access your portfolio.</p>

        <c:if test="${not empty error}">
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
            <div class="form-group">
                <label for="email">Email or Phone Number</label>
                <div class="input-wrapper">
                    <span class="input-icon"><i class="far fa-user"></i></span>
                    <input type="text" id="email" name="email" placeholder="name@example.com" value="${email}" required>
                </div>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <div class="input-wrapper">
                    <span class="input-icon"><i class="fas fa-lock"></i></span>
                    <input type="password" id="password" name="password" placeholder="••••••••••" required>
                    <button type="button" class="toggle-password" onclick="togglePassword('password')"><i class="far fa-eye-slash"></i></button>
                </div>
            </div>

            <div class="form-check">
                <input type="checkbox" id="remember" name="remember">
                <label for="remember">Remember this device</label>
            </div>

            <button type="submit" class="btn btn-primary">Secure Login</button>
        </form>

        <div class="auth-footer">
            <span class="security"><i class="fas fa-lock"></i> 256-bit SSL Encrypted</span>
            <span class="signup-link">No account? <a href="${pageContext.request.contextPath}/register">Sign up</a></span>
        </div>
    </div>
</div>

<script>
function togglePassword(id) {
    const input = document.getElementById(id);
    const icon = input.parentElement.querySelector('.toggle-password i');
    if (input.type === 'password') { input.type = 'text'; icon.className = 'far fa-eye'; }
    else { input.type = 'password'; icon.className = 'far fa-eye-slash'; }
}
</script>
</body>
</html>
