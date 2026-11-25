package com.digitalrecipebox.controller;

import com.digitalrecipebox.dao.CategoryDAO;
import com.digitalrecipebox.dao.FavoriteDAO;
import com.digitalrecipebox.dao.MealPlanDAO;
import com.digitalrecipebox.dao.RecipeDAO;
import com.digitalrecipebox.dao.ShoppingListDAO;
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
 * DashboardServlet
 * Aggregates statistics, recent recipes, and category summaries for the main dashboard view.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RecipeDAO recipeDAO;
    private MealPlanDAO mealPlanDAO;
    private ShoppingListDAO shoppingListDAO;
    private FavoriteDAO favoriteDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        recipeDAO = new RecipeDAO();
        mealPlanDAO = new MealPlanDAO();
        shoppingListDAO = new ShoppingListDAO();
        favoriteDAO = new FavoriteDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        // 1. Collect statistics
        int totalRecipes = recipeDAO.getTotalRecipeCount(userId, user.isAdmin());
        int totalMealPlans = mealPlanDAO.getMealPlanCount(userId);
        int pendingShoppingItems = shoppingListDAO.getPendingItemCount(userId);
        int totalFavorites = favoriteDAO.getFavoriteCount(userId);

        // 2. Collect recent recipes (limit 6)
        List<Recipe> recentRecipes = recipeDAO.getRecentRecipes(userId, 6, user.isAdmin());
        for (Recipe r : recentRecipes) {
            r.setFavorite(favoriteDAO.isFavorite(userId, r.getId()));
        }

        // 3. Categories
        List<Category> categories = categoryDAO.getAllCategories();

        // Attach data to request
        request.setAttribute("totalRecipes", totalRecipes);
        request.setAttribute("totalMealPlans", totalMealPlans);
        request.setAttribute("pendingShoppingItems", pendingShoppingItems);
        request.setAttribute("totalFavorites", totalFavorites);
        request.setAttribute("recentRecipes", recentRecipes);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
