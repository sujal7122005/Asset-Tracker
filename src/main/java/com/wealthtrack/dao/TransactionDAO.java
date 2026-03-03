package com.wealthtrack.dao;

import com.wealthtrack.model.Transaction;
import com.wealthtrack.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    public boolean addTransaction(Transaction txn) throws SQLException {
        String sql = "INSERT INTO transactions (asset_id, user_id, type, quantity, price_per_unit, total_amount, commission, transaction_date, status, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, txn.getAssetId());
            ps.setInt(2, txn.getUserId());
            ps.setString(3, txn.getType());
            ps.setBigDecimal(4, txn.getQuantity());
            ps.setBigDecimal(5, txn.getPricePerUnit());
            ps.setBigDecimal(6, txn.getTotalAmount());
            ps.setBigDecimal(7, txn.getCommission());
            ps.setDate(8, txn.getTransactionDate());
            ps.setString(9, txn.getStatus());
            ps.setString(10, txn.getNotes());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Transaction> getTransactionsByAsset(int assetId) throws SQLException {
        String sql = "SELECT t.*, a.name as asset_name, a.ticker_symbol FROM transactions t " +
                "JOIN assets a ON t.asset_id = a.asset_id " +
                "WHERE t.asset_id = ? ORDER BY t.transaction_date DESC";
        List<Transaction> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assetId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapTransaction(rs));
            }
        }
        return list;
    }

    public List<Transaction> getTransactionsByUser(int userId) throws SQLException {
        String sql = "SELECT t.*, a.name as asset_name, a.ticker_symbol FROM transactions t " +
                "JOIN assets a ON t.asset_id = a.asset_id " +
                "WHERE t.user_id = ? ORDER BY t.transaction_date DESC";
        List<Transaction> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapTransaction(rs));
            }
        }
        return list;
    }

    public List<Transaction> getRecentTransactions(int userId, int limit) throws SQLException {
        String sql = "SELECT t.*, a.name as asset_name, a.ticker_symbol FROM transactions t " +
                "JOIN assets a ON t.asset_id = a.asset_id " +
                "WHERE t.user_id = ? ORDER BY t.transaction_date DESC LIMIT ?";
        List<Transaction> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapTransaction(rs));
            }
        }
        return list;
    }

    private Transaction mapTransaction(ResultSet rs) throws SQLException {
        Transaction txn = new Transaction();
        txn.setTxnId(rs.getInt("txn_id"));
        txn.setAssetId(rs.getInt("asset_id"));
        txn.setUserId(rs.getInt("user_id"));
        txn.setType(rs.getString("type"));
        txn.setQuantity(rs.getBigDecimal("quantity"));
        txn.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
        txn.setTotalAmount(rs.getBigDecimal("total_amount"));
        txn.setCommission(rs.getBigDecimal("commission"));
        txn.setTransactionDate(rs.getDate("transaction_date"));
        txn.setStatus(rs.getString("status"));
        txn.setNotes(rs.getString("notes"));
        txn.setCreatedAt(rs.getTimestamp("created_at"));
        txn.setAssetName(rs.getString("asset_name"));
        txn.setTickerSymbol(rs.getString("ticker_symbol"));
        return txn;
    }
}
