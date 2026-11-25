package com.digitalrecipebox.dao;

import com.digitalrecipebox.model.Recipe;
import com.digitalrecipebox.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Recipe DAO
 * Performs full CRUD, search, filtering, and database operations for recipes using JDBC PreparedStatements.
 */
public class RecipeDAO {

    public int addRecipe(Recipe recipe) {
        String sql = "INSERT INTO recipes (user_id, category_id, name, description, ingredients, instructions, " +
                     "prep_time_mins, cook_time_mins, servings, difficulty, image_url, calories, protein_g, carbs_g, fat_g) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, recipe.getUserId());
            pstmt.setInt(2, recipe.getCategoryId());
            pstmt.setString(3, recipe.getName());
            pstmt.setString(4, recipe.getDescription());
            pstmt.setString(5, recipe.getIngredients());
            pstmt.setString(6, recipe.getInstructions());
            pstmt.setInt(7, recipe.getPrepTimeMins());
            pstmt.setInt(8, recipe.getCookTimeMins());
            pstmt.setInt(9, recipe.getServings());
            pstmt.setString(10, recipe.getDifficulty());
            pstmt.setString(11, recipe.getImageUrl());
            pstmt.setInt(12, recipe.getCalories());
            pstmt.setDouble(13, recipe.getProteinG());
            pstmt.setDouble(14, recipe.getCarbsG());
            pstmt.setDouble(15, recipe.getFatG());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, pstmt, conn);
        }
        return -1;
    }

    public boolean updateRecipe(Recipe recipe) {
        String sql = "UPDATE recipes SET category_id = ?, name = ?, description = ?, ingredients = ?, instructions = ?, " +
                     "prep_time_mins = ?, cook_time_mins = ?, servings = ?, difficulty = ?, image_url = ?, " +
                     "calories = ?, protein_g = ?, carbs_g = ?, fat_g = ? WHERE id = ? AND user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recipe.getCategoryId());
            pstmt.setString(2, recipe.getName());
            pstmt.setString(3, recipe.getDescription());
            pstmt.setString(4, recipe.getIngredients());
            pstmt.setString(5, recipe.getInstructions());
            pstmt.setInt(6, recipe.getPrepTimeMins());
            pstmt.setInt(7, recipe.getCookTimeMins());
            pstmt.setInt(8, recipe.getServings());
            pstmt.setString(9, recipe.getDifficulty());
            pstmt.setString(10, recipe.getImageUrl());
            pstmt.setInt(11, recipe.getCalories());
            pstmt.setDouble(12, recipe.getProteinG());
            pstmt.setDouble(13, recipe.getCarbsG());
            pstmt.setDouble(14, recipe.getFatG());
            pstmt.setInt(15, recipe.getId());
            pstmt.setInt(16, recipe.getUserId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(pstmt, conn);
        }
        return false;
    }

    public boolean deleteRecipe(int recipeId, int userId) {
        String sql = "DELETE FROM recipes WHERE id = ? AND user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recipeId);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(pstmt, conn);
        }
        return false;
    }

    public Recipe getRecipeById(int recipeId) {
        String sql = "SELECT r.*, c.name AS category_name FROM recipes r " +
                     "LEFT JOIN categories c ON r.category_id = c.id WHERE r.id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recipeId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapRecipe(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, pstmt, conn);
        }
        return null;
    }

    public List<Recipe> getAllRecipes(int userId, String search, String categoryId, String difficulty, Integer maxCookTime, String sortBy) {
        return getAllRecipes(userId, search, categoryId, difficulty, maxCookTime, sortBy, false);
    }

    public List<Recipe> getAllRecipes(int userId, String search, String categoryId, String difficulty,
                                      Integer maxCookTime, String sortBy, boolean admin) {
        List<Recipe> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT r.*, c.name AS category_name FROM recipes r " +
                                              "LEFT JOIN categories c ON r.category_id = c.id WHERE ");

        List<Object> params = new ArrayList<>();
        if (admin) {
            sql.append("1=1 ");
        } else {
            sql.append("(r.user_id = ? OR r.user_id = 1) ");
            params.add(userId);
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(r.name) LIKE ? OR LOWER(r.ingredients) LIKE ? OR LOWER(r.description) LIKE ?) ");
            String term = "%" + search.trim().toLowerCase() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }

        if (categoryId != null && !categoryId.trim().isEmpty() && !categoryId.equalsIgnoreCase("all")) {
            sql.append("AND r.category_id = ? ");
            params.add(Integer.parseInt(categoryId));
        }

        if (difficulty != null && !difficulty.trim().isEmpty() && !difficulty.equalsIgnoreCase("all")) {
            sql.append("AND r.difficulty = ? ");
            params.add(difficulty);
        }

        if (maxCookTime != null && maxCookTime > 0) {
            sql.append("AND (r.prep_time_mins + r.cook_time_mins) <= ? ");
            params.add(maxCookTime);
        }

        if ("name_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY r.name ASC");
        } else if ("time_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY (r.prep_time_mins + r.cook_time_mins) ASC");
        } else if ("calories_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY r.calories ASC");
        } else {
            sql.append("ORDER BY r.created_at DESC");
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(mapRecipe(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, pstmt, conn);
        }
        return list;
    }

    public List<Recipe> getRecentRecipes(int userId, int limit) {
        return getRecentRecipes(userId, limit, false);
    }

    public List<Recipe> getRecentRecipes(int userId, int limit, boolean admin) {
        List<Recipe> list = new ArrayList<>();
        String sql = admin
                ? "SELECT r.*, c.name AS category_name FROM recipes r " +
                  "LEFT JOIN categories c ON r.category_id = c.id ORDER BY r.created_at DESC LIMIT ?"
                : "SELECT r.*, c.name AS category_name FROM recipes r " +
                  "LEFT JOIN categories c ON r.category_id = c.id " +
                  "WHERE (r.user_id = ? OR r.user_id = 1) ORDER BY r.created_at DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            if (admin) {
                pstmt.setInt(1, limit);
            } else {
                pstmt.setInt(1, userId);
                pstmt.setInt(2, limit);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(mapRecipe(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, pstmt, conn);
        }
        return list;
    }

    public int getTotalRecipeCount(int userId) {
        return getTotalRecipeCount(userId, false);
    }

    public int getTotalRecipeCount(int userId, boolean admin) {
        String sql = "SELECT COUNT(*) FROM recipes WHERE user_id = ? OR user_id = 1";
        if (admin) {
            sql = "SELECT COUNT(*) FROM recipes";
        }
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            if (!admin) {
                pstmt.setInt(1, userId);
            }
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

    public List<Recipe> getAllPublicAndUserRecipes(int userId) {
        return getAllRecipes(userId, null, null, null, null, "newest", false);
    }

    public List<Recipe> getAllPublicAndUserRecipes(int userId, boolean admin) {
        return getAllRecipes(userId, null, null, null, null, "newest", admin);
    }

    private Recipe mapRecipe(ResultSet rs) throws SQLException {
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
        return recipe;
    }
}
