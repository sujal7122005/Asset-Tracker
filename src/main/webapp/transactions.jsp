<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WealthTrack — Transactions</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-layout">
    <c:set var="activePage" value="transactions" scope="request"/>
    <%@ include file="includes/sidebar.jsp" %>
    <div class="main-content">
        <c:set var="pageTitle" value="Transaction History" scope="request"/>
        <c:set var="pageSubtitle" value="View all your buy, sell, dividend, and transfer records." scope="request"/>
        <%@ include file="includes/header.jsp" %>
        <div class="page-content">
            <div class="card">
                <div class="card-title">
                    <h3>All Transactions</h3>
                    <div class="search-bar" style="width:260px">
                        <span class="search-icon"><i class="fas fa-search"></i></span>
                        <input type="text" id="searchTxn" placeholder="Search transactions..." onkeyup="filterTxnTable()">
                    </div>
                </div>
                <table class="data-table" id="txnTable">
                    <thead>
                        <tr><th>Date</th><th>Asset</th><th>Type</th><th>Qty</th><th>Price</th><th>Net Amount</th><th>Status</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="txn" items="${transactions}">
                            <tr class="txn-row">
                                <td><fmt:formatDate value="${txn.transactionDate}" pattern="MMM dd, yyyy"/></td>
                                <td><div class="asset-name">${txn.assetName}</div><div class="asset-sub">${txn.tickerSymbol}</div></td>
                                <td><span class="badge badge-${txn.type.toLowerCase()}">${txn.type}</span></td>
                                <td><c:choose><c:when test="${txn.quantity > 0}"><fmt:formatNumber value="${txn.quantity}" maxFractionDigits="2"/></c:when><c:otherwise>–</c:otherwise></c:choose></td>
                                <td>$<fmt:formatNumber value="${txn.pricePerUnit}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                <td><strong>$<fmt:formatNumber value="${txn.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></strong></td>
                                <td><span class="status-check"><i class="fas fa-check-circle"></i></span></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty transactions}">
                            <tr><td colspan="7"><div class="empty-state"><div class="icon">📋</div><h3>No transactions yet</h3><p>Your buy/sell/dividend transactions will appear here.</p></div></td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script>
function filterTxnTable() {
    const q = document.getElementById('searchTxn').value.toLowerCase();
    document.querySelectorAll('.txn-row').forEach(r => { r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none'; });
}
</script>
</body>
</html>
