package com.digitalrecipebox.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Favorite Entity Model
 * Links users to their favorited recipes.
 */
public class Favorite implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private int recipeId;
    private Recipe recipe;
    private Timestamp createdAt;

    public Favorite() {}

    public Favorite(int id, int userId, int recipeId, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.recipeId = recipeId;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRecipeId() { return recipeId; }
    public void setRecipeId(int recipeId) { this.recipeId = recipeId; }

    public Recipe getRecipe() { return recipe; }
    public void setRecipe(Recipe recipe) { this.recipe = recipe; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
