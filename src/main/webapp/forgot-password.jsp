<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WealthTrack — Forgot Password</title>
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
        <h2>Reset Password</h2>
        <p class="subtitle">Enter your email address and we'll send you a link to reset your password.</p>
        <form action="#" method="post">
            <div class="form-group">
                <label for="resetEmail">Email Address</label>
                <div class="input-wrapper">
                    <span class="input-icon"><i class="far fa-envelope"></i></span>
                    <input type="email" id="resetEmail" name="email" placeholder="name@example.com" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Send Reset Link</button>
        </form>
        <div class="auth-footer" style="justify-content:center">
            <span class="signup-link"><a href="${pageContext.request.contextPath}/login"><i class="fas fa-arrow-left"></i> Back to Login</a></span>
        </div>
    </div>
</div>
</body>
</html>
