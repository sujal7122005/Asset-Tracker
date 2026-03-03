<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WealthTrack — Dashboard</title>
    <meta name="description" content="WealthTrack Dashboard - View your financial overview, net worth, and recent activity.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
<div class="app-layout">
    <c:set var="activePage" value="dashboard" scope="request"/>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <c:set var="pageTitle" value="Overview" scope="request"/>
        <c:set var="pageSubtitle" value="Welcome back, here's your financial summary." scope="request"/>
        <%@ include file="includes/header.jsp" %>

        <div class="page-content">
            <!-- Net Worth -->
            <div class="net-worth-section">
                <div class="label">TOTAL NET WORTH</div>
                <div class="amount">$<fmt:formatNumber value="${summary.totalNetWorth}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
                <div class="change"><i class="fas fa-arrow-trend-up"></i> +2.4% ($29,400) vs last month</div>
            </div>

            <!-- Category Cards -->
            <div class="summary-cards">
                <div class="summary-card">
                    <div class="card-header">
                        <div class="card-icon blue"><i class="fas fa-wallet"></i></div>
                        <span class="card-change positive">+1.2%</span>
                    </div>
                    <div class="card-label">Cash & Equivalents</div>
                    <div class="card-value">$<fmt:formatNumber value="${cashValue}" type="number" minFractionDigits="0" maxFractionDigits="0"/></div>
                </div>
                <div class="summary-card">
                    <div class="card-header">
                        <div class="card-icon purple"><i class="fas fa-chart-line"></i></div>
                        <span class="card-change positive">+4.5%</span>
                    </div>
                    <div class="card-label">Equities</div>
                    <div class="card-value">$<fmt:formatNumber value="${equitiesValue}" type="number" minFractionDigits="0" maxFractionDigits="0"/></div>
                </div>
                <div class="summary-card">
                    <div class="card-header">
                        <div class="card-icon green"><i class="fas fa-home"></i></div>
                        <span class="card-change neutral">0.0%</span>
                    </div>
                    <div class="card-label">Real Estate</div>
                    <div class="card-value">$<fmt:formatNumber value="${realEstateValue}" type="number" minFractionDigits="0" maxFractionDigits="0"/></div>
                </div>
                <div class="summary-card">
                    <div class="card-header">
                        <div class="card-icon orange"><i class="fab fa-bitcoin"></i></div>
                        <span class="card-change negative">-2.1%</span>
                    </div>
                    <div class="card-label">Crypto & Gold</div>
                    <div class="card-value">$<fmt:formatNumber value="${cryptoValue}" type="number" minFractionDigits="0" maxFractionDigits="0"/></div>
                </div>
            </div>

            <!-- Chart + Activity -->
            <div class="two-col">
                <div class="card">
                    <div class="card-title">
                        <h3>Portfolio Performance</h3>
                        <div class="period-toggle">
                            <button onclick="updateChart('1M')">1M</button>
                            <button class="active" onclick="updateChart('6M')">6M</button>
                            <button onclick="updateChart('1Y')">1Y</button>
                            <button onclick="updateChart('ALL')">ALL</button>
                        </div>
                    </div>
                    <div class="chart-area">
                        <canvas id="performanceChart"></canvas>
                    </div>
                </div>

                <div class="card">
                    <div class="card-title">
                        <h3>Recent Activity</h3>
                    </div>
                    <ul class="activity-list">
                        <c:forEach var="activity" items="${activities}">
                            <li class="activity-item">
                                <div class="activity-icon ${activity.amount != null && activity.amount > 0 ? 'incoming' : (activity.amount != null ? 'outgoing' : 'neutral')}">
                                    <c:choose>
                                        <c:when test="${activity.actionType == 'Dividend Payout'}"><i class="fas fa-arrow-down"></i></c:when>
                                        <c:when test="${activity.actionType == 'Wire Transfer'}"><i class="fas fa-arrow-up"></i></c:when>
                                        <c:when test="${activity.actionType == 'Purchase'}"><i class="fas fa-shopping-cart"></i></c:when>
                                        <c:when test="${activity.actionType == 'Sale'}"><i class="fas fa-tag"></i></c:when>
                                        <c:otherwise><i class="fas fa-exchange-alt"></i></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="activity-info">
                                    <div class="title">${activity.actionType}</div>
                                    <div class="desc">${activity.description}</div>
                                    <div class="time"><fmt:formatDate value="${activity.timestamp}" pattern="MMM dd, yyyy"/></div>
                                </div>
                                <c:if test="${activity.amount != null}">
                                    <div class="activity-amount ${activity.amount > 0 ? 'positive' : 'negative'}">
                                        <c:if test="${activity.amount > 0}">+</c:if>$<fmt:formatNumber value="${activity.amount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    </div>
                                </c:if>
                                <c:if test="${activity.amount == null}">
                                    <div class="activity-amount" style="color:var(--text-muted)">–</div>
                                </c:if>
                            </li>
                        </c:forEach>
                        <c:if test="${empty activities}">
                            <li class="activity-item" style="justify-content:center;color:var(--text-muted)">No recent activity</li>
                        </c:if>
                    </ul>
                    <a href="${pageContext.request.contextPath}/transactions" class="view-all-link">View All Activity</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    initPerformanceChart();
});
</script>
</body>
</html>
