<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WealthTrack — Portfolio Holdings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-layout">
    <c:set var="activePage" value="portfolio" scope="request"/>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <c:set var="pageTitle" value="Portfolio Holdings" scope="request"/>
        <c:set var="pageSubtitle" value="Manage and track your detailed asset allocation across all accounts." scope="request"/>
        <c:set var="breadcrumb" value="Home / Portfolio Breakdown" scope="request"/>

        <header class="top-header">
            <div class="page-title">
                <div class="breadcrumb">Home / Portfolio Breakdown</div>
                <h1>Portfolio Holdings</h1>
                <p>Manage and track your detailed asset allocation across all accounts.</p>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/settings" class="user-menu">${sessionScope.user.initials}</a>
            </div>
        </header>

        <div class="page-content">
            <div class="portfolio-toolbar">
                <div class="search-bar portfolio-search">
                    <span class="search-icon"><i class="fas fa-search"></i></span>
                    <input type="text" id="searchHoldings" placeholder="Search portfolio..." value="${searchQuery}" onkeyup="filterTable()">
                </div>
                <a href="${pageContext.request.contextPath}/asset/add" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Add Asset</a>
            </div>

            <!-- Summary Cards -->
            <div class="summary-cards">
                <div class="summary-card">
                    <div class="card-header">
                        <div class="card-icon blue"><i class="fas fa-wallet"></i></div>
                        <span class="card-change positive">+2.4%</span>
                    </div>
                    <div class="card-label">Total Net Worth</div>
                    <div class="card-value">$<fmt:formatNumber value="${summary.totalNetWorth}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
                </div>
                <div class="summary-card">
                    <div class="card-header">
                        <div class="card-icon purple"><i class="fas fa-chart-line"></i></div>
                        <span class="card-change positive">+4.1%</span>
                    </div>
                    <div class="card-label">Investments</div>
                    <div class="card-value">$<fmt:formatNumber value="${summary.totalInvestments}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
                </div>
                <div class="summary-card">
                    <div class="card-header">
                        <div class="card-icon orange"><i class="fas fa-coins"></i></div>
                        <span class="card-change neutral">Stable</span>
                    </div>
                    <div class="card-label">Liquid Cash</div>
                    <div class="card-value">$<fmt:formatNumber value="${summary.liquidCash}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
                </div>
                <div class="summary-card">
                    <div class="card-header">
                        <div class="card-icon red"><i class="fas fa-arrow-down"></i></div>
                        <span class="card-change negative">▲ Loan Due</span>
                    </div>
                    <div class="card-label">Liabilities</div>
                    <div class="card-value">-$<fmt:formatNumber value="${summary.liabilities * -1}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
                </div>
            </div>

            <!-- Tabs -->
            <div class="card">
                <div class="tabs">
                    <button class="tab-btn active" onclick="filterByCategory('all', this)">All Assets <span class="count">${totalAssets}</span></button>
                    <button class="tab-btn" onclick="filterByCategory('Equities', this)">Investments <span class="count">8</span></button>
                    <button class="tab-btn" onclick="filterByCategory('liabilities', this)">Liabilities <span class="count">2</span></button>
                    <button class="tab-btn" onclick="filterByCategory('Cash', this)">Cash <span class="count">4</span></button>
                </div>

                <!-- Asset Table -->
                <table class="data-table" id="assetTable">
                    <thead>
                        <tr>
                            <th>Asset Name</th>
                            <th>Category</th>
                            <th>Invested</th>
                            <th>Current Value</th>
                            <th>P&L</th>
                            <th>% Allocation</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="asset" items="${assets}" varStatus="loop">
                            <tr class="asset-row" data-category="${asset.categoryName}" onclick="window.location='${pageContext.request.contextPath}/asset/detail?id=${asset.assetId}'" style="cursor:pointer">
                                <td>
                                    <div class="asset-cell">
                                        <div class="asset-ticker">${not empty asset.tickerSymbol ? asset.tickerSymbol : '🏠'}</div>
                                        <div>
                                            <div class="asset-name">${asset.name}</div>
                                            <div class="asset-sub">
                                                <c:if test="${not empty asset.tickerSymbol}">${asset.tickerSymbol}</c:if>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge badge-${fn:toLowerCase(fn:replace(asset.categoryName, ' ', '-'))}">
                                        ${asset.categoryName}
                                    </span>
                                </td>
                                <td>$<fmt:formatNumber value="${asset.investedAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                <td><strong>$<fmt:formatNumber value="${asset.currentValue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></strong></td>
                                <td>
                                    <span class="${asset.profitLoss >= 0 ? 'pnl-positive' : 'pnl-negative'}">
                                        <c:if test="${asset.profitLoss >= 0}">+</c:if>$<fmt:formatNumber value="${asset.profitLoss}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                        <br><small>(${asset.profitLoss >= 0 ? '+' : ''}<fmt:formatNumber value="${asset.profitLossPercent}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%)</small>
                                    </span>
                                </td>
                                <td>
                                    <div class="allocation-cell">
                                        <c:set var="alloc" value="${summary.totalNetWorth > 0 ? (asset.currentValue / summary.totalNetWorth * 100) : 0}"/>
                                        <div class="percent"><fmt:formatNumber value="${alloc}" type="number" maxFractionDigits="0"/>%</div>
                                        <div class="allocation-bar"><div class="fill" style="width:${alloc > 100 ? 100 : alloc}%"></div></div>
                                    </div>
                                </td>
                                <td><button class="actions-btn" onclick="event.stopPropagation()"><i class="fas fa-ellipsis-v"></i></button></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Pagination -->
                <div class="pagination-bar">
                    <div class="pagination-info">Showing 1 to ${totalAssets > 5 ? 5 : totalAssets} of ${totalAssets} results</div>
                    <div class="pagination">
                        <button class="page-btn"><i class="fas fa-chevron-left"></i></button>
                        <button class="page-btn active">1</button>
                        <c:if test="${totalAssets > 5}"><button class="page-btn">2</button></c:if>
                        <c:if test="${totalAssets > 10}"><button class="page-btn">3</button></c:if>
                        <button class="page-btn"><i class="fas fa-chevron-right"></i></button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
function filterTable() {
    const query = document.getElementById('searchHoldings').value.toLowerCase();
    document.querySelectorAll('.asset-row').forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(query) ? '' : 'none';
    });
}
function filterByCategory(cat, btn) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    document.querySelectorAll('.asset-row').forEach(row => {
        if (cat === 'all') { row.style.display = ''; }
        else { row.style.display = row.dataset.category === cat ? '' : 'none'; }
    });
}
</script>
</body>
</html>
