package com.wealthtrack.controller;

import com.wealthtrack.dao.AssetDAO;
import com.wealthtrack.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/portfolio")
public class PortfolioServlet extends HttpServlet {

    private AssetDAO assetDAO = new AssetDAO();

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
            List<Asset> allAssets = assetDAO.getAssetsByUser(userId);

            if (search != null && !search.trim().isEmpty()) {
                assets = assetDAO.searchAssets(userId, search.trim());
                request.setAttribute("searchQuery", search);
            } else {
                assets = allAssets;
            }

            request.setAttribute("assets", assets);

            // Build card values from live assets so totals always reflect latest data.
            PortfolioSummary summary = buildLiveSummary(userId, allAssets);
            request.setAttribute("summary", summary);
            request.setAttribute("totalAssets", assets.size());

        } catch (Exception e) {
            request.setAttribute("error", "Failed to load portfolio data.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/portfolio.jsp").forward(request, response);
    }

    private PortfolioSummary buildLiveSummary(int userId, List<Asset> assets) {
        BigDecimal totalNetWorth = BigDecimal.ZERO;
        BigDecimal totalInvestments = BigDecimal.ZERO;
        BigDecimal liquidCash = BigDecimal.ZERO;
        BigDecimal liabilities = BigDecimal.ZERO;

        for (Asset asset : assets) {
            BigDecimal signedValue = safe(asset.getCurrentPrice()).multiply(safe(asset.getQuantity()));
            totalNetWorth = totalNetWorth.add(signedValue);

            if (signedValue.compareTo(BigDecimal.ZERO) < 0) {
                liabilities = liabilities.add(signedValue);
                continue;
            }

            if ("Cash".equalsIgnoreCase(asset.getCategoryName())) {
                liquidCash = liquidCash.add(signedValue);
            } else {
                totalInvestments = totalInvestments.add(signedValue);
            }
        }

        PortfolioSummary summary = new PortfolioSummary();
        summary.setUserId(userId);
        summary.setTotalNetWorth(totalNetWorth);
        summary.setTotalInvestments(totalInvestments);
        summary.setLiquidCash(liquidCash);
        summary.setLiabilities(liabilities);
        return summary;
    }

    private BigDecimal safe(BigDecimal value) {
        return value != null ? value : BigDecimal.ZERO;
    }
}
