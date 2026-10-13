package com.ruoyi.photo.domain;

import java.util.Date;
import com.ruoyi.common.core.web.domain.BaseEntity;

/**
 * PhotoNest预约咨询对象 photo_booking
 */
public class PhotoBooking extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** photographerId */
    private Long photographerId;

    /** customerId */
    private Long customerId;

    /** bookingNo */
    private String bookingNo;

    /** customerName */
    private String customerName;

    /** phone */
    private String phone;

    /** wechatId */
    private String wechatId;

    /** shootType */
    private String shootType;

    /** packageId */
    private Long packageId;

    /** expectedDate */
    private Date expectedDate;

    /** expectedTime */
    private String expectedTime;

    /** expectedLocation */
    private String expectedLocation;

    /** peopleCount */
    private Integer peopleCount;

    /** hasChild */
    private String hasChild;

    /** requirement */
    private String requirement;

    /** sourceChannel */
    private String sourceChannel;

    /** sourcePage */
    private String sourcePage;

    /** sourceType */
    private String sourceType;

    /** sourceWorkId */
    private Long sourceWorkId;

    /** sourcePackageId */
    private Long sourcePackageId;

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

    public Long getCustomerId()
    {
        return customerId;
    }

    public void setCustomerId(Long customerId)
    {
        this.customerId = customerId;
    }

    public String getBookingNo()
    {
        return bookingNo;
    }

    public void setBookingNo(String bookingNo)
    {
        this.bookingNo = bookingNo;
    }

    public String getCustomerName()
    {
        return customerName;
    }

    public void setCustomerName(String customerName)
    {
        this.customerName = customerName;
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

    public String getShootType()
    {
        return shootType;
    }

    public void setShootType(String shootType)
    {
        this.shootType = shootType;
    }

    public Long getPackageId()
    {
        return packageId;
    }

    public void setPackageId(Long packageId)
    {
        this.packageId = packageId;
    }

    public Date getExpectedDate()
    {
        return expectedDate;
    }

    public void setExpectedDate(Date expectedDate)
    {
        this.expectedDate = expectedDate;
    }

    public String getExpectedTime()
    {
        return expectedTime;
    }

    public void setExpectedTime(String expectedTime)
    {
        this.expectedTime = expectedTime;
    }

    public String getExpectedLocation()
    {
        return expectedLocation;
    }

    public void setExpectedLocation(String expectedLocation)
    {
        this.expectedLocation = expectedLocation;
    }

    public Integer getPeopleCount()
    {
        return peopleCount;
    }

    public void setPeopleCount(Integer peopleCount)
    {
        this.peopleCount = peopleCount;
    }

    public String getHasChild()
    {
        return hasChild;
    }

    public void setHasChild(String hasChild)
    {
        this.hasChild = hasChild;
    }

    public String getRequirement()
    {
        return requirement;
    }

    public void setRequirement(String requirement)
    {
        this.requirement = requirement;
    }

    public String getSourceChannel()
    {
        return sourceChannel;
    }

    public void setSourceChannel(String sourceChannel)
    {
        this.sourceChannel = sourceChannel;
    }

    public String getSourcePage()
    {
        return sourcePage;
    }

    public void setSourcePage(String sourcePage)
    {
        this.sourcePage = sourcePage;
    }

    public String getSourceType()
    {
        return sourceType;
    }

    public void setSourceType(String sourceType)
    {
        this.sourceType = sourceType;
    }

    public Long getSourceWorkId()
    {
        return sourceWorkId;
    }

    public void setSourceWorkId(Long sourceWorkId)
    {
        this.sourceWorkId = sourceWorkId;
    }

    public Long getSourcePackageId()
    {
        return sourcePackageId;
    }

    public void setSourcePackageId(Long sourcePackageId)
    {
        this.sourcePackageId = sourcePackageId;
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
