package com.wealthtrack.controller;

import com.wealthtrack.dao.TransactionDAO;
import com.wealthtrack.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/transactions")
public class TransactionServlet extends HttpServlet {

    private TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Transaction> transactions = transactionDAO.getTransactionsByUser(user.getUserId());
            request.setAttribute("transactions", transactions);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to load transactions.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/transactions.jsp").forward(request, response);
    }
}
