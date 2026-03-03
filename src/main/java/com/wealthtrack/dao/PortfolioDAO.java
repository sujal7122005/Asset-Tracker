package com.wealthtrack.dao;

import com.wealthtrack.model.PortfolioSummary;
import com.wealthtrack.util.DBConnection;

import java.sql.*;

public class PortfolioDAO {

    public PortfolioSummary getSummary(int userId) throws SQLException {
        String sql = "SELECT * FROM portfolio_summary WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PortfolioSummary ps2 = new PortfolioSummary();
                ps2.setSummaryId(rs.getInt("summary_id"));
                ps2.setUserId(rs.getInt("user_id"));
                ps2.setTotalNetWorth(rs.getBigDecimal("total_net_worth"));
                ps2.setTotalInvestments(rs.getBigDecimal("total_investments"));
                ps2.setLiquidCash(rs.getBigDecimal("liquid_cash"));
                ps2.setLiabilities(rs.getBigDecimal("liabilities"));
                ps2.setLastUpdated(rs.getTimestamp("last_updated"));
                return ps2;
            }
        }
        return null;
    }

    public boolean updateSummary(PortfolioSummary summary) throws SQLException {
        String sql = "UPDATE portfolio_summary SET total_net_worth = ?, total_investments = ?, liquid_cash = ?, liabilities = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, summary.getTotalNetWorth());
            ps.setBigDecimal(2, summary.getTotalInvestments());
            ps.setBigDecimal(3, summary.getLiquidCash());
            ps.setBigDecimal(4, summary.getLiabilities());
            ps.setInt(5, summary.getUserId());
            return ps.executeUpdate() > 0;
        }
    }
}
