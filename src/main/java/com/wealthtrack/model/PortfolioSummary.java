package com.wealthtrack.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class PortfolioSummary {
    private int summaryId;
    private int userId;
    private BigDecimal totalNetWorth;
    private BigDecimal totalInvestments;
    private BigDecimal liquidCash;
    private BigDecimal liabilities;
    private Timestamp lastUpdated;

    public PortfolioSummary() {
    }

    public int getSummaryId() {
        return summaryId;
    }

    public void setSummaryId(int summaryId) {
        this.summaryId = summaryId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public BigDecimal getTotalNetWorth() {
        return totalNetWorth;
    }

    public void setTotalNetWorth(BigDecimal totalNetWorth) {
        this.totalNetWorth = totalNetWorth;
    }

    public BigDecimal getTotalInvestments() {
        return totalInvestments;
    }

    public void setTotalInvestments(BigDecimal totalInvestments) {
        this.totalInvestments = totalInvestments;
    }

    public BigDecimal getLiquidCash() {
        return liquidCash;
    }

    public void setLiquidCash(BigDecimal liquidCash) {
        this.liquidCash = liquidCash;
    }

    public BigDecimal getLiabilities() {
        return liabilities;
    }

    public void setLiabilities(BigDecimal liabilities) {
        this.liabilities = liabilities;
    }

    public Timestamp getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Timestamp lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
}
