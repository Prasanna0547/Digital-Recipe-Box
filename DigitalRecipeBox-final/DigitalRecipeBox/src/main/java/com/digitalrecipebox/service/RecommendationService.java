package com.digitalrecipebox.service;

import com.digitalrecipebox.dao.RecipeDAO;
import com.digitalrecipebox.model.Recipe;
import com.digitalrecipebox.model.RecommendationResult;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Recommendation Service
 * Implements practical ingredient-matching recommendation algorithm for the Digital Recipe Box mini project.
 */
public class RecommendationService {

    private final RecipeDAO recipeDAO;

    public RecommendationService() {
        this.recipeDAO = new RecipeDAO();
    }

    public RecommendationService(RecipeDAO recipeDAO) {
        this.recipeDAO = recipeDAO;
    }

    /**
     * Recommends recipes based on user's available ingredients.
     * @param inputIngredients comma or space separated string of available ingredients (e.g. "rice, tomato, onion, egg")
     * @param userId logged in user ID
     * @return sorted list of RecommendationResult objects
     */
    public List<RecommendationResult> getRecommendations(String inputIngredients, int userId) {
        return getRecommendations(inputIngredients, userId, false);
    }

    public List<RecommendationResult> getRecommendations(String inputIngredients, int userId, boolean admin) {
        if (inputIngredients == null || inputIngredients.trim().isEmpty()) {
            return Collections.emptyList();
        }

        // 1. Tokenize user input ingredients
        Set<String> userIngredientSet = parseTokens(inputIngredients);

        if (userIngredientSet.isEmpty()) {
            return Collections.emptyList();
        }

        // 2. Fetch all candidate recipes visible to user
        List<Recipe> allRecipes = recipeDAO.getAllPublicAndUserRecipes(userId, admin);
        List<RecommendationResult> results = new ArrayList<>();

        // 3. Perform fuzzy/token ingredient matching for each recipe
        for (Recipe recipe : allRecipes) {
            String recipeIngText = recipe.getIngredients();
            if (recipeIngText == null || recipeIngText.trim().isEmpty()) {
                continue;
            }

            // Split recipe ingredients into clean individual item names
            List<String> rawRecipeItems = Arrays.stream(recipeIngText.split("[,\\n]+"))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .collect(Collectors.toList());

            if (rawRecipeItems.isEmpty()) continue;

            List<String> matched = new ArrayList<>();
            List<String> missing = new ArrayList<>();

            for (String rawItem : rawRecipeItems) {
                String cleanItemLower = rawItem.toLowerCase();
                boolean isMatched = false;

                for (String userIng : userIngredientSet) {
                    // Check if user ingredient matches the recipe item token (e.g., "rice" in "basmati rice")
                    if (cleanItemLower.contains(userIng) || userIng.contains(cleanItemLower)) {
                        isMatched = true;
                        break;
                    }
                }

                if (isMatched) {
                    matched.add(rawItem);
                } else {
                    missing.add(rawItem);
                }
            }

            int totalCount = rawRecipeItems.size();
            int matchCount = matched.size();

            if (matchCount > 0) {
                double percentage = Math.round(((double) matchCount / totalCount * 100.0) * 10.0) / 10.0;
                results.add(new RecommendationResult(
                        recipe,
                        percentage,
                        matched,
                        missing,
                        matchCount,
                        totalCount
                ));
            }
        }

        // 4. Sort recommendations by match percentage descending
        Collections.sort(results);
        return results;
    }

    private Set<String> parseTokens(String input) {
        Set<String> tokens = new HashSet<>();
        String[] parts = input.toLowerCase().split("[,;\\n]+");
        for (String p : parts) {
            String trimmed = p.trim();
            // strip numbers, quantities like "2 cups" -> "cups" -> ignore stop words if needed
            trimmed = trimmed.replaceAll("^[0-9/\\s]+", "").trim();
            if (trimmed.length() >= 2) {
                tokens.add(trimmed);
            }
        }
        return tokens;
    }
}
