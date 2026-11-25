package com.digitalrecipebox.controller;

import com.digitalrecipebox.model.RecommendationResult;
import com.digitalrecipebox.model.User;
import com.digitalrecipebox.service.RecommendationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * RecommendationServlet
 * Smart Recipe Recommendation controller.
 * Executes ingredient-matching algorithm against user's pantry/available ingredients.
 */
@WebServlet("/recommendations")
public class RecommendationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RecommendationService recommendationService;

    @Override
    public void init() throws ServletException {
        recommendationService = new RecommendationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String inputIngredients = request.getParameter("ingredients");

        if (inputIngredients != null && !inputIngredients.trim().isEmpty()) {
            List<RecommendationResult> recommendations =
                    recommendationService.getRecommendations(inputIngredients, user.getId(), user.isAdmin());

            request.setAttribute("recommendations", recommendations);
            request.setAttribute("inputIngredients", inputIngredients.trim());
        }

        request.getRequestDispatcher("/recommendations.jsp").forward(request, response);
    }
}
