package com.digitalrecipebox.util;

import java.io.File;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * DBConnection Utility
 * Loads database configuration from db.properties and manages JDBC connections.
 * Connects to MySQL when available and automatically falls back to an embedded
 * H2 database (in MySQL compatibility mode) when a local MySQL server is offline.
 */
public class DBConnection {

    private static String dbDriver = "com.mysql.cj.jdbc.Driver";
    private static String dbUrl = "jdbc:mysql://localhost:3306/digital_recipe_box?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static String dbUser = "root";
    private static String dbPassword = "root";

    private static volatile boolean initialized = false;
    private static volatile boolean usingH2Fallback = false;
    private static String h2Url;

    static {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                Properties prop = new Properties();
                prop.load(input);
                if (prop.getProperty("db.driver") != null) dbDriver = prop.getProperty("db.driver").trim();
                if (prop.getProperty("db.url") != null) dbUrl = prop.getProperty("db.url").trim();
                if (prop.getProperty("db.user") != null) dbUser = prop.getProperty("db.user").trim();
                if (prop.getProperty("db.password") != null) dbPassword = prop.getProperty("db.password").trim();
            }
            Class.forName(dbDriver);
        } catch (Exception e) {
            System.err.println("[DBConnection] Initialization Warning: " + e.getMessage());
        }

        String dataDir = System.getProperty("user.home") + File.separator + ".recipebox" + File.separator + "data";
        new File(dataDir).mkdirs();
        String dbFilePath = new File(dataDir, "digital_recipe_box").getAbsolutePath().replace("\\", "/");
        h2Url = "jdbc:h2:file:" + dbFilePath
                + ";MODE=MySQL;DATABASE_TO_LOWER=TRUE;CASE_INSENSITIVE_IDENTIFIERS=TRUE;DB_CLOSE_DELAY=-1";
    }

    /**
     * Ensures the active database backend is selected, schema exists, and seed data is loaded.
     */
    public static void ensureInitialized() {
        if (initialized) {
            return;
        }
        synchronized (DBConnection.class) {
            if (initialized) {
                return;
            }
            // Try MySQL first with a fast connection timeout
            String probeUrl = dbUrl.contains("connectTimeout=")
                    ? dbUrl
                    : dbUrl + (dbUrl.contains("?") ? "&" : "?") + "connectTimeout=2000&socketTimeout=5000";

            try (Connection mysqlConn = DriverManager.getConnection(probeUrl, dbUser, dbPassword)) {
                usingH2Fallback = false;
                DatabaseInitializer.ensureSchemaAndSeed(mysqlConn, false);
                System.out.println("[DBConnection] Connected to MySQL database.");
                initialized = true;
                return;
            } catch (SQLException mysqlEx) {
                System.err.println("[DBConnection] MySQL unavailable (" + mysqlEx.getMessage()
                        + "). Switching to embedded H2 database (MySQL compatibility mode).");
            }

            try {
                Class.forName("org.h2.Driver");
                try (Connection h2Conn = DriverManager.getConnection(h2Url, "sa", "")) {
                    usingH2Fallback = true;
                    DatabaseInitializer.ensureSchemaAndSeed(h2Conn, true);
                    System.out.println("[DBConnection] Embedded H2 database initialized at: " + h2Url);
                    initialized = true;
                }
            } catch (Exception h2Ex) {
                throw new RuntimeException("Failed to initialize database connection", h2Ex);
            }
        }
    }

    /**
     * Gets a new JDBC connection from the active backend (MySQL or H2 fallback).
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        ensureInitialized();
        if (usingH2Fallback) {
            return DriverManager.getConnection(h2Url, "sa", "");
        }
        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }

    public static boolean isUsingH2Fallback() {
        ensureInitialized();
        return usingH2Fallback;
    }

    /**
     * Safely closes AutoCloseable resources.
     */
    public static void closeQuietly(AutoCloseable... resources) {
        for (AutoCloseable res : resources) {
            if (res != null) {
                try {
                    res.close();
                } catch (Exception ignored) {}
            }
        }
    }
}
