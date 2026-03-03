package com.wealthtrack.dao;

import com.wealthtrack.model.ActivityLog;
import com.wealthtrack.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActivityLogDAO {

    public boolean logActivity(ActivityLog log) throws SQLException {
        String sql = "INSERT INTO activity_log (user_id, action_type, description, amount) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, log.getUserId());
            ps.setString(2, log.getActionType());
            ps.setString(3, log.getDescription());
            if (log.getAmount() != null) {
                ps.setBigDecimal(4, log.getAmount());
            } else {
                ps.setNull(4, Types.DECIMAL);
            }
            return ps.executeUpdate() > 0;
        }
    }

    public List<ActivityLog> getRecentActivity(int userId, int limit) throws SQLException {
        String sql = "SELECT * FROM activity_log WHERE user_id = ? ORDER BY timestamp DESC LIMIT ?";
        List<ActivityLog> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ActivityLog log = new ActivityLog();
                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getInt("user_id"));
                log.setActionType(rs.getString("action_type"));
                log.setDescription(rs.getString("description"));
                log.setAmount(rs.getBigDecimal("amount"));
                log.setTimestamp(rs.getTimestamp("timestamp"));
                list.add(log);
            }
        }
        return list;
    }
}
