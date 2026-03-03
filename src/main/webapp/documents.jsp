<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WealthTrack — Documents</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-layout">
    <c:set var="activePage" value="documents" scope="request"/>
    <%@ include file="includes/sidebar.jsp" %>
    <div class="main-content">
        <c:set var="pageTitle" value="Document Management" scope="request"/>
        <c:set var="pageSubtitle" value="Manage trade confirmations, statements, and financial documents." scope="request"/>
        <%@ include file="includes/header.jsp" %>
        <div class="page-content">
            <div class="card" style="margin-bottom:1.5rem">
                <div class="card-title">
                    <h3>Upload Document</h3>
                </div>
                <form action="${pageContext.request.contextPath}/documents" method="post" enctype="multipart/form-data" style="display:flex;gap:1rem;align-items:flex-end;flex-wrap:wrap">
                    <div class="form-group" style="flex:1;min-width:200px;margin:0">
                        <label for="file">Select File (PDF, Image)</label>
                        <div class="input-wrapper"><input type="file" id="file" name="file" accept=".pdf,.jpg,.jpeg,.png" required style="padding:0.55rem"></div>
                    </div>
                    <div class="form-group" style="width:200px;margin:0">
                        <label for="assetId">Link to Asset (optional)</label>
                        <div class="input-wrapper"><input type="number" id="assetId" name="assetId" placeholder="Asset ID"></div>
                    </div>
                    <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-upload"></i> Upload</button>
                </form>
            </div>

            <div class="card">
                <div class="card-title"><h3>All Documents</h3></div>
                <c:forEach var="doc" items="${documents}">
                    <div class="doc-item">
                        <div class="doc-icon"><i class="fas fa-file-pdf"></i></div>
                        <div class="doc-info">
                            <div class="name">${doc.fileName}</div>
                            <div class="meta">${doc.fileSizeFormatted} • <fmt:formatDate value="${doc.uploadDate}" pattern="MMM dd, yyyy"/> <c:if test="${not empty doc.assetName}"> • ${doc.assetName}</c:if></div>
                        </div>
                        <button class="doc-download" title="Download"><i class="fas fa-download"></i></button>
                    </div>
                </c:forEach>
                <c:if test="${empty documents}">
                    <div class="empty-state"><div class="icon">📁</div><h3>No documents uploaded</h3><p>Upload your trade confirmations and financial statements here.</p></div>
                </c:if>
            </div>
        </div>
    </div>
</div>
</body>
</html>
