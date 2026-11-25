package com.digitalrecipebox.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * ShoppingItem Entity Model
 * Stores generated or custom items in the user's shopping list.
 */
public class ShoppingItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String ingredientName;
    private String recipeSource;
    private boolean purchased;
    private Timestamp createdAt;

    public ShoppingItem() {}

    public ShoppingItem(int id, int userId, String ingredientName, String recipeSource, boolean purchased, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.ingredientName = ingredientName;
        this.recipeSource = recipeSource;
        this.purchased = purchased;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getIngredientName() { return ingredientName; }
    public void setIngredientName(String ingredientName) { this.ingredientName = ingredientName; }

    public String getRecipeSource() { return recipeSource; }
    public void setRecipeSource(String recipeSource) { this.recipeSource = recipeSource; }

    public boolean isPurchased() { return purchased; }
    public void setPurchased(boolean purchased) { this.purchased = purchased; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
