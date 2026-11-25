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

/**
 * LoginServlet
 * Authenticates user credentials, manages HttpSession creation, and handles login errors.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
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
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String identifier = request.getParameter("identifier"); // username or email
        String password = request.getParameter("password");

        if (identifier == null || identifier.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter your username/email and password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.getUserByUsernameOrEmail(identifier.trim());

        if (user != null && !user.isAdmin() && PasswordUtil.verifyPassword(password, user.getPassword())) {
            // Login Success: Create session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes session expiry

            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            // Login Failure
            request.setAttribute("errorMessage", "Invalid username/email or password. Please try again. Admins should use the admin sign-in.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
