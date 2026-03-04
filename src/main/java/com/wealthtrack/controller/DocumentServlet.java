package com.wealthtrack.controller;

import com.wealthtrack.dao.DocumentDAO;
import com.wealthtrack.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/documents")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class DocumentServlet extends HttpServlet {

    private DocumentDAO documentDAO = new DocumentDAO();

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
            List<Document> documents = documentDAO.getDocsByUser(user.getUserId());
            request.setAttribute("documents", documents);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to load documents.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/documents.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Part filePart = request.getPart("file");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getFileName(filePart);
                String uploadPath = getServletContext().getRealPath("/uploads/docs/");

                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String filePath = uploadPath + java.io.File.separator + fileName;
                filePart.write(filePath);

                Document doc = new Document();
                doc.setUserId(user.getUserId());
                String assetIdStr = request.getParameter("assetId");
                if (assetIdStr != null && !assetIdStr.isEmpty()) {
                    doc.setAssetId(Integer.parseInt(assetIdStr));
                }
                doc.setFileName(fileName);
                doc.setFilePath("/uploads/docs/" + fileName);
                doc.setFileSize(filePart.getSize());

                documentDAO.uploadDoc(doc);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Failed to upload document.");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/documents");
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String s : contentDisp.split(";")) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown_file";
    }
}
