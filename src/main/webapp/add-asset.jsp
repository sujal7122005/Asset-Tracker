<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WealthTrack — Add New Asset</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="app-layout">
    <c:set var="activePage" value="portfolio" scope="request"/>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="wizard-overlay" id="wizardOverlay">
            <div class="wizard-card">
                <div class="wizard-header">
                    <div><h2>Add New Asset</h2><p>Track a new holding in your portfolio</p></div>
                    <a href="${pageContext.request.contextPath}/portfolio" class="wizard-close">&times;</a>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
                </c:if>

                <!-- Step Indicator -->
                <div class="step-indicator" id="stepIndicator">
                    <div class="step completed" id="step1Indicator">
                        <div class="step-num">1</div><div class="step-text">Type</div>
                    </div>
                    <div class="step-line completed" id="line1"></div>
                    <div class="step active" id="step2Indicator">
                        <div class="step-num">2</div><div class="step-text">Details</div>
                    </div>
                    <div class="step-line" id="line2"></div>
                    <div class="step" id="step3Indicator">
                        <div class="step-num">3</div><div class="step-text">Confirm</div>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/asset/add" method="post" id="addAssetForm">
                    <!-- Step 1: Category Selection -->
                    <div class="wizard-step" id="step1">
                        <div class="section-title"><i class="fas fa-th-large"></i> Select Asset Category</div>
                        <div class="category-grid">
                            <div class="category-option" onclick="selectCategory(1, 'Stocks & ETFs', this)">
                                <div class="cat-icon"><i class="fas fa-chart-line"></i></div>
                                <div class="cat-name">Stocks & ETFs</div>
                            </div>
                            <div class="category-option" onclick="selectCategory(3, 'Crypto', this)">
                                <div class="cat-icon"><i class="fab fa-bitcoin"></i></div>
                                <div class="cat-name">Crypto</div>
                            </div>
                            <div class="category-option" onclick="selectCategory(4, 'Real Estate', this)">
                                <div class="cat-icon"><i class="fas fa-home"></i></div>
                                <div class="cat-name">Real Estate</div>
                            </div>
                            <div class="category-option" onclick="selectCategory(5, 'Cash', this)">
                                <div class="cat-icon"><i class="fas fa-wallet"></i></div>
                                <div class="cat-name">Cash</div>
                            </div>
                            <div class="category-option" onclick="selectCategory(6, 'Bonds', this)">
                                <div class="cat-icon"><i class="fas fa-file-invoice-dollar"></i></div>
                                <div class="cat-name">Bonds</div>
                            </div>
                            <div class="category-option" onclick="selectCategory(2, 'ETF', this)">
                                <div class="cat-icon"><i class="fas fa-layer-group"></i></div>
                                <div class="cat-name">ETF</div>
                            </div>
                        </div>
                    </div>

                    <!-- Step 2: Asset Details -->
                    <div class="wizard-step" id="step2" style="display:none">
                        <div class="selected-category" id="selectedCategoryDisplay">
                            <div class="cat-icon"><i class="fas fa-chart-line"></i></div>
                            <div class="cat-info">
                                <div class="cat-label">SELECTED CATEGORY</div>
                                <div class="cat-name" id="selectedCatName">Stocks & ETFs</div>
                            </div>
                            <a href="javascript:void(0)" class="change-link" onclick="goToStep(1)">Change</a>
                        </div>

                        <input type="hidden" name="categoryId" id="categoryId" value="">

                        <div class="section-title"><i class="fas fa-search"></i> Asset Identification</div>
                        <div class="form-group">
                            <label for="tickerSymbol">TICKER SYMBOL OR NAME</label>
                            <div class="input-wrapper">
                                <span class="input-icon"><i class="fas fa-search"></i></span>
                                <input type="text" id="tickerSymbol" name="tickerSymbol" placeholder="AAPL">
                            </div>
                            <div class="current-price-display">
                                <span class="dot"></span> Current Price: <strong id="currentPriceDisplay">$0.00</strong> <span style="color:var(--text-muted)">(Delayed 15m)</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="assetName">ASSET NAME</label>
                            <div class="input-wrapper">
                                <input type="text" id="assetName" name="assetName" placeholder="Apple Inc." required>
                            </div>
                        </div>

                        <div class="section-title" style="margin-top:1.5rem"><i class="fas fa-file-alt"></i> Transaction Details</div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="quantity">QUANTITY (SHARES)</label>
                                <div class="input-wrapper">
                                    <input type="number" id="quantity" name="quantity" placeholder="0.00" step="0.000001" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="purchasePrice">COST BASIS (PER SHARE)</label>
                                <div class="input-wrapper">
                                    <span class="input-icon">$</span>
                                    <input type="number" id="purchasePrice" name="purchasePrice" placeholder="0.00" step="0.01" required>
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="purchaseDate">PURCHASE DATE</label>
                                <div class="input-wrapper">
                                    <input type="date" id="purchaseDate" name="purchaseDate">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="commission">COMMISSION / FEES</label>
                                <div class="input-wrapper">
                                    <span class="input-icon">$</span>
                                    <input type="number" id="commission" name="commission" placeholder="0.00" step="0.01" value="0.00">
                                </div>
                            </div>
                        </div>
                        <input type="hidden" name="currentPrice" id="currentPriceInput" value="0">
                    </div>

                    <!-- Step 3: Confirm -->
                    <div class="wizard-step" id="step3" style="display:none">
                        <div class="section-title"><i class="fas fa-check-circle"></i> Review & Confirm</div>
                        <div class="card" style="background:var(--bg)">
                            <div class="stat-row"><span class="stat-label">Category</span><span class="stat-value" id="confirmCategory">–</span></div>
                            <div class="stat-row"><span class="stat-label">Asset Name</span><span class="stat-value" id="confirmName">–</span></div>
                            <div class="stat-row"><span class="stat-label">Ticker</span><span class="stat-value" id="confirmTicker">–</span></div>
                            <div class="stat-row"><span class="stat-label">Quantity</span><span class="stat-value" id="confirmQty">–</span></div>
                            <div class="stat-row"><span class="stat-label">Cost Basis</span><span class="stat-value" id="confirmCost">–</span></div>
                            <div class="stat-row"><span class="stat-label">Total Investment</span><span class="stat-value" id="confirmTotal">–</span></div>
                            <div class="stat-row"><span class="stat-label">Purchase Date</span><span class="stat-value" id="confirmDate">–</span></div>
                            <div class="stat-row"><span class="stat-label">Commission</span><span class="stat-value" id="confirmComm">–</span></div>
                        </div>
                    </div>

                    <!-- Footer -->
                    <div class="wizard-footer">
                        <button type="button" class="btn btn-outline" id="backBtn" onclick="prevStep()" style="visibility:hidden">Back</button>
                        <span class="step-info" id="stepInfo">Step 1 of 3</span>
                        <button type="button" class="btn btn-primary" id="nextBtn" onclick="nextStep()">Continue →</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
