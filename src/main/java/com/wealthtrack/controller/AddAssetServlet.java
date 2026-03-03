package com.wealthtrack.controller;

import com.wealthtrack.dao.AssetDAO;
import com.wealthtrack.dao.ActivityLogDAO;
import com.wealthtrack.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

@WebServlet("/asset/add")
public class AddAssetServlet extends HttpServlet {

    private AssetDAO assetDAO = new AssetDAO();
    private ActivityLogDAO activityLogDAO = new ActivityLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/add-asset.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            Asset asset = new Asset();
            asset.setUserId(user.getUserId());
            asset.setName(request.getParameter("assetName"));
            asset.setTickerSymbol(request.getParameter("tickerSymbol"));
            asset.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));

            String currentPriceStr = request.getParameter("currentPrice");
            String purchasePriceStr = request.getParameter("purchasePrice");
            String quantityStr = request.getParameter("quantity");
            String commissionStr = request.getParameter("commission");
            String purchaseDateStr = request.getParameter("purchaseDate");

            asset.setCurrentPrice(
                    currentPriceStr != null && !currentPriceStr.isEmpty() ? new BigDecimal(currentPriceStr)
                            : BigDecimal.ZERO);
            asset.setPurchasePrice(
                    purchasePriceStr != null && !purchasePriceStr.isEmpty() ? new BigDecimal(purchasePriceStr)
                            : BigDecimal.ZERO);
            asset.setQuantity(
                    quantityStr != null && !quantityStr.isEmpty() ? new BigDecimal(quantityStr) : BigDecimal.ZERO);
            asset.setCommission(commissionStr != null && !commissionStr.isEmpty() ? new BigDecimal(commissionStr)
                    : BigDecimal.ZERO);
            asset.setPurchaseDate(
                    purchaseDateStr != null && !purchaseDateStr.isEmpty() ? Date.valueOf(purchaseDateStr) : null);
            asset.setNotes(request.getParameter("notes"));

            if (assetDAO.addAsset(asset)) {
                // Log activity
                ActivityLog log = new ActivityLog();
                log.setUserId(user.getUserId());
                log.setActionType("Purchase");
                log.setDescription("Added " + asset.getName() +
                        (asset.getTickerSymbol() != null ? " (" + asset.getTickerSymbol() + ")" : ""));
                log.setAmount(asset.getInvestedAmount().negate());
                activityLogDAO.logActivity(log);

                response.sendRedirect(request.getContextPath() + "/portfolio");
            } else {
                request.setAttribute("error", "Failed to add asset.");
                request.getRequestDispatcher("/add-asset.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error adding asset: " + e.getMessage());
            request.getRequestDispatcher("/add-asset.jsp").forward(request, response);
            e.printStackTrace();
        }
    }
}
