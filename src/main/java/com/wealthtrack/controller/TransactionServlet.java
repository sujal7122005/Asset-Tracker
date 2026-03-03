package com.wealthtrack.controller;

import com.wealthtrack.dao.TransactionDAO;
import com.wealthtrack.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/transactions")
public class TransactionServlet extends HttpServlet {

    private TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

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
