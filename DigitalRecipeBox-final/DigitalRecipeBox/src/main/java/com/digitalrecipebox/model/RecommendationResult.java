package com.digitalrecipebox.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * RecommendationResult DTO
 * Represents a recipe match recommendation based on available ingredients algorithm.
 */
public class RecommendationResult implements Serializable, Comparable<RecommendationResult> {
    private static final long serialVersionUID = 1L;

    private Recipe recipe;
    private double matchPercentage;
    private List<String> availableIngredients = new ArrayList<>();
    private List<String> missingIngredients = new ArrayList<>();
    private int matchCount;
    private int totalRecipeIngredientsCount;

    public RecommendationResult() {}

    public RecommendationResult(Recipe recipe, double matchPercentage, List<String> availableIngredients,
                                List<String> missingIngredients, int matchCount, int totalRecipeIngredientsCount) {
        this.recipe = recipe;
        this.matchPercentage = matchPercentage;
        this.availableIngredients = availableIngredients;
        this.missingIngredients = missingIngredients;
        this.matchCount = matchCount;
        this.totalRecipeIngredientsCount = totalRecipeIngredientsCount;
    }

    public Recipe getRecipe() { return recipe; }
    public void setRecipe(Recipe recipe) { this.recipe = recipe; }

    public double getMatchPercentage() { return matchPercentage; }
    public void setMatchPercentage(double matchPercentage) { this.matchPercentage = matchPercentage; }

    public List<String> getAvailableIngredients() { return availableIngredients; }
    public void setAvailableIngredients(List<String> availableIngredients) { this.availableIngredients = availableIngredients; }

    public List<String> getMissingIngredients() { return missingIngredients; }
    public void setMissingIngredients(List<String> missingIngredients) { this.missingIngredients = missingIngredients; }

    public int getMatchCount() { return matchCount; }
    public void setMatchCount(int matchCount) { this.matchCount = matchCount; }

    public int getTotalRecipeIngredientsCount() { return totalRecipeIngredientsCount; }
    public void setTotalRecipeIngredientsCount(int totalRecipeIngredientsCount) { this.totalRecipeIngredientsCount = totalRecipeIngredientsCount; }

    @Override
    public int compareTo(RecommendationResult o) {
        return Double.compare(o.matchPercentage, this.matchPercentage); // Descending match %
    }
}
