package com.ruoyi.photo.domain;

import java.math.BigDecimal;
import com.ruoyi.common.core.web.domain.BaseEntity;

/**
 * PhotoNest拍摄套系对象 photo_package
 */
public class PhotoPackage extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** photographerId */
    private Long photographerId;

    /** packageName */
    private String packageName;

    /** coverUrl */
    private String coverUrl;

    /** priceDisplayType */
    private String priceDisplayType;

    /** priceText */
    private String priceText;

    /** price */
    private BigDecimal price;

    /** depositAmount */
    private BigDecimal depositAmount;

    /** durationMinutes */
    private Integer durationMinutes;

    /** originalPhotoCount */
    private Integer originalPhotoCount;

    /** retouchPhotoCount */
    private Integer retouchPhotoCount;

    /** suitablePeople */
    private String suitablePeople;

    /** serviceContent */
    private String serviceContent;

    /** deliveryCycle */
    private String deliveryCycle;

    /** extraPhotoPrice */
    private BigDecimal extraPhotoPrice;

    /** extraHourPrice */
    private BigDecimal extraHourPrice;

    /** notice */
    private String notice;

    /** rescheduleRule */
    private String rescheduleRule;

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

    public String getPackageName()
    {
        return packageName;
    }

    public void setPackageName(String packageName)
    {
        this.packageName = packageName;
    }

    public String getCoverUrl()
    {
        return coverUrl;
    }

    public void setCoverUrl(String coverUrl)
    {
        this.coverUrl = coverUrl;
    }

    public String getPriceDisplayType()
    {
        return priceDisplayType;
    }

    public void setPriceDisplayType(String priceDisplayType)
    {
        this.priceDisplayType = priceDisplayType;
    }

    public String getPriceText()
    {
        return priceText;
    }

    public void setPriceText(String priceText)
    {
        this.priceText = priceText;
    }

    public BigDecimal getPrice()
    {
        return price;
    }

    public void setPrice(BigDecimal price)
    {
        this.price = price;
    }

    public BigDecimal getDepositAmount()
    {
        return depositAmount;
    }

    public void setDepositAmount(BigDecimal depositAmount)
    {
        this.depositAmount = depositAmount;
    }

    public Integer getDurationMinutes()
    {
        return durationMinutes;
    }

    public void setDurationMinutes(Integer durationMinutes)
    {
        this.durationMinutes = durationMinutes;
    }

    public Integer getOriginalPhotoCount()
    {
        return originalPhotoCount;
    }

    public void setOriginalPhotoCount(Integer originalPhotoCount)
    {
        this.originalPhotoCount = originalPhotoCount;
    }

    public Integer getRetouchPhotoCount()
    {
        return retouchPhotoCount;
    }

    public void setRetouchPhotoCount(Integer retouchPhotoCount)
    {
        this.retouchPhotoCount = retouchPhotoCount;
    }

    public String getSuitablePeople()
    {
        return suitablePeople;
    }

    public void setSuitablePeople(String suitablePeople)
    {
        this.suitablePeople = suitablePeople;
    }

    public String getServiceContent()
    {
        return serviceContent;
    }

    public void setServiceContent(String serviceContent)
    {
        this.serviceContent = serviceContent;
    }

    public String getDeliveryCycle()
    {
        return deliveryCycle;
    }

    public void setDeliveryCycle(String deliveryCycle)
    {
        this.deliveryCycle = deliveryCycle;
    }

    public BigDecimal getExtraPhotoPrice()
    {
        return extraPhotoPrice;
    }

    public void setExtraPhotoPrice(BigDecimal extraPhotoPrice)
    {
        this.extraPhotoPrice = extraPhotoPrice;
    }

    public BigDecimal getExtraHourPrice()
    {
        return extraHourPrice;
    }

    public void setExtraHourPrice(BigDecimal extraHourPrice)
    {
        this.extraHourPrice = extraHourPrice;
    }

    public String getNotice()
    {
        return notice;
    }

    public void setNotice(String notice)
    {
        this.notice = notice;
    }

    public String getRescheduleRule()
    {
        return rescheduleRule;
    }

    public void setRescheduleRule(String rescheduleRule)
    {
        this.rescheduleRule = rescheduleRule;
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
