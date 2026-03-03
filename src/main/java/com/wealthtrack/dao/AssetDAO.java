package com.wealthtrack.dao;

import com.wealthtrack.model.Asset;
import com.wealthtrack.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AssetDAO {

    public boolean addAsset(Asset asset) throws SQLException {
        String sql = "INSERT INTO assets (user_id, name, ticker_symbol, category_id, current_price, purchase_price, quantity, purchase_date, commission, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, asset.getUserId());
            ps.setString(2, asset.getName());
            ps.setString(3, asset.getTickerSymbol());
            ps.setInt(4, asset.getCategoryId());
            ps.setBigDecimal(5, asset.getCurrentPrice());
            ps.setBigDecimal(6, asset.getPurchasePrice());
            ps.setBigDecimal(7, asset.getQuantity());
            ps.setDate(8, asset.getPurchaseDate());
            ps.setBigDecimal(9, asset.getCommission());
            ps.setString(10, asset.getNotes());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    asset.setAssetId(rs.getInt(1));
                }
                return true;
            }
            return false;
        }
    }

    public List<Asset> getAssetsByUser(int userId) throws SQLException {
        String sql = "SELECT a.*, ac.category_name FROM assets a " +
                "JOIN asset_categories ac ON a.category_id = ac.category_id " +
                "WHERE a.user_id = ? ORDER BY a.added_date DESC";
        List<Asset> assets = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                assets.add(mapAsset(rs));
            }
        }
        return assets;
    }

    public List<Asset> getAssetsByCategory(int userId, int categoryId) throws SQLException {
        String sql = "SELECT a.*, ac.category_name FROM assets a " +
                "JOIN asset_categories ac ON a.category_id = ac.category_id " +
                "WHERE a.user_id = ? AND a.category_id = ? ORDER BY a.added_date DESC";
        List<Asset> assets = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                assets.add(mapAsset(rs));
            }
        }
        return assets;
    }

    public Asset getAssetById(int assetId) throws SQLException {
        String sql = "SELECT a.*, ac.category_name FROM assets a " +
                "JOIN asset_categories ac ON a.category_id = ac.category_id " +
                "WHERE a.asset_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assetId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapAsset(rs);
            }
        }
        return null;
    }

    public boolean updateAsset(Asset asset) throws SQLException {
        String sql = "UPDATE assets SET name = ?, ticker_symbol = ?, category_id = ?, current_price = ?, purchase_price = ?, quantity = ?, purchase_date = ?, commission = ?, notes = ? WHERE asset_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, asset.getName());
            ps.setString(2, asset.getTickerSymbol());
            ps.setInt(3, asset.getCategoryId());
            ps.setBigDecimal(4, asset.getCurrentPrice());
            ps.setBigDecimal(5, asset.getPurchasePrice());
            ps.setBigDecimal(6, asset.getQuantity());
            ps.setDate(7, asset.getPurchaseDate());
            ps.setBigDecimal(8, asset.getCommission());
            ps.setString(9, asset.getNotes());
            ps.setInt(10, asset.getAssetId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteAsset(int assetId) throws SQLException {
        String sql = "DELETE FROM assets WHERE asset_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assetId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Asset> searchAssets(int userId, String keyword) throws SQLException {
        String sql = "SELECT a.*, ac.category_name FROM assets a " +
                "JOIN asset_categories ac ON a.category_id = ac.category_id " +
                "WHERE a.user_id = ? AND (a.name LIKE ? OR a.ticker_symbol LIKE ?) ORDER BY a.name";
        List<Asset> assets = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                assets.add(mapAsset(rs));
            }
        }
        return assets;
    }

    public int getAssetCount(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM assets WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public BigDecimal getTotalValueByCategory(int userId, String categoryName) throws SQLException {
        String sql = "SELECT COALESCE(SUM(a.current_price * ABS(a.quantity)), 0) as total FROM assets a " +
                "JOIN asset_categories ac ON a.category_id = ac.category_id " +
                "WHERE a.user_id = ? AND ac.category_name = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, categoryName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        }
        return BigDecimal.ZERO;
    }

    private Asset mapAsset(ResultSet rs) throws SQLException {
        Asset asset = new Asset();
        asset.setAssetId(rs.getInt("asset_id"));
        asset.setUserId(rs.getInt("user_id"));
        asset.setName(rs.getString("name"));
        asset.setTickerSymbol(rs.getString("ticker_symbol"));
        asset.setCategoryId(rs.getInt("category_id"));
        asset.setCategoryName(rs.getString("category_name"));
        asset.setCurrentPrice(rs.getBigDecimal("current_price"));
        asset.setPurchasePrice(rs.getBigDecimal("purchase_price"));
        asset.setQuantity(rs.getBigDecimal("quantity"));
        asset.setPurchaseDate(rs.getDate("purchase_date"));
        asset.setCommission(rs.getBigDecimal("commission"));
        asset.setNotes(rs.getString("notes"));
        asset.setAddedDate(rs.getTimestamp("added_date"));
        asset.setUpdatedAt(rs.getTimestamp("updated_at"));
        return asset;
    }
}
