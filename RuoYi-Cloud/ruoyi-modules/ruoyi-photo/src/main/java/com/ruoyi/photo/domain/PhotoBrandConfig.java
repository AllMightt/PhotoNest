package com.ruoyi.photo.domain;

import com.ruoyi.common.core.web.domain.BaseEntity;

/**
 * PhotoNest摄影师品牌主页配置对象 photo_brand_config
 */
public class PhotoBrandConfig extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** photographerId */
    private Long photographerId;

    /** brandName */
    private String brandName;

    /** photographerName */
    private String photographerName;

    /** logoUrl */
    private String logoUrl;

    /** coverImage */
    private String coverImage;

    /** subtitle */
    private String subtitle;

    /** intro */
    private String intro;

    /** aboutContent */
    private String aboutContent;

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

    /** shootProcess */
    private String shootProcess;

    /** faqContent */
    private String faqContent;

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

    public String getLogoUrl()
    {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl)
    {
        this.logoUrl = logoUrl;
    }

    public String getCoverImage()
    {
        return coverImage;
    }

    public void setCoverImage(String coverImage)
    {
        this.coverImage = coverImage;
    }

    public String getSubtitle()
    {
        return subtitle;
    }

    public void setSubtitle(String subtitle)
    {
        this.subtitle = subtitle;
    }

    public String getIntro()
    {
        return intro;
    }

    public void setIntro(String intro)
    {
        this.intro = intro;
    }

    public String getAboutContent()
    {
        return aboutContent;
    }

    public void setAboutContent(String aboutContent)
    {
        this.aboutContent = aboutContent;
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

    public String getShootProcess()
    {
        return shootProcess;
    }

    public void setShootProcess(String shootProcess)
    {
        this.shootProcess = shootProcess;
    }

    public String getFaqContent()
    {
        return faqContent;
    }

    public void setFaqContent(String faqContent)
    {
        this.faqContent = faqContent;
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
