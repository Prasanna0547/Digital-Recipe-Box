package com.digitalrecipebox.controller;

import com.digitalrecipebox.dao.MealPlanDAO;
import com.digitalrecipebox.dao.RecipeDAO;
import com.digitalrecipebox.model.MealPlan;
import com.digitalrecipebox.model.Recipe;
import com.digitalrecipebox.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * MealPlanServlet
 * Handles weekly and daily meal planning for Breakfast, Lunch, Dinner, and Snacks.
 */
@WebServlet("/meal-planner")
public class MealPlanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MealPlanDAO mealPlanDAO;
    private RecipeDAO recipeDAO;

    @Override
    public void init() throws ServletException {
        mealPlanDAO = new MealPlanDAO();
        recipeDAO = new RecipeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        List<MealPlan> mealPlans = mealPlanDAO.getMealPlansForUser(userId);
        List<Recipe> recipes = recipeDAO.getAllPublicAndUserRecipes(userId);

        request.setAttribute("mealPlans", mealPlans);
        request.setAttribute("recipes", recipes);

        request.getRequestDispatcher("/meal-planner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        String action = request.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            String recipeIdStr = request.getParameter("recipeId");
            String mealDateStr = request.getParameter("mealDate");
            String mealType = request.getParameter("mealType");

            if (recipeIdStr != null && mealDateStr != null && mealType != null) {
                try {
                    int recipeId = Integer.parseInt(recipeIdStr);
                    Date mealDate = Date.valueOf(mealDateStr);

                    MealPlan plan = new MealPlan(0, userId, recipeId, mealDate, mealType);
                    mealPlanDAO.addMealPlan(plan);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String planIdStr = request.getParameter("planId");
            if (planIdStr != null) {
                try {
                    int planId = Integer.parseInt(planIdStr);
                    mealPlanDAO.deleteMealPlan(planId, userId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/meal-planner");
    }
}
