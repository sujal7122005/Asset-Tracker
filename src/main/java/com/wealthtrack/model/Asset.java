package com.wealthtrack.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.sql.Timestamp;

public class Asset {
    private int assetId;
    private int userId;
    private String name;
    private String tickerSymbol;
    private int categoryId;
    private String categoryName;
    private BigDecimal currentPrice;
    private BigDecimal purchasePrice;
    private BigDecimal quantity;
    private Date purchaseDate;
    private BigDecimal commission;
    private String notes;
    private Timestamp addedDate;
    private Timestamp updatedAt;

    public Asset() {}

    // Getters and Setters
    public int getAssetId() { return assetId; }
    public void setAssetId(int assetId) { this.assetId = assetId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getTickerSymbol() { return tickerSymbol; }
    public void setTickerSymbol(String tickerSymbol) { this.tickerSymbol = tickerSymbol; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public BigDecimal getCurrentPrice() { return currentPrice; }
    public void setCurrentPrice(BigDecimal currentPrice) { this.currentPrice = currentPrice; }

    public BigDecimal getPurchasePrice() { return purchasePrice; }
    public void setPurchasePrice(BigDecimal purchasePrice) { this.purchasePrice = purchasePrice; }

    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }

    public Date getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(Date purchaseDate) { this.purchaseDate = purchaseDate; }

    public BigDecimal getCommission() { return commission; }
    public void setCommission(BigDecimal commission) { this.commission = commission; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getAddedDate() { return addedDate; }
    public void setAddedDate(Timestamp addedDate) { this.addedDate = addedDate; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    // Computed properties
    public BigDecimal getInvestedAmount() {
        if (purchasePrice == null || quantity == null) return BigDecimal.ZERO;
        return purchasePrice.multiply(quantity.abs()).setScale(2, RoundingMode.HALF_UP);
    }

    public BigDecimal getCurrentValue() {
        if (currentPrice == null || quantity == null) return BigDecimal.ZERO;
        return currentPrice.multiply(quantity.abs()).setScale(2, RoundingMode.HALF_UP);
    }

    public BigDecimal getProfitLoss() {
        return getCurrentValue().subtract(getInvestedAmount());
    }

    public BigDecimal getProfitLossPercent() {
        BigDecimal invested = getInvestedAmount();
        if (invested.compareTo(BigDecimal.ZERO) == 0) return BigDecimal.ZERO;
        return getProfitLoss().divide(invested, 4, RoundingMode.HALF_UP).multiply(new BigDecimal("100")).setScale(2, RoundingMode.HALF_UP);
    }
}
