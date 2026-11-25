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
 * AddRecipeServlet
 * Displays add recipe form and saves new recipes with nutrition values into MySQL.
 */
@WebServlet("/add-recipe")
public class AddRecipeServlet extends HttpServlet {
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
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/add-recipe.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String ingredients = request.getParameter("ingredients");
            String instructions = request.getParameter("instructions");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int prepTimeMins = parseSafeInt(request.getParameter("prepTimeMins"), 10);
            int cookTimeMins = parseSafeInt(request.getParameter("cookTimeMins"), 20);
            int servings = parseSafeInt(request.getParameter("servings"), 2);
            String difficulty = request.getParameter("difficulty");
            String imageUrl = request.getParameter("imageUrl");

            // Nutrition Facts
            int calories = parseSafeInt(request.getParameter("calories"), 300);
            double proteinG = parseSafeDouble(request.getParameter("proteinG"), 10.0);
            double carbsG = parseSafeDouble(request.getParameter("carbsG"), 40.0);
            double fatG = parseSafeDouble(request.getParameter("fatG"), 10.0);

            if (name == null || name.trim().isEmpty() ||
                ingredients == null || ingredients.trim().isEmpty() ||
                instructions == null || instructions.trim().isEmpty()) {

                request.setAttribute("errorMessage", "Recipe Name, Ingredients, and Preparation Steps are required.");
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.getRequestDispatcher("/add-recipe.jsp").forward(request, response);
                return;
            }

            Recipe recipe = new Recipe();
            recipe.setUserId(user.getId());
            recipe.setCategoryId(categoryId);
            recipe.setName(name.trim());
            recipe.setDescription(description != null ? description.trim() : "");
            recipe.setIngredients(ingredients.trim());
            recipe.setInstructions(instructions.trim());
            recipe.setPrepTimeMins(prepTimeMins);
            recipe.setCookTimeMins(cookTimeMins);
            recipe.setServings(servings);
            recipe.setDifficulty(difficulty != null ? difficulty : "Medium");
            recipe.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
            recipe.setCalories(calories);
            recipe.setProteinG(proteinG);
            recipe.setCarbsG(carbsG);
            recipe.setFatG(fatG);

            int recipeId = recipeDAO.addRecipe(recipe);
            if (recipeId > 0) {
                response.sendRedirect(request.getContextPath() + "/recipe?id=" + recipeId + "&msg=added");
            } else {
                request.setAttribute("errorMessage", "Failed to add recipe to database. Please check your inputs.");
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.getRequestDispatcher("/add-recipe.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing recipe form: " + e.getMessage());
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/add-recipe.jsp").forward(request, response);
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
