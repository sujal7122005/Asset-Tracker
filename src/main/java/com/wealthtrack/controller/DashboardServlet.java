package com.wealthtrack.controller;

import com.wealthtrack.dao.*;
import com.wealthtrack.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private PortfolioDAO portfolioDAO = new PortfolioDAO();
    private AssetDAO assetDAO = new AssetDAO();
    private ActivityLogDAO activityLogDAO = new ActivityLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        try {
            // Get portfolio summary
            PortfolioSummary summary = portfolioDAO.getSummary(userId);
            request.setAttribute("summary", summary);

            // Get category values
            request.setAttribute("cashValue", assetDAO.getTotalValueByCategory(userId, "Cash"));
            request.setAttribute("equitiesValue", assetDAO.getTotalValueByCategory(userId, "Equities"));
            request.setAttribute("realEstateValue", assetDAO.getTotalValueByCategory(userId, "Real Estate"));
            request.setAttribute("cryptoValue", assetDAO.getTotalValueByCategory(userId, "Crypto"));

            // Get recent activity
            List<ActivityLog> activities = activityLogDAO.getRecentActivity(userId, 5);
            request.setAttribute("activities", activities);

            // Get asset count
            request.setAttribute("assetCount", assetDAO.getAssetCount(userId));

        } catch (Exception e) {
            request.setAttribute("error", "Failed to load dashboard data.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