let currentStep = 1;
let selectedCategoryId = '';
let selectedCategoryName = '';

function selectCategory(id, name, el) {
    document.querySelectorAll('.category-option').forEach(o => o.classList.remove('selected'));
    el.classList.add('selected');
    selectedCategoryId = id;
    selectedCategoryName = name;
    document.getElementById('categoryId').value = id;
    document.getElementById('selectedCatName').textContent = name;
}

function goToStep(step) {
    document.querySelectorAll('.wizard-step').forEach(s => s.style.display = 'none');
    document.getElementById('step' + step).style.display = 'block';
    currentStep = step;
    updateStepUI();
}

function nextStep() {
    if (currentStep === 1 && !selectedCategoryId) { alert('Please select a category'); return; }
    if (currentStep === 2) {
        if (!document.getElementById('assetName').value) { alert('Please enter asset name'); return; }
        populateConfirmation();
    }
    if (currentStep === 3) {
        document.getElementById('addAssetForm').submit();
        return;
    }
    currentStep++;
    goToStep(currentStep);
}

function prevStep() { if (currentStep > 1) { currentStep--; goToStep(currentStep); } }

function updateStepUI() {
    for (let i = 1; i <= 3; i++) {
        const si = document.getElementById('step' + i + 'Indicator');
        si.className = 'step' + (i < currentStep ? ' completed' : (i === currentStep ? ' active' : ''));
    }
    document.getElementById('line1').className = 'step-line' + (currentStep > 1 ? ' completed' : '');
    document.getElementById('line2').className = 'step-line' + (currentStep > 2 ? ' completed' : '');
    document.getElementById('backBtn').style.visibility = currentStep > 1 ? 'visible' : 'hidden';
    document.getElementById('nextBtn').textContent = currentStep === 3 ? 'Add Asset' : 'Continue →';
    document.getElementById('stepInfo').textContent = 'Step ' + currentStep + ' of 3';
}

function populateConfirmation() {
    document.getElementById('confirmCategory').textContent = selectedCategoryName;
    document.getElementById('confirmName').textContent = document.getElementById('assetName').value;
    document.getElementById('confirmTicker').textContent = document.getElementById('tickerSymbol').value || '–';
    const qty = document.getElementById('quantity').value || '0';
    const cost = document.getElementById('purchasePrice').value || '0';
    document.getElementById('confirmQty').textContent = qty;
    document.getElementById('confirmCost').textContent = '$' + parseFloat(cost).toFixed(2);
    document.getElementById('confirmTotal').textContent = '$' + (parseFloat(qty) * parseFloat(cost)).toFixed(2);
    document.getElementById('confirmDate').textContent = document.getElementById('purchaseDate').value || '–';
    document.getElementById('confirmComm').textContent = '$' + parseFloat(document.getElementById('commission').value || 0).toFixed(2);
    document.getElementById('currentPriceInput').value = cost;
}
</script>
</body>
</html>
