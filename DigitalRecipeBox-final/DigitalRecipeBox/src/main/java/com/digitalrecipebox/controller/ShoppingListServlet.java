package com.digitalrecipebox.controller;

import com.digitalrecipebox.dao.ShoppingListDAO;
import com.digitalrecipebox.model.ShoppingItem;
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
 * ShoppingListServlet
 * Manages shopping lists, custom ingredient additions, status updates, and automatic meal-plan generation.
 */
@WebServlet("/shopping-list")
public class ShoppingListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ShoppingListDAO shoppingListDAO;

    @Override
    public void init() throws ServletException {
        shoppingListDAO = new ShoppingListDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        List<ShoppingItem> items = shoppingListDAO.getShoppingList(userId);
        request.setAttribute("shoppingItems", items);

        request.getRequestDispatcher("/shopping-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        String action = request.getParameter("action");

        if ("generate_from_mealplan".equalsIgnoreCase(action)) {
            int addedCount = shoppingListDAO.generateShoppingListFromMealPlans(userId);
            response.sendRedirect(request.getContextPath() + "/shopping-list?generated=" + addedCount);
            return;

        } else if ("add".equalsIgnoreCase(action)) {
            String ingredientName = request.getParameter("ingredientName");
            String recipeSource = request.getParameter("recipeSource");

            if (ingredientName != null && !ingredientName.trim().isEmpty()) {
                ShoppingItem item = new ShoppingItem();
                item.setUserId(userId);
                item.setIngredientName(ingredientName.trim());
                item.setRecipeSource(recipeSource != null ? recipeSource.trim() : "Custom");
                item.setPurchased(false);
                shoppingListDAO.addShoppingItem(item);
            }

        } else if ("toggle".equalsIgnoreCase(action)) {
            String itemIdStr = request.getParameter("itemId");
            String statusStr = request.getParameter("purchased");

            if (itemIdStr != null && statusStr != null) {
                try {
                    int itemId = Integer.parseInt(itemIdStr);
                    boolean purchased = Boolean.parseBoolean(statusStr);
                    shoppingListDAO.togglePurchased(itemId, userId, purchased);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        } else if ("delete".equalsIgnoreCase(action)) {
            String itemIdStr = request.getParameter("itemId");
            if (itemIdStr != null) {
                try {
                    int itemId = Integer.parseInt(itemIdStr);
                    shoppingListDAO.deleteShoppingItem(itemId, userId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        } else if ("clear_completed".equalsIgnoreCase(action)) {
            shoppingListDAO.clearCompleted(userId);

        } else if ("clear_all".equalsIgnoreCase(action)) {
            shoppingListDAO.clearAll(userId);
        }

        response.sendRedirect(request.getContextPath() + "/shopping-list");
    }
}
