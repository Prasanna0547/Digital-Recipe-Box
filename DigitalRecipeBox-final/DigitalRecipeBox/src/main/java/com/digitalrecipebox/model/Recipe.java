package com.digitalrecipebox.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Recipe Entity Model
 * Core model storing recipe details, nutrition facts, timings, and metadata.
 */
public class Recipe implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private int categoryId;
    private String categoryName;
    private String name;
    private String description;
    private String ingredients;
    private String instructions;
    private int prepTimeMins;
    private int cookTimeMins;
    private int servings;
    private String difficulty; // Easy, Medium, Hard
    private String imageUrl;
    private int calories;
    private double proteinG;
    private double carbsG;
    private double fatG;
    private Timestamp createdAt;
    private boolean isFavorite; // Transformed/computed field for convenient UI rendering

    public Recipe() {}

    public Recipe(int id, int userId, int categoryId, String name, String description,
                  String ingredients, String instructions, int prepTimeMins, int cookTimeMins,
                  int servings, String difficulty, String imageUrl, int calories,
                  double proteinG, double carbsG, double fatG, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.ingredients = ingredients;
        this.instructions = instructions;
        this.prepTimeMins = prepTimeMins;
        this.cookTimeMins = cookTimeMins;
        this.servings = servings;
        this.difficulty = difficulty;
        this.imageUrl = imageUrl;
        this.calories = calories;
        this.proteinG = proteinG;
        this.carbsG = carbsG;
        this.fatG = fatG;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIngredients() { return ingredients; }
    public void setIngredients(String ingredients) { this.ingredients = ingredients; }

    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }

    public int getPrepTimeMins() { return prepTimeMins; }
    public void setPrepTimeMins(int prepTimeMins) { this.prepTimeMins = prepTimeMins; }

    public int getCookTimeMins() { return cookTimeMins; }
    public void setCookTimeMins(int cookTimeMins) { this.cookTimeMins = cookTimeMins; }

    public int getTotalTimeMins() { return prepTimeMins + cookTimeMins; }

    public int getServings() { return servings; }
    public void setServings(int servings) { this.servings = servings; }

    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }

    public String getImageUrl() {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return "images/default-dish.svg";
        }
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getStepCount() {
        if (instructions == null || instructions.trim().isEmpty()) {
            return 0;
        }
        int count = 0;
        for (String line : instructions.split("\\R")) {
            if (!line.trim().isEmpty()) {
                count++;
            }
        }
        return count;
    }

    public int getCalories() { return calories; }
    public void setCalories(int calories) { this.calories = calories; }

    public double getProteinG() { return proteinG; }
    public void setProteinG(double proteinG) { this.proteinG = proteinG; }

    public double getCarbsG() { return carbsG; }
    public void setCarbsG(double carbsG) { this.carbsG = carbsG; }

    public double getFatG() { return fatG; }
    public void setFatG(double fatG) { this.fatG = fatG; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isFavorite() { return isFavorite; }
    public void setFavorite(boolean favorite) { isFavorite = favorite; }
}
