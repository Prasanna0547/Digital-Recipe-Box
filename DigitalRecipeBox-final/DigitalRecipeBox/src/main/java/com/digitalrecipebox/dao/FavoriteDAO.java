package com.digitalrecipebox.dao;

import com.digitalrecipebox.model.Recipe;
import com.digitalrecipebox.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Favorite DAO
 * Manages favoriting and unfavoriting recipes for users.
 */
public class FavoriteDAO {

    public boolean addFavorite(int userId, int recipeId) {
        if (isFavorite(userId, recipeId)) {
            return true;
        }
        String sql = "INSERT INTO favorites (user_id, recipe_id) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, recipeId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(pstmt, conn);
        }
        return false;
    }

    public boolean removeFavorite(int userId, int recipeId) {
        String sql = "DELETE FROM favorites WHERE user_id = ? AND recipe_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, recipeId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(pstmt, conn);
        }
        return false;
    }

    public boolean isFavorite(int userId, int recipeId) {
        String sql = "SELECT id FROM favorites WHERE user_id = ? AND recipe_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, recipeId);
            rs = pstmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, pstmt, conn);
        }
        return false;
    }

    public List<Recipe> getFavoriteRecipes(int userId) {
        List<Recipe> list = new ArrayList<>();
        String sql = "SELECT r.*, c.name AS category_name FROM recipes r " +
                     "INNER JOIN favorites f ON r.id = f.recipe_id " +
                     "LEFT JOIN categories c ON r.category_id = c.id " +
                     "WHERE f.user_id = ? ORDER BY f.created_at DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Recipe recipe = new Recipe();
                recipe.setId(rs.getInt("id"));
                recipe.setUserId(rs.getInt("user_id"));
                recipe.setCategoryId(rs.getInt("category_id"));
                recipe.setCategoryName(rs.getString("category_name"));
                recipe.setName(rs.getString("name"));
                recipe.setDescription(rs.getString("description"));
                recipe.setIngredients(rs.getString("ingredients"));
                recipe.setInstructions(rs.getString("instructions"));
                recipe.setPrepTimeMins(rs.getInt("prep_time_mins"));
                recipe.setCookTimeMins(rs.getInt("cook_time_mins"));
                recipe.setServings(rs.getInt("servings"));
                recipe.setDifficulty(rs.getString("difficulty"));
                recipe.setImageUrl(rs.getString("image_url"));
                recipe.setCalories(rs.getInt("calories"));
                recipe.setProteinG(rs.getDouble("protein_g"));
                recipe.setCarbsG(rs.getDouble("carbs_g"));
                recipe.setFatG(rs.getDouble("fat_g"));
                recipe.setCreatedAt(rs.getTimestamp("created_at"));
                recipe.setFavorite(true);
                list.add(recipe);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, pstmt, conn);
        }
        return list;
    }

    public int getFavoriteCount(int userId) {
        String sql = "SELECT COUNT(*) FROM favorites WHERE user_id = ?";
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
