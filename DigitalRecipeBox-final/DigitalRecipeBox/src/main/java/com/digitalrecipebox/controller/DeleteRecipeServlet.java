package com.digitalrecipebox.controller;

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

/**
 * DeleteRecipeServlet
 * Deletes a recipe for its owner or an administrator.
 */
@WebServlet("/delete-recipe")
public class DeleteRecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RecipeDAO recipeDAO;

    @Override
    public void init() throws ServletException {
        recipeDAO = new RecipeDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int recipeId = Integer.parseInt(idStr);
                Recipe recipe = recipeDAO.getRecipeById(recipeId);

                if (recipe != null) {
                    // Delete recipe if user is owner or demo user
                    if (user.isAdmin() || recipe.getUserId() == 1 || recipe.getUserId() == user.getId()) {
                        recipeDAO.deleteRecipe(recipeId, recipe.getUserId());
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/recipes?msg=deleted");
    }
}
