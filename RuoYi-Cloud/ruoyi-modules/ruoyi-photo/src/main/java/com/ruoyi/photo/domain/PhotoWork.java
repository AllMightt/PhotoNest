package com.ruoyi.photo.domain;

import java.util.Date;
import com.ruoyi.common.core.web.domain.BaseEntity;

/**
 * PhotoNest作品组对象 photo_work
 */
public class PhotoWork extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** photographerId */
    private Long photographerId;

    /** categoryId */
    private Long categoryId;

    /** title */
    private String title;

    /** coverUrl */
    private String coverUrl;

    /** tags */
    private String tags;

    /** shootType */
    private String shootType;

    /** shootLocation */
    private String shootLocation;

    /** shootTime */
    private Date shootTime;

    /** description */
    private String description;

    /** isHomeRecommend */
    private String isHomeRecommend;

    /** publishTime */
    private Date publishTime;

    /** sort */
    private Integer sort;

    /** viewCount */
    private Long viewCount;

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

    public Long getCategoryId()
    {
        return categoryId;
    }

    public void setCategoryId(Long categoryId)
    {
        this.categoryId = categoryId;
    }

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getCoverUrl()
    {
        return coverUrl;
    }

    public void setCoverUrl(String coverUrl)
    {
        this.coverUrl = coverUrl;
    }

    public String getTags()
    {
        return tags;
    }

    public void setTags(String tags)
    {
        this.tags = tags;
    }

    public String getShootType()
    {
        return shootType;
    }

    public void setShootType(String shootType)
    {
        this.shootType = shootType;
    }

    public String getShootLocation()
    {
        return shootLocation;
    }

    public void setShootLocation(String shootLocation)
    {
        this.shootLocation = shootLocation;
    }

    public Date getShootTime()
    {
        return shootTime;
    }

    public void setShootTime(Date shootTime)
    {
        this.shootTime = shootTime;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public String getIsHomeRecommend()
    {
        return isHomeRecommend;
    }

    public void setIsHomeRecommend(String isHomeRecommend)
    {
        this.isHomeRecommend = isHomeRecommend;
    }

    public Date getPublishTime()
    {
        return publishTime;
    }

    public void setPublishTime(Date publishTime)
    {
        this.publishTime = publishTime;
    }

    public Integer getSort()
    {
        return sort;
    }

    public void setSort(Integer sort)
    {
        this.sort = sort;
    }

    public Long getViewCount()
    {
        return viewCount;
    }

    public void setViewCount(Long viewCount)
    {
        this.viewCount = viewCount;
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
