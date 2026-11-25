package com.digitalrecipebox.controller;

import com.digitalrecipebox.dao.CategoryDAO;
import com.digitalrecipebox.dao.RecipeDAO;
import com.digitalrecipebox.model.Category;
import com.digitalrecipebox.model.Recipe;
import com.digitalrecipebox.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * EditRecipeServlet
 * Allows recipe owners to modify recipe ingredients, steps, category, timings, and nutrition values.
 */
@WebServlet("/edit-recipe")
public class EditRecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RecipeDAO recipeDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        recipeDAO = new RecipeDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/recipes");
            return;
        }

        try {
            int recipeId = Integer.parseInt(idStr);
            Recipe recipe = recipeDAO.getRecipeById(recipeId);

            if (recipe == null) {
                request.setAttribute("errorMessage", "Recipe not found.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Authorization Check: Only owner or demo user (if original sample) can edit
            if (!user.isAdmin() && recipe.getUserId() != user.getId() && recipe.getUserId() != 1) {
                request.setAttribute("errorMessage", "You are not authorized to edit this recipe.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("recipe", recipe);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/edit-recipe.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/recipes");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        try {
            int recipeId = Integer.parseInt(request.getParameter("id"));
            Recipe existingRecipe = recipeDAO.getRecipeById(recipeId);

            if (existingRecipe == null) {
                response.sendRedirect(request.getContextPath() + "/recipes");
                return;
            }

            if (!user.isAdmin() && existingRecipe.getUserId() != user.getId() && existingRecipe.getUserId() != 1) {
                request.setAttribute("errorMessage", "You are not authorized to edit this recipe.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String ingredients = request.getParameter("ingredients");
            String instructions = request.getParameter("instructions");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int prepTimeMins = parseSafeInt(request.getParameter("prepTimeMins"), existingRecipe.getPrepTimeMins());
            int cookTimeMins = parseSafeInt(request.getParameter("cookTimeMins"), existingRecipe.getCookTimeMins());
            int servings = parseSafeInt(request.getParameter("servings"), existingRecipe.getServings());
            String difficulty = request.getParameter("difficulty");
            String imageUrl = request.getParameter("imageUrl");

            int calories = parseSafeInt(request.getParameter("calories"), existingRecipe.getCalories());
            double proteinG = parseSafeDouble(request.getParameter("proteinG"), existingRecipe.getProteinG());
            double carbsG = parseSafeDouble(request.getParameter("carbsG"), existingRecipe.getCarbsG());
            double fatG = parseSafeDouble(request.getParameter("fatG"), existingRecipe.getFatG());

            existingRecipe.setCategoryId(categoryId);
            existingRecipe.setName(name.trim());
            existingRecipe.setDescription(description != null ? description.trim() : "");
            existingRecipe.setIngredients(ingredients.trim());
            existingRecipe.setInstructions(instructions.trim());
            existingRecipe.setPrepTimeMins(prepTimeMins);
            existingRecipe.setCookTimeMins(cookTimeMins);
            existingRecipe.setServings(servings);
            existingRecipe.setDifficulty(difficulty);
            existingRecipe.setImageUrl(imageUrl);
            existingRecipe.setCalories(calories);
            existingRecipe.setProteinG(proteinG);
            existingRecipe.setCarbsG(carbsG);
            existingRecipe.setFatG(fatG);
            
            // Owners retain their recipes; admins may edit without changing ownership.
            if (!user.isAdmin() && existingRecipe.getUserId() != user.getId()) {
                existingRecipe.setUserId(user.getId());
            }

            boolean updated = recipeDAO.updateRecipe(existingRecipe);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/recipe?id=" + recipeId + "&msg=updated");
            } else {
                request.setAttribute("errorMessage", "Failed to update recipe in database.");
                request.setAttribute("recipe", existingRecipe);
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.getRequestDispatcher("/edit-recipe.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating recipe: " + e.getMessage());
            request.getRequestDispatcher("/recipes").forward(request, response);
        }
    }

    private int parseSafeInt(String val, int defaultVal) {
        if (val == null || val.trim().isEmpty()) return defaultVal;
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return defaultVal;
        }
    }

    private double parseSafeDouble(String val, double defaultVal) {
        if (val == null || val.trim().isEmpty()) return defaultVal;
        try {
            return Double.parseDouble(val.trim());
        } catch (Exception e) {
            return defaultVal;
        }
    }
}
