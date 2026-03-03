<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="fas fa-landmark"></i></div>
        <h2>WealthTrack</h2>
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/dashboard" class="${activePage == 'dashboard' ? 'active' : ''}">
            <span class="nav-icon"><i class="fas fa-th-large"></i></span> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/portfolio" class="${activePage == 'portfolio' ? 'active' : ''}">
            <span class="nav-icon"><i class="fas fa-chart-pie"></i></span> Portfolio
        </a>
        <a href="${pageContext.request.contextPath}/transactions" class="${activePage == 'transactions' ? 'active' : ''}">
            <span class="nav-icon"><i class="fas fa-exchange-alt"></i></span> Transactions
        </a>
        <a href="${pageContext.request.contextPath}/documents" class="${activePage == 'documents' ? 'active' : ''}">
            <span class="nav-icon"><i class="fas fa-file-alt"></i></span> Documents
        </a>
        <a href="${pageContext.request.contextPath}/settings" class="${activePage == 'settings' ? 'active' : ''}">
            <span class="nav-icon"><i class="fas fa-cog"></i></span> Settings
        </a>
    </nav>
    <div class="sidebar-user">
        <div class="user-avatar">${sessionScope.user.initials}</div>
        <div class="user-info">
            <h4>${sessionScope.user.name}</h4>
            <p>Premium Member</p>
        </div>
    </div>
</aside>
