package com.ruoyi.photo.domain;

import com.ruoyi.common.core.web.domain.BaseEntity;

/**
 * PhotoNest作品图片对象 photo_work_image
 */
public class PhotoWorkImage extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** photographerId */
    private Long photographerId;

    /** workId */
    private Long workId;

    /** originalUrl */
    private String originalUrl;

    /** displayUrl */
    private String displayUrl;

    /** thumbnailUrl */
    private String thumbnailUrl;

    /** watermarkUrl */
    private String watermarkUrl;

    /** fileName */
    private String fileName;

    /** fileSize */
    private Long fileSize;

    /** width */
    private Integer width;

    /** height */
    private Integer height;

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

    public Long getWorkId()
    {
        return workId;
    }

    public void setWorkId(Long workId)
    {
        this.workId = workId;
    }

    public String getOriginalUrl()
    {
        return originalUrl;
    }

    public void setOriginalUrl(String originalUrl)
    {
        this.originalUrl = originalUrl;
    }

    public String getDisplayUrl()
    {
        return displayUrl;
    }

    public void setDisplayUrl(String displayUrl)
    {
        this.displayUrl = displayUrl;
    }

    public String getThumbnailUrl()
    {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl)
    {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getWatermarkUrl()
    {
        return watermarkUrl;
    }

    public void setWatermarkUrl(String watermarkUrl)
    {
        this.watermarkUrl = watermarkUrl;
    }

    public String getFileName()
    {
        return fileName;
    }

    public void setFileName(String fileName)
    {
        this.fileName = fileName;
    }

    public Long getFileSize()
    {
        return fileSize;
    }

    public void setFileSize(Long fileSize)
    {
        this.fileSize = fileSize;
    }

    public Integer getWidth()
    {
        return width;
    }

    public void setWidth(Integer width)
    {
        this.width = width;
    }

    public Integer getHeight()
    {
        return height;
    }

    public void setHeight(Integer height)
    {
        this.height = height;
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
