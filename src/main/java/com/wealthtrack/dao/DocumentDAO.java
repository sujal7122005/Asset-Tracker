package com.wealthtrack.dao;

import com.wealthtrack.model.Document;
import com.wealthtrack.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {

    public boolean uploadDoc(Document doc) throws SQLException {
        String sql = "INSERT INTO documents (asset_id, user_id, file_name, file_path, file_size) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            if (doc.getAssetId() > 0) {
                ps.setInt(1, doc.getAssetId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setInt(2, doc.getUserId());
            ps.setString(3, doc.getFileName());
            ps.setString(4, doc.getFilePath());
            ps.setLong(5, doc.getFileSize());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Document> getDocsByUser(int userId) throws SQLException {
        String sql = "SELECT d.*, a.name as asset_name FROM documents d " +
                "LEFT JOIN assets a ON d.asset_id = a.asset_id " +
                "WHERE d.user_id = ? ORDER BY d.upload_date DESC";
        List<Document> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapDocument(rs));
            }
        }
        return list;
    }

    public List<Document> getDocsByAsset(int assetId) throws SQLException {
        String sql = "SELECT d.*, a.name as asset_name FROM documents d " +
                "LEFT JOIN assets a ON d.asset_id = a.asset_id " +
                "WHERE d.asset_id = ? ORDER BY d.upload_date DESC";
        List<Document> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assetId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapDocument(rs));
            }
        }
        return list;
    }

    public boolean deleteDoc(int docId) throws SQLException {
        String sql = "DELETE FROM documents WHERE doc_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, docId);
            return ps.executeUpdate() > 0;
        }
    }

    private Document mapDocument(ResultSet rs) throws SQLException {
        Document doc = new Document();
        doc.setDocId(rs.getInt("doc_id"));
        doc.setAssetId(rs.getInt("asset_id"));
        doc.setUserId(rs.getInt("user_id"));
        doc.setFileName(rs.getString("file_name"));
        doc.setFilePath(rs.getString("file_path"));
        doc.setFileSize(rs.getLong("file_size"));
        doc.setUploadDate(rs.getTimestamp("upload_date"));
        doc.setAssetName(rs.getString("asset_name"));
        return doc;
    }
}
