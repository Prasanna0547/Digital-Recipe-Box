package com.digitalrecipebox.controller;

import com.digitalrecipebox.dao.UserDAO;
import com.digitalrecipebox.model.User;
import com.digitalrecipebox.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") instanceof User currentUser && currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");

        if (identifier == null || identifier.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter administrator username/email and password.");
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.getUserByUsernameOrEmail(identifier.trim());
        if (user != null && user.isAdmin() && PasswordUtil.verifyPassword(password, user.getPassword())) {
            HttpSession existingSession = request.getSession(false);
            if (existingSession != null) {
                existingSession.invalidate();
            }
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("user", user);
            newSession.setMaxInactiveInterval(30 * 60);
            request.changeSessionId();
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.setAttribute("errorMessage", "Invalid administrator username/email or password.");
        request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
    }
}
