package com.wealthtrack.controller;

import com.wealthtrack.dao.AssetDAO;
import com.wealthtrack.dao.PortfolioDAO;
import com.wealthtrack.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/portfolio")
public class PortfolioServlet extends HttpServlet {

    private AssetDAO assetDAO = new AssetDAO();
    private PortfolioDAO portfolioDAO = new PortfolioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int userId = user.getUserId();

        try {
            String search = request.getParameter("search");
            List<Asset> assets;

            if (search != null && !search.trim().isEmpty()) {
                assets = assetDAO.searchAssets(userId, search.trim());
                request.setAttribute("searchQuery", search);
            } else {
                assets = assetDAO.getAssetsByUser(userId);
            }

            request.setAttribute("assets", assets);

            // Portfolio summary for cards
            PortfolioSummary summary = portfolioDAO.getSummary(userId);
            if (summary == null) {
                summary = new PortfolioSummary();
            }
            request.setAttribute("summary", summary);
            request.setAttribute("totalAssets", assets.size());

        } catch (Exception e) {
            request.setAttribute("error", "Failed to load portfolio data.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/portfolio.jsp").forward(request, response);
    }
}
