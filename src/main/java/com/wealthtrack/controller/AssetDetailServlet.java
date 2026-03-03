package com.wealthtrack.controller;

import com.wealthtrack.dao.AssetDAO;
import com.wealthtrack.dao.TransactionDAO;
import com.wealthtrack.dao.DocumentDAO;
import com.wealthtrack.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/asset/detail")
public class AssetDetailServlet extends HttpServlet {

    private AssetDAO assetDAO = new AssetDAO();
    private TransactionDAO transactionDAO = new TransactionDAO();
    private DocumentDAO documentDAO = new DocumentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/portfolio");
            return;
        }

        try {
            int assetId = Integer.parseInt(idStr);
            Asset asset = assetDAO.getAssetById(assetId);

            if (asset == null) {
                response.sendRedirect(request.getContextPath() + "/portfolio");
                return;
            }

            request.setAttribute("asset", asset);

            // Get transactions for this asset
            List<Transaction> transactions = transactionDAO.getTransactionsByAsset(assetId);
            request.setAttribute("transactions", transactions);

            // Get documents for this asset
            List<Document> documents = documentDAO.getDocsByAsset(assetId);
            request.setAttribute("documents", documents);

        } catch (Exception e) {
            request.setAttribute("error", "Failed to load asset details.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/asset-detail.jsp").forward(request, response);
    }
}
