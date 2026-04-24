package com.experiment10.dao;

import com.experiment10.model.AssetCategory;
import com.experiment10.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AssetCategoryDAO {

    public List<AssetCategory> findAll() throws SQLException {
        String sql = "SELECT category_id, category_name, icon_class, color_code, created_at FROM asset_categories ORDER BY category_id";
        List<AssetCategory> categories = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                categories.add(mapRow(resultSet));
            }
        }

        return categories;
    }

    public boolean insert(AssetCategory category) throws SQLException {
        String sql = "INSERT INTO asset_categories (category_name, icon_class, color_code) VALUES (?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, category.getCategoryName());
            statement.setString(2, category.getIconClass());
            statement.setString(3, category.getColorCode());
            return statement.executeUpdate() > 0;
        }
    }

    public boolean update(AssetCategory category) throws SQLException {
        String sql = "UPDATE asset_categories SET category_name = ?, icon_class = ?, color_code = ? WHERE category_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, category.getCategoryName());
            statement.setString(2, category.getIconClass());
            statement.setString(3, category.getColorCode());
            statement.setInt(4, category.getCategoryId());
            return statement.executeUpdate() > 0;
        }
    }

    public boolean delete(int categoryId) throws SQLException {
        String sql = "DELETE FROM asset_categories WHERE category_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, categoryId);
            return statement.executeUpdate() > 0;
        }
    }

    private AssetCategory mapRow(ResultSet resultSet) throws SQLException {
        AssetCategory category = new AssetCategory();
        category.setCategoryId(resultSet.getInt("category_id"));
        category.setCategoryName(resultSet.getString("category_name"));
        category.setIconClass(resultSet.getString("icon_class"));
        category.setColorCode(resultSet.getString("color_code"));
        category.setCreatedAt(resultSet.getTimestamp("created_at"));
        return category;
    }
}
