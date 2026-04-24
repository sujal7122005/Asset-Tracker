package com.experiment10.bean;

import com.experiment10.dao.AssetCategoryDAO;
import com.experiment10.model.AssetCategory;
import jakarta.annotation.PostConstruct;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Named;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Named("assetCategoryBean")
@ViewScoped
public class AssetCategoryBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private final AssetCategoryDAO categoryDAO = new AssetCategoryDAO();

    private List<AssetCategory> categories = new ArrayList<>();
    private AssetCategory formCategory = new AssetCategory();
    private boolean editMode;

    @PostConstruct
    public void init() {
        loadCategories();
    }

    public void loadCategories() {
        try {
            categories = categoryDAO.findAll();
        } catch (SQLException e) {
            addMessage(FacesMessage.SEVERITY_ERROR, "Load failed", "Could not fetch categories.");
        }
    }

    public void save() {
        try {
            boolean success = editMode ? categoryDAO.update(formCategory) : categoryDAO.insert(formCategory);

            if (success) {
                addMessage(FacesMessage.SEVERITY_INFO, "Success",
                        editMode ? "Category updated." : "Category added.");
                clearForm();
                loadCategories();
            } else {
                addMessage(FacesMessage.SEVERITY_WARN, "No change", "No database row was affected.");
            }
        } catch (SQLException e) {
            addMessage(FacesMessage.SEVERITY_ERROR, "Database error", resolveSqlMessage(e));
        }
    }

    public void edit(AssetCategory selected) {
        AssetCategory copy = new AssetCategory();
        copy.setCategoryId(selected.getCategoryId());
        copy.setCategoryName(selected.getCategoryName());
        copy.setIconClass(selected.getIconClass());
        copy.setColorCode(selected.getColorCode());
        copy.setCreatedAt(selected.getCreatedAt());
        formCategory = copy;
        editMode = true;
    }

    public void delete(int categoryId) {
        try {
            boolean success = categoryDAO.delete(categoryId);
            if (success) {
                addMessage(FacesMessage.SEVERITY_INFO, "Deleted", "Category removed.");
                if (editMode && formCategory.getCategoryId() == categoryId) {
                    clearForm();
                }
                loadCategories();
            } else {
                addMessage(FacesMessage.SEVERITY_WARN, "No change", "No category was deleted.");
            }
        } catch (SQLException e) {
            addMessage(FacesMessage.SEVERITY_ERROR, "Delete failed", resolveSqlMessage(e));
        }
    }

    public void clearForm() {
        formCategory = new AssetCategory();
        editMode = false;
    }

    private String resolveSqlMessage(SQLException e) {
        if ("23505".equals(e.getSQLState())) {
            return "Category name already exists.";
        }
        if ("23503".equals(e.getSQLState())) {
            return "Category is referenced by other records and cannot be deleted.";
        }
        return e.getMessage();
    }

    private void addMessage(FacesMessage.Severity severity, String summary, String detail) {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(severity, summary, detail));
    }

    public List<AssetCategory> getCategories() {
        return categories;
    }

    public AssetCategory getFormCategory() {
        return formCategory;
    }

    public void setFormCategory(AssetCategory formCategory) {
        this.formCategory = formCategory;
    }

    public boolean isEditMode() {
        return editMode;
    }
}
