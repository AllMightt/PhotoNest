package com.ruoyi.photo.domain;

import com.ruoyi.common.core.web.domain.BaseEntity;

/**
 * PhotoNest套系明细对象 photo_package_item
 */
public class PhotoPackageItem extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** photographerId */
    private Long photographerId;

    /** packageId */
    private Long packageId;

    /** itemName */
    private String itemName;

    /** itemValue */
    private String itemValue;

    /** sort */
    private Integer sort;

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

    public Long getPackageId()
    {
        return packageId;
    }

    public void setPackageId(Long packageId)
    {
        this.packageId = packageId;
    }

    public String getItemName()
    {
        return itemName;
    }

    public void setItemName(String itemName)
    {
        this.itemName = itemName;
    }

    public String getItemValue()
    {
        return itemValue;
    }

    public void setItemValue(String itemValue)
    {
        this.itemValue = itemValue;
    }

    public Integer getSort()
    {
        return sort;
    }

    public void setSort(Integer sort)
    {
        this.sort = sort;
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
