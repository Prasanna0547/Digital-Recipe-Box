package com.digitalrecipebox.controller;

import com.digitalrecipebox.dao.FavoriteDAO;
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
 * FavoriteServlet
 * Handles favoriting/unfavoriting recipes and displaying user favorite collection.
 */
@WebServlet({"/favorite", "/favorites"})
public class FavoriteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private FavoriteDAO favoriteDAO;

    @Override
    public void init() throws ServletException {
        favoriteDAO = new FavoriteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        List<Recipe> favoriteRecipes = favoriteDAO.getFavoriteRecipes(user.getId());
        request.setAttribute("favoriteRecipes", favoriteRecipes);
        request.getRequestDispatcher("/favorites.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String recipeIdStr = request.getParameter("recipeId");
        String action = request.getParameter("action"); // "add" or "remove" or "toggle"
        String redirectUrl = request.getParameter("redirectUrl");

        if (recipeIdStr != null && !recipeIdStr.trim().isEmpty()) {
            try {
                int recipeId = Integer.parseInt(recipeIdStr);

                if ("remove".equalsIgnoreCase(action)) {
                    favoriteDAO.removeFavorite(user.getId(), recipeId);
                } else if ("add".equalsIgnoreCase(action)) {
                    favoriteDAO.addFavorite(user.getId(), recipeId);
                } else {
                    // Toggle favorite
                    if (favoriteDAO.isFavorite(user.getId(), recipeId)) {
                        favoriteDAO.removeFavorite(user.getId(), recipeId);
                    } else {
                        favoriteDAO.addFavorite(user.getId(), recipeId);
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/favorites");
        }
    }
}
