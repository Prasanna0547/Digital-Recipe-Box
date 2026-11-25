package com.digitalrecipebox.model;

import java.io.Serializable;
import java.sql.Date;

/**
 * MealPlan Entity Model
 * Represents a scheduled meal on a specific date for a meal type (Breakfast, Lunch, Dinner, Snack).
 */
public class MealPlan implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private int recipeId;
    private Date mealDate;
    private String mealType; // Breakfast, Lunch, Dinner, Snack

    // Joined fields for display convenience
    private String recipeName;
    private String recipeImageUrl;
    private int prepTimeMins;
    private int cookTimeMins;
    private int calories;

    public MealPlan() {}

    public MealPlan(int id, int userId, int recipeId, Date mealDate, String mealType) {
        this.id = id;
        this.userId = userId;
        this.recipeId = recipeId;
        this.mealDate = mealDate;
        this.mealType = mealType;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRecipeId() { return recipeId; }
    public void setRecipeId(int recipeId) { this.recipeId = recipeId; }

    public Date getMealDate() { return mealDate; }
    public void setMealDate(Date mealDate) { this.mealDate = mealDate; }

    public String getMealType() { return mealType; }
    public void setMealType(String mealType) { this.mealType = mealType; }

    public String getRecipeName() { return recipeName; }
    public void setRecipeName(String recipeName) { this.recipeName = recipeName; }

    public String getRecipeImageUrl() { return recipeImageUrl; }
    public void setRecipeImageUrl(String recipeImageUrl) { this.recipeImageUrl = recipeImageUrl; }

    public int getPrepTimeMins() { return prepTimeMins; }
    public void setPrepTimeMins(int prepTimeMins) { this.prepTimeMins = prepTimeMins; }

    public int getCookTimeMins() { return cookTimeMins; }
    public void setCookTimeMins(int cookTimeMins) { this.cookTimeMins = cookTimeMins; }

    public int getCalories() { return calories; }
    public void setCalories(int calories) { this.calories = calories; }
}
