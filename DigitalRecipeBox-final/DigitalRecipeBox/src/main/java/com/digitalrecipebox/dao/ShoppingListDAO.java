package com.digitalrecipebox.dao;

import com.digitalrecipebox.model.ShoppingItem;
import com.digitalrecipebox.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * ShoppingList DAO
 * Handles shopping items management and automatic ingredient collection from meal plans.
 */
public class ShoppingListDAO {

    public boolean addShoppingItem(ShoppingItem item) {
        String sql = "INSERT INTO shopping_lists (user_id, ingredient_name, recipe_source, is_purchased) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, item.getUserId());
            pstmt.setString(2, item.getIngredientName());
            pstmt.setString(3, item.getRecipeSource() != null ? item.getRecipeSource() : "");
            pstmt.setBoolean(4, item.isPurchased());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(pstmt, conn);
        }
        return false;
    }

    /**
     * Automatically collects ingredients from user's planned meals and generates a shopping list.
     * Parses ingredient text and prevents duplicate insertions.
     * @param userId user ID
     * @return number of new ingredients added
     */
    public int generateShoppingListFromMealPlans(int userId) {
        String queryMealPlanRecipes = "SELECT DISTINCT r.name AS recipe_name, r.ingredients " +
                                     "FROM meal_plans mp " +
                                     "INNER JOIN recipes r ON mp.recipe_id = r.id " +
                                     "WHERE mp.user_id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int addedCount = 0;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(queryMealPlanRecipes);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            // Fetch existing user items to prevent duplicates
            Set<String> existingItems = getExistingItemNames(conn, userId);

            String insertSql = "INSERT INTO shopping_lists (user_id, ingredient_name, recipe_source, is_purchased) VALUES (?, ?, ?, false)";
            PreparedStatement insertPstmt = conn.prepareStatement(insertSql);

            while (rs.next()) {
                String recipeName = rs.getString("recipe_name");
                String ingredientsStr = rs.getString("ingredients");

                if (ingredientsStr != null && !ingredientsStr.trim().isEmpty()) {
                    // Ingredients split by commas or newlines
                    String[] items = ingredientsStr.split("[,\\n]+");
                    for (String itemStr : items) {
                        String cleanIngredient = itemStr.trim();
                        if (cleanIngredient.length() > 1) {
                            String key = cleanIngredient.toLowerCase();
                            if (!existingItems.contains(key)) {
                                insertPstmt.setInt(1, userId);
                                insertPstmt.setString(2, cleanIngredient);
                                insertPstmt.setString(3, recipeName);
                                insertPstmt.addBatch();
                                existingItems.add(key);
                                addedCount++;
                            }
                        }
                    }
                }
            }

            if (addedCount > 0) {
                insertPstmt.executeBatch();
            }
            insertPstmt.close();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, pstmt, conn);
        }
        return addedCount;
    }

    private Set<String> getExistingItemNames(Connection conn, int userId) throws SQLException {
        Set<String> existing = new HashSet<>();
        String sql = "SELECT LOWER(ingredient_name) FROM shopping_lists WHERE user_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    existing.add(rs.getString(1));
                }
            }
        }
        return existing;
    }

    public List<ShoppingItem> getShoppingList(int userId) {
        List<ShoppingItem> list = new ArrayList<>();
        String sql = "SELECT * FROM shopping_lists WHERE user_id = ? ORDER BY is_purchased ASC, created_at DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ShoppingItem item = new ShoppingItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setIngredientName(rs.getString("ingredient_name"));
                item.setRecipeSource(rs.getString("recipe_source"));
                item.setPurchased(rs.getBoolean("is_purchased"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, pstmt, conn);
        }
        return list;
    }

    public boolean togglePurchased(int itemId, int userId, boolean purchased) {
        String sql = "UPDATE shopping_lists SET is_purchased = ? WHERE id = ? AND user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setBoolean(1, purchased);
            pstmt.setInt(2, itemId);
            pstmt.setInt(3, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(pstmt, conn);
        }
        return false;
    }

    public boolean deleteShoppingItem(int itemId, int userId) {
        String sql = "DELETE FROM shopping_lists WHERE id = ? AND user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, itemId);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(pstmt, conn);
        }
        return false;
    }

    public int clearCompleted(int userId) {
        String sql = "DELETE FROM shopping_lists WHERE user_id = ? AND is_purchased = true";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(pstmt, conn);
        }
        return 0;
    }

    public int clearAll(int userId) {
        String sql = "DELETE FROM shopping_lists WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(pstmt, conn);
        }
        return 0;
    }

    public int getPendingItemCount(int userId) {
        String sql = "SELECT COUNT(*) FROM shopping_lists WHERE user_id = ? AND is_purchased = false";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, pstmt, conn);
        }
        return 0;
    }
}
