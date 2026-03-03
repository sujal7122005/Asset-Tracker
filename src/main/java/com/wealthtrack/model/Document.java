package com.wealthtrack.model;

import java.sql.Timestamp;

public class Document {
    private int docId;
    private int assetId;
    private int userId;
    private String fileName;
    private String filePath;
    private long fileSize;
    private Timestamp uploadDate;
    private String assetName;

    public Document() {
    }

    public int getDocId() {
        return docId;
    }

    public void setDocId(int docId) {
        this.docId = docId;
    }

    public int getAssetId() {
        return assetId;
    }

    public void setAssetId(int assetId) {
        this.assetId = assetId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }

    public Timestamp getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }

    public String getAssetName() {
        return assetName;
    }

    public void setAssetName(String assetName) {
        this.assetName = assetName;
    }

    public String getFileSizeFormatted() {
        if (fileSize < 1024)
            return fileSize + " B";
        if (fileSize < 1024 * 1024)
            return (fileSize / 1024) + " KB";
        return String.format("%.1f MB", fileSize / (1024.0 * 1024.0));
    }
}
