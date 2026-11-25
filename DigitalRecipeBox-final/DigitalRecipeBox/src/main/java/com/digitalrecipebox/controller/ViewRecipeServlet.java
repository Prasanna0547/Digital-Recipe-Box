package com.digitalrecipebox.controller;

import com.digitalrecipebox.dao.FavoriteDAO;
import com.digitalrecipebox.dao.RecipeDAO;
import com.digitalrecipebox.model.Recipe;
import com.digitalrecipebox.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * ViewRecipeServlet
 * Loads detailed recipe info, ingredients, step-by-step instructions, and nutrition facts.
 */
@WebServlet("/recipe")
public class ViewRecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RecipeDAO recipeDAO;
    private FavoriteDAO favoriteDAO;

    @Override
    public void init() throws ServletException {
        recipeDAO = new RecipeDAO();
        favoriteDAO = new FavoriteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                User user = (User) session.getAttribute("user");
                recipe.setFavorite(favoriteDAO.isFavorite(user.getId(), recipeId));
            }

            List<String> ingredientItems = new ArrayList<>();
            if (recipe.getIngredients() != null) {
                for (String item : recipe.getIngredients().split("[,\\r\\n]+")) {
                    String trimmed = item.trim();
                    if (!trimmed.isEmpty()) {
                        ingredientItems.add(trimmed);
                    }
                }
            }

            List<String> preparationSteps = new ArrayList<>();
            if (recipe.getInstructions() != null) {
                for (String line : recipe.getInstructions().split("\\R")) {
                    String step = line.replaceFirst("^\\s*\\d+[.)]?\\s*", "").trim();
                    if (!step.isEmpty()) {
                        preparationSteps.add(step);
                    }
                }
            }

            request.setAttribute("recipe", recipe);
            request.setAttribute("ingredientItems", ingredientItems);
            request.setAttribute("preparationSteps", preparationSteps);
            request.getRequestDispatcher("/recipe-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/recipes");
        }
    }
}
