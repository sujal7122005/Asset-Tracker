package com.wealthtrack.controller;

import com.wealthtrack.dao.UserDAO;
import com.wealthtrack.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All required fields must be filled.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            if (userDAO.emailExists(email)) {
                request.setAttribute("error", "An account with this email already exists.");
                request.setAttribute("name", name);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
            User user = new User(name, email, phone, passwordHash);
            userDAO.register(user);

            // Auto-login after registration
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(request.getContextPath() + "/dashboard");
        } catch (Exception e) {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
