<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WealthTrack — ${asset.name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
<div class="app-layout">
    <c:set var="activePage" value="portfolio" scope="request"/>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <c:set var="pageTitle" value="" scope="request"/>
        <%@ include file="includes/header.jsp" %>

        <div class="page-content">
            <!-- Asset Header -->
            <div class="asset-header">
                <div class="asset-id">
                    <div class="icon"><i class="fas fa-chart-line" style="font-size:1.3rem;color:var(--primary)"></i></div>
                    <div>
                        <h1>${asset.name}</h1>
                        <span class="ticker">
                            <c:if test="${not empty asset.tickerSymbol}">NASDAQ: ${asset.tickerSymbol} • </c:if>${asset.categoryName}
                        </span>
                    </div>
                </div>
                <div style="text-align:right">
                    <div class="price-display">
                        <span class="price">$<fmt:formatNumber value="${asset.currentPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                        <span class="price-change ${asset.profitLoss >= 0 ? 'pnl-positive' : 'pnl-negative'}" style="margin-left:0.75rem;font-size:0.9rem">
                            <i class="fas fa-arrow-trend-${asset.profitLoss >= 0 ? 'up' : 'down'}"></i>
                            ${asset.profitLoss >= 0 ? '+' : ''}<fmt:formatNumber value="${asset.profitLossPercent}" type="number" minFractionDigits="1" maxFractionDigits="1"/>%
                        </span>
                    </div>
                    <div class="last-updated">Last updated: <fmt:formatDate value="${asset.updatedAt}" pattern="MMM dd, HH:mm"/> EST
                        <button class="refresh-btn" onclick="location.reload()"><i class="fas fa-rotate"></i> Refresh Value</button>
                    </div>
                </div>
            </div>

            <!-- Chart + Stats -->
            <div class="two-col">
                <div class="card">
                    <div class="card-title">
                        <h3>Performance</h3>
                        <div class="period-toggle">
                            <button>1D</button><button>1W</button><button class="active">1M</button>
                            <button>YTD</button><button>1Y</button><button>ALL</button>
                        </div>
                    </div>
                    <div class="chart-area"><canvas id="assetChart"></canvas></div>
                </div>

                <div>
                    <!-- Key Statistics -->
                    <div class="card" style="margin-bottom:1.25rem">
                        <h3 style="font-size:1rem;font-weight:700;margin-bottom:1rem">KEY STATISTICS</h3>
                        <div class="stat-row">
                            <span class="stat-label">Day's Range</span>
                            <span class="stat-value">$<fmt:formatNumber value="${asset.currentPrice * 0.98}" maxFractionDigits="2"/> - $<fmt:formatNumber value="${asset.currentPrice * 1.01}" maxFractionDigits="2"/></span>
                        </div>
                        <div class="range-slider"><div class="track" style="width:70%"><div class="thumb" style="right:0"></div></div></div>
                        <div class="stat-row">
                            <span class="stat-label">52 Week Range</span>
                            <span class="stat-value">$<fmt:formatNumber value="${asset.currentPrice * 0.7}" maxFractionDigits="2"/> - $<fmt:formatNumber value="${asset.currentPrice * 1.15}" maxFractionDigits="2"/></span>
                        </div>
                        <div class="stat-grid">
                            <div><div class="stat-label">Market Cap</div><div class="stat-value">2.7T</div></div>
                            <div><div class="stat-label">P/E Ratio</div><div class="stat-value">29.4</div></div>
                            <div><div class="stat-label">Div Yield</div><div class="stat-value">0.54%</div></div>
                            <div><div class="stat-label">Beta</div><div class="stat-value">1.28</div></div>
                        </div>
                    </div>

                    <!-- Position Card -->
                    <div class="position-card">
                        <div class="card-label">YOUR POSITION</div>
                        <div class="position-row">
                            <span class="label">Shares Owned</span>
                            <span class="value"><fmt:formatNumber value="${asset.quantity}" maxFractionDigits="2"/></span>
                        </div>
                        <div class="position-row">
                            <span class="label">Avg Cost</span>
                            <span class="value">$<fmt:formatNumber value="${asset.purchasePrice}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>
                        <div class="position-row">
                            <span class="label">Total Return</span>
                            <span class="value ${asset.profitLoss >= 0 ? 'pnl-positive' : 'pnl-negative'}">
                                ${asset.profitLoss >= 0 ? '+' : ''}$<fmt:formatNumber value="${asset.profitLoss}" minFractionDigits="2" maxFractionDigits="2"/>
                                <br><small>${asset.profitLoss >= 0 ? '+' : ''}<fmt:formatNumber value="${asset.profitLossPercent}" minFractionDigits="1" maxFractionDigits="1"/>%</small>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Transaction History + Documents -->
            <div class="two-col" style="margin-top:1.25rem">
                <div class="card">
                    <div class="card-title">
                        <h3>Transaction History</h3>
                        <a href="${pageContext.request.contextPath}/transactions" style="font-size:0.85rem">View All</a>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr><th>Date</th><th>Type</th><th>Qty</th><th>Price</th><th>Net Amount</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="txn" items="${transactions}">
                                <tr>
                                    <td><fmt:formatDate value="${txn.transactionDate}" pattern="MMM dd, yyyy"/></td>
                                    <td><span class="badge badge-${txn.type.toLowerCase()}">${txn.type}</span></td>
                                    <td><c:choose><c:when test="${txn.quantity > 0}"><fmt:formatNumber value="${txn.quantity}" maxFractionDigits="0"/></c:when><c:otherwise>–</c:otherwise></c:choose></td>
                                    <td>$<fmt:formatNumber value="${txn.pricePerUnit}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td><strong>$<fmt:formatNumber value="${txn.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></strong></td>
                                    <td><span class="status-check"><i class="fas fa-check-circle"></i></span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="card">
                    <div class="card-title">
                        <h3>Document Vault</h3>
                        <button class="btn btn-outline btn-sm btn-icon"><i class="fas fa-plus"></i></button>
                    </div>
                    <c:forEach var="doc" items="${documents}">
                        <div class="doc-item">
                            <div class="doc-icon"><i class="fas fa-file-pdf"></i></div>
                            <div class="doc-info">
                                <div class="name">${doc.fileName}</div>
                                <div class="meta">${doc.fileSizeFormatted} • <fmt:formatDate value="${doc.uploadDate}" pattern="MMM dd, yyyy"/></div>
                            </div>
                            <button class="doc-download"><i class="fas fa-download"></i></button>
                        </div>
                    </c:forEach>
                    <c:if test="${empty documents}">
                        <div style="text-align:center;padding:1.5rem;color:var(--text-muted)">No documents uploaded</div>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/documents" class="view-all-link" style="border-top:1px solid var(--border);margin-top:0.5rem">View All Documents</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script>document.addEventListener('DOMContentLoaded', function() { initAssetChart(); });</script>
</body>
</html>
