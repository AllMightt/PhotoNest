package com.ruoyi.photo.domain;

import com.ruoyi.common.core.web.domain.BaseEntity;

/**
 * PhotoNest作品分类对象 photo_work_category
 */
public class PhotoWorkCategory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** photographerId */
    private Long photographerId;

    /** categoryName */
    private String categoryName;

    /** categoryIcon */
    private String categoryIcon;

    /** sort */
    private Integer sort;

    /** status */
    private String status;

    /** delFlag */
    private String delFlag;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getPhotographerId()
    {
        return photographerId;
    }

    public void setPhotographerId(Long photographerId)
    {
        this.photographerId = photographerId;
    }

    public String getCategoryName()
    {
        return categoryName;
    }

    public void setCategoryName(String categoryName)
    {
        this.categoryName = categoryName;
    }

    public String getCategoryIcon()
    {
        return categoryIcon;
    }

    public void setCategoryIcon(String categoryIcon)
    {
        this.categoryIcon = categoryIcon;
    }

    public Integer getSort()
    {
        return sort;
    }

    public void setSort(Integer sort)
    {
        this.sort = sort;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }
}
