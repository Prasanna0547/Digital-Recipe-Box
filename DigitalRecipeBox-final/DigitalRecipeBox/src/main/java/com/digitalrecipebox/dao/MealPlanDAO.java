package com.digitalrecipebox.dao;

import com.digitalrecipebox.model.MealPlan;
import com.digitalrecipebox.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * MealPlan DAO
 * Manages daily/weekly meal scheduling for breakfast, lunch, dinner, and snacks.
 */
public class MealPlanDAO {

    public int addMealPlan(MealPlan plan) {
        String sql = "INSERT INTO meal_plans (user_id, recipe_id, meal_date, meal_type) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, plan.getUserId());
            pstmt.setInt(2, plan.getRecipeId());
            pstmt.setDate(3, plan.getMealDate());
            pstmt.setString(4, plan.getMealType());

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

    public boolean deleteMealPlan(int planId, int userId) {
        String sql = "DELETE FROM meal_plans WHERE id = ? AND user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, planId);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(pstmt, conn);
        }
        return false;
    }

    public List<MealPlan> getMealPlansForUser(int userId) {
        List<MealPlan> list = new ArrayList<>();
        String sql = "SELECT mp.*, r.name AS recipe_name, r.image_url, r.prep_time_mins, r.cook_time_mins, r.calories " +
                     "FROM meal_plans mp " +
                     "INNER JOIN recipes r ON mp.recipe_id = r.id " +
                     "WHERE mp.user_id = ? ORDER BY mp.meal_date ASC, " +
                     "CASE mp.meal_type WHEN 'Breakfast' THEN 1 WHEN 'Lunch' THEN 2 WHEN 'Dinner' THEN 3 WHEN 'Snack' THEN 4 ELSE 5 END";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                MealPlan plan = new MealPlan();
                plan.setId(rs.getInt("id"));
                plan.setUserId(rs.getInt("user_id"));
                plan.setRecipeId(rs.getInt("recipe_id"));
                plan.setMealDate(rs.getDate("meal_date"));
                plan.setMealType(rs.getString("meal_type"));
                plan.setRecipeName(rs.getString("recipe_name"));
                plan.setRecipeImageUrl(rs.getString("image_url"));
                plan.setPrepTimeMins(rs.getInt("prep_time_mins"));
                plan.setCookTimeMins(rs.getInt("cook_time_mins"));
                plan.setCalories(rs.getInt("calories"));
                list.add(plan);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeQuietly(rs, pstmt, conn);
        }
        return list;
    }

    public int getMealPlanCount(int userId) {
        String sql = "SELECT COUNT(*) FROM meal_plans WHERE user_id = ?";
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
