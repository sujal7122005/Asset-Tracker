package com.wealthtrack.controller;

import com.wealthtrack.dao.UserDAO;
import com.wealthtrack.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("updateProfile".equals(action)) {
                user.setName(request.getParameter("name"));
                user.setEmail(request.getParameter("email"));
                user.setPhone(request.getParameter("phone"));
                user.setCurrencyPreference(request.getParameter("currency"));
                user.setNotificationEnabled("on".equals(request.getParameter("notifications")));

                if (userDAO.updateProfile(user)) {
                    session.setAttribute("user", user);
                    request.setAttribute("success", "Profile updated successfully.");
                } else {
                    request.setAttribute("error", "Failed to update profile.");
                }

            } else if ("changePassword".equals(action)) {
                String oldPassword = request.getParameter("oldPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmNewPassword = request.getParameter("confirmNewPassword");

                if (!newPassword.equals(confirmNewPassword)) {
                    request.setAttribute("error", "New passwords do not match.");
                } else if (!BCrypt.checkpw(oldPassword, user.getPasswordHash())) {
                    request.setAttribute("error", "Current password is incorrect.");
                } else {
                    String newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                    if (userDAO.updatePassword(user.getUserId(), newHash)) {
                        user.setPasswordHash(newHash);
                        session.setAttribute("user", user);
                        request.setAttribute("success", "Password changed successfully.");
                    } else {
                        request.setAttribute("error", "Failed to change password.");
                    }
                }

            } else if ("deleteAccount".equals(action)) {
                if (userDAO.deleteUser(user.getUserId())) {
                    session.invalidate();
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                } else {
                    request.setAttribute("error", "Failed to delete account.");
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred. Please try again.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/settings.jsp").forward(request, response);
    }
}
