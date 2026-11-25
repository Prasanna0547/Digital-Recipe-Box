package com.digitalrecipebox.controller;

import com.digitalrecipebox.dao.UserDAO;
import com.digitalrecipebox.model.User;
import com.digitalrecipebox.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * RegisterServlet
 * Handles user account creation, form validation, and duplicate username/email checks.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");

        // Server-side validation
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required. Please complete the registration form.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match. Please re-enter your password.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.isUsernameExists(username.trim())) {
            request.setAttribute("errorMessage", "Username '" + username + "' is already taken. Please choose another.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.isEmailExists(email.trim())) {
            request.setAttribute("errorMessage", "Email '" + email + "' is already registered. Please sign in.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Hash password securely
        String hashedPassword = PasswordUtil.hashPassword(password);
        User newUser = new User(username.trim(), email.trim(), hashedPassword, fullName.trim());

        int userId = userDAO.registerUser(newUser);

        if (userId > 0) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?success=registered");
        } else {
            request.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
