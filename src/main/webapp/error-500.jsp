<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WealthTrack — Server Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="empty-state" style="background:var(--white);border-radius:var(--radius-lg);padding:4rem 3rem;box-shadow:var(--shadow-lg);max-width:480px">
        <div class="icon" style="font-size:4rem;color:var(--danger)">⚠️</div>
        <h1 style="font-size:4rem;font-weight:800;color:var(--danger);margin-bottom:0.5rem">500</h1>
        <h3 style="font-size:1.25rem;margin-bottom:0.75rem">Internal Server Error</h3>
        <p style="margin-bottom:1.5rem">Something went wrong on our end. Please try again later.</p>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary" style="width:auto">Back to Dashboard</a>
    </div>
</div>
</body>
</html>
