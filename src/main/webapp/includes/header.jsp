<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header class="top-header">
    <div class="page-title">
        <c:if test="${not empty breadcrumb}">
            <div class="breadcrumb">${breadcrumb}</div>
        </c:if>
        <h1>${pageTitle}</h1>
        <c:if test="${not empty pageSubtitle}">
            <p>${pageSubtitle}</p>
        </c:if>
    </div>
    <div class="header-actions">
        <a href="${pageContext.request.contextPath}/settings" class="user-menu" title="Profile">${sessionScope.user.initials}</a>
    </div>
</header>
