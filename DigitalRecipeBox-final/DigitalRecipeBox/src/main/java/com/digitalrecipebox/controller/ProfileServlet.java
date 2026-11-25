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
 * ProfileServlet
 * Manages user profile viewing, name/email update, and secure password change.
 */
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
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
        User user = (User) session.getAttribute("user");
        
        // Refresh latest user data from DB
        User updatedUser = userDAO.getUserById(user.getId());
        if (updatedUser != null) {
            session.setAttribute("user", updatedUser);
        }
        
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");

            if (fullName == null || fullName.trim().isEmpty() || email == null || email.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Full Name and Email cannot be empty.");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            // Check if email changed and is taken by another user
            if (!email.trim().equalsIgnoreCase(currentUser.getEmail()) && userDAO.isEmailExists(email.trim())) {
                request.setAttribute("errorMessage", "Email is already taken by another account.");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            currentUser.setFullName(fullName.trim());
            currentUser.setEmail(email.trim());

            if (userDAO.updateProfile(currentUser)) {
                session.setAttribute("user", currentUser);
                request.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
            }

        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!PasswordUtil.verifyPassword(currentPassword, currentUser.getPassword())) {
                request.setAttribute("passwordErrorMessage", "Current password is incorrect.");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            if (newPassword == null || newPassword.length() < 6) {
                request.setAttribute("passwordErrorMessage", "New password must be at least 6 characters long.");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("passwordErrorMessage", "New passwords do not match.");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            String hashedNewPassword = PasswordUtil.hashPassword(newPassword);
            if (userDAO.updatePassword(currentUser.getId(), hashedNewPassword)) {
                currentUser.setPassword(hashedNewPassword);
                session.setAttribute("user", currentUser);
                request.setAttribute("passwordSuccessMessage", "Password changed successfully!");
            } else {
                request.setAttribute("passwordErrorMessage", "Failed to change password. Database error.");
            }
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
