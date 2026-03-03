package com.wealthtrack.controller;

import com.wealthtrack.dao.AssetDAO;
import com.wealthtrack.dao.PortfolioDAO;
import com.wealthtrack.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/portfolio")
public class PortfolioServlet extends HttpServlet {

    private AssetDAO assetDAO = new AssetDAO();
    private PortfolioDAO portfolioDAO = new PortfolioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
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
            request.setAttribute("summary", summary);
            request.setAttribute("totalAssets", assets.size());

        } catch (Exception e) {
            request.setAttribute("error", "Failed to load portfolio data.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/portfolio.jsp").forward(request, response);
    }
}
