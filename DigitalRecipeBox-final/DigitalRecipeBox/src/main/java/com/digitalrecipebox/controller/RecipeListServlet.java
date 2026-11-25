package com.digitalrecipebox.controller;

import com.digitalrecipebox.dao.CategoryDAO;
import com.digitalrecipebox.dao.FavoriteDAO;
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
 * RecipeListServlet
 * Handles recipe listing, search, category filtering, difficulty filtering, cooking time filtering, and sorting.
 */
@WebServlet("/recipes")
public class RecipeListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RecipeDAO recipeDAO;
    private CategoryDAO categoryDAO;
    private FavoriteDAO favoriteDAO;

    @Override
    public void init() throws ServletException {
        recipeDAO = new RecipeDAO();
        categoryDAO = new CategoryDAO();
        favoriteDAO = new FavoriteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        // Extract filter params
        String search = request.getParameter("search");
        String categoryId = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");
        String maxCookTimeStr = request.getParameter("maxTime");
        String sortBy = request.getParameter("sortBy");

        Integer maxCookTime = null;
        if (maxCookTimeStr != null && !maxCookTimeStr.trim().isEmpty()) {
            try {
                maxCookTime = Integer.parseInt(maxCookTimeStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Recipe> recipes = recipeDAO.getAllRecipes(userId, search, categoryId, difficulty, maxCookTime, sortBy,
                user.isAdmin());
        for (Recipe r : recipes) {
            r.setFavorite(favoriteDAO.isFavorite(userId, r.getId()));
        }

        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("recipes", recipes);
        request.setAttribute("categories", categories);
        request.setAttribute("paramSearch", search);
        request.setAttribute("paramCategory", categoryId);
        request.setAttribute("paramDifficulty", difficulty);
        request.setAttribute("paramMaxTime", maxCookTimeStr);
        request.setAttribute("paramSortBy", sortBy);

        request.getRequestDispatcher("/recipes.jsp").forward(request, response);
    }
}
