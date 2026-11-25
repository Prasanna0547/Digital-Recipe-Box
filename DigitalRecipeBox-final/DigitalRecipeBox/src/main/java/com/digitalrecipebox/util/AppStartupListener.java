package com.digitalrecipebox.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * AppStartupListener
 * Ensures database schema and initial sample data are ready when the application starts.
 */
@WebListener
public class AppStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            DBConnection.ensureInitialized();
        } catch (Exception e) {
            System.err.println("[AppStartupListener] Failed to initialize database: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
