<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WealthTrack — Settings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-layout">
    <c:set var="activePage" value="settings" scope="request"/>
    <%@ include file="includes/sidebar.jsp" %>
    <div class="main-content">
        <c:set var="pageTitle" value="Settings" scope="request"/>
        <c:set var="pageSubtitle" value="Manage your account preferences and security." scope="request"/>
        <%@ include file="includes/header.jsp" %>
        <div class="page-content">
            <c:if test="${not empty success}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div></c:if>
            <c:if test="${not empty error}"><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

            <div class="settings-grid">
                <!-- Profile Section -->
                <div class="card">
                    <h3 style="font-size:1.1rem;font-weight:700;margin-bottom:1.25rem;padding-bottom:0.75rem;border-bottom:1px solid var(--border)"><i class="fas fa-user" style="margin-right:0.5rem;color:var(--primary)"></i> Profile Information</h3>
                    <form action="${pageContext.request.contextPath}/settings" method="post">
                        <input type="hidden" name="action" value="updateProfile">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <div class="input-wrapper"><input type="text" id="name" name="name" value="${sessionScope.user.name}" required></div>
                        </div>
                        <div class="form-group">
                            <label for="settingsEmail">Email Address</label>
                            <div class="input-wrapper"><input type="email" id="settingsEmail" name="email" value="${sessionScope.user.email}" required></div>
                        </div>
                        <div class="form-group">
                            <label for="settingsPhone">Phone Number</label>
                            <div class="input-wrapper"><input type="tel" id="settingsPhone" name="phone" value="${sessionScope.user.phone}"></div>
                        </div>
                        <div class="form-group">
                            <label for="currency">Currency Preference</label>
                            <div class="input-wrapper">
                                <select id="currency" name="currency" style="flex:1;border:none;outline:none;padding:0.7rem;font-family:inherit;font-size:0.93rem;background:transparent">
                                    <option value="USD" ${sessionScope.user.currencyPreference == 'USD' ? 'selected' : ''}>USD ($)</option>
                                    <option value="EUR" ${sessionScope.user.currencyPreference == 'EUR' ? 'selected' : ''}>EUR (€)</option>
                                    <option value="GBP" ${sessionScope.user.currencyPreference == 'GBP' ? 'selected' : ''}>GBP (£)</option>
                                    <option value="INR" ${sessionScope.user.currencyPreference == 'INR' ? 'selected' : ''}>INR (₹)</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-check">
                            <input type="checkbox" id="notifications" name="notifications" ${sessionScope.user.notificationEnabled ? 'checked' : ''}>
                            <label for="notifications">Enable notifications</label>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width:auto">Save Changes</button>
                    </form>
                </div>

                <!-- Password Section -->
                <div>
                    <div class="card" style="margin-bottom:1.25rem">
                        <h3 style="font-size:1.1rem;font-weight:700;margin-bottom:1.25rem;padding-bottom:0.75rem;border-bottom:1px solid var(--border)"><i class="fas fa-lock" style="margin-right:0.5rem;color:var(--primary)"></i> Change Password</h3>
                        <form action="${pageContext.request.contextPath}/settings" method="post">
                            <input type="hidden" name="action" value="changePassword">
                            <div class="form-group">
                                <label for="oldPassword">Current Password</label>
                                <div class="input-wrapper"><input type="password" id="oldPassword" name="oldPassword" required></div>
                            </div>
                            <div class="form-group">
                                <label for="newPassword">New Password</label>
                                <div class="input-wrapper"><input type="password" id="newPassword" name="newPassword" required minlength="6"></div>
                            </div>
                            <div class="form-group">
                                <label for="confirmNewPassword">Confirm New Password</label>
                                <div class="input-wrapper"><input type="password" id="confirmNewPassword" name="confirmNewPassword" required></div>
                            </div>
                            <button type="submit" class="btn btn-primary" style="width:auto">Update Password</button>
                        </form>
                    </div>

                    <div class="card" style="border-color:#FECACA">
                        <h3 style="font-size:1.1rem;font-weight:700;margin-bottom:0.75rem;color:var(--danger)"><i class="fas fa-trash" style="margin-right:0.5rem"></i> Danger Zone</h3>
                        <p style="font-size:0.85rem;color:var(--text-secondary);margin-bottom:1rem">Permanently delete your account and all data. This action cannot be undone.</p>
                        <form action="${pageContext.request.contextPath}/settings" method="post" onsubmit="return confirm('Are you sure you want to delete your account? This action is permanent.')">
                            <input type="hidden" name="action" value="deleteAccount">
                            <button type="submit" class="btn btn-danger btn-sm">Delete Account</button>
                        </form>
                    </div>
                </div>
            </div>

            <div style="text-align:center;margin-top:2rem">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline" style="width:auto"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
