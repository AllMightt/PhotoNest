package com.ruoyi.photo.domain;

import java.util.Date;
import com.ruoyi.common.core.web.domain.BaseEntity;

/**
 * PhotoNest摄影师账号/租户主体对象 photo_photographer
 */
public class PhotoPhotographer extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** userId */
    private Long userId;

    /** brandName */
    private String brandName;

    /** photographerName */
    private String photographerName;

    /** shareCode */
    private String shareCode;

    /** avatar */
    private String avatar;

    /** coverImage */
    private String coverImage;

    /** city */
    private String city;

    /** phone */
    private String phone;

    /** wechatId */
    private String wechatId;

    /** wechatQr */
    private String wechatQr;

    /** xiaohongshuId */
    private String xiaohongshuId;

    /** xiaohongshuQr */
    private String xiaohongshuQr;

    /** douyinId */
    private String douyinId;

    /** douyinQr */
    private String douyinQr;

    /** status */
    private String status;

    /** planType */
    private String planType;

    /** expireTime */
    private Date expireTime;

    /** storageLimit */
    private Long storageLimit;

    /** storageUsed */
    private Long storageUsed;

    /** workLimit */
    private Integer workLimit;

    /** packageLimit */
    private Integer packageLimit;

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

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getBrandName()
    {
        return brandName;
    }

    public void setBrandName(String brandName)
    {
        this.brandName = brandName;
    }

    public String getPhotographerName()
    {
        return photographerName;
    }

    public void setPhotographerName(String photographerName)
    {
        this.photographerName = photographerName;
    }

    public String getShareCode()
    {
        return shareCode;
    }

    public void setShareCode(String shareCode)
    {
        this.shareCode = shareCode;
    }

    public String getAvatar()
    {
        return avatar;
    }

    public void setAvatar(String avatar)
    {
        this.avatar = avatar;
    }

    public String getCoverImage()
    {
        return coverImage;
    }

    public void setCoverImage(String coverImage)
    {
        this.coverImage = coverImage;
    }

    public String getCity()
    {
        return city;
    }

    public void setCity(String city)
    {
        this.city = city;
    }

    public String getPhone()
    {
        return phone;
    }

    public void setPhone(String phone)
    {
        this.phone = phone;
    }

    public String getWechatId()
    {
        return wechatId;
    }

    public void setWechatId(String wechatId)
    {
        this.wechatId = wechatId;
    }

    public String getWechatQr()
    {
        return wechatQr;
    }

    public void setWechatQr(String wechatQr)
    {
        this.wechatQr = wechatQr;
    }

    public String getXiaohongshuId()
    {
        return xiaohongshuId;
    }

    public void setXiaohongshuId(String xiaohongshuId)
    {
        this.xiaohongshuId = xiaohongshuId;
    }

    public String getXiaohongshuQr()
    {
        return xiaohongshuQr;
    }

    public void setXiaohongshuQr(String xiaohongshuQr)
    {
        this.xiaohongshuQr = xiaohongshuQr;
    }

    public String getDouyinId()
    {
        return douyinId;
    }

    public void setDouyinId(String douyinId)
    {
        this.douyinId = douyinId;
    }

    public String getDouyinQr()
    {
        return douyinQr;
    }

    public void setDouyinQr(String douyinQr)
    {
        this.douyinQr = douyinQr;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getPlanType()
    {
        return planType;
    }

    public void setPlanType(String planType)
    {
        this.planType = planType;
    }

    public Date getExpireTime()
    {
        return expireTime;
    }

    public void setExpireTime(Date expireTime)
    {
        this.expireTime = expireTime;
    }

    public Long getStorageLimit()
    {
        return storageLimit;
    }

    public void setStorageLimit(Long storageLimit)
    {
        this.storageLimit = storageLimit;
    }

    public Long getStorageUsed()
    {
        return storageUsed;
    }

    public void setStorageUsed(Long storageUsed)
    {
        this.storageUsed = storageUsed;
    }

    public Integer getWorkLimit()
    {
        return workLimit;
    }

    public void setWorkLimit(Integer workLimit)
    {
        this.workLimit = workLimit;
    }

    public Integer getPackageLimit()
    {
        return packageLimit;
    }

    public void setPackageLimit(Integer packageLimit)
    {
        this.packageLimit = packageLimit;
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
