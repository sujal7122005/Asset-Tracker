package com.experiment10.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBConnection {

    private static final String URL = getEnvOrDefault("WT_DB_URL", "jdbc:postgresql://localhost:5432/wealthtrack_exp10");
    private static final String USER = getEnvOrDefault("WT_DB_USER", "postgres");
    private static final String PASSWORD = getEnvOrDefault("WT_DB_PASSWORD", "admin");
    private static final String DRIVER = "org.postgresql.Driver";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("PostgreSQL JDBC driver not found.", e);
        }
    }

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private static String getEnvOrDefault(String key, String fallback) {
        String value = System.getenv(key);
        return value == null || value.isBlank() ? fallback : value;
    }
}
