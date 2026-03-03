<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WealthTrack — Create Account</title>
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
        <h2>Create your account</h2>
        <p class="subtitle">Start tracking and managing your financial assets today.</p>

        <c:if test="${not empty error}">
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
            <div class="form-group">
                <label for="name">Full Name</label>
                <div class="input-wrapper">
                    <span class="input-icon"><i class="far fa-user"></i></span>
                    <input type="text" id="name" name="name" placeholder="John Doe" value="${name}" required>
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <div class="input-wrapper">
                    <span class="input-icon"><i class="far fa-envelope"></i></span>
                    <input type="email" id="email" name="email" placeholder="name@example.com" value="${email}" required>
                </div>
            </div>

            <div class="form-group">
                <label for="phone">Phone Number <span style="color:var(--text-muted);font-weight:400">(optional)</span></label>
                <div class="input-wrapper">
                    <span class="input-icon"><i class="fas fa-phone"></i></span>
                    <input type="tel" id="phone" name="phone" placeholder="+1-555-0100" value="${phone}">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <span class="input-icon"><i class="fas fa-lock"></i></span>
                        <input type="password" id="password" name="password" placeholder="••••••••" required minlength="6">
                    </div>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <div class="input-wrapper">
                        <span class="input-icon"><i class="fas fa-lock"></i></span>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••" required>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn btn-primary" style="margin-top:0.5rem">Create Account</button>
        </form>

        <div class="auth-footer">
            <span class="security"><i class="fas fa-shield-halved"></i> Your data is secure</span>
            <span class="signup-link">Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></span>
        </div>
    </div>
</div>
</body>
</html>
