package com.ruoyi.photo.domain;

import com.ruoyi.common.core.web.domain.BaseEntity;

/**
 * PhotoNest摄影师客户对象 photo_customer
 */
public class PhotoCustomer extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** photographerId */
    private Long photographerId;

    /** openid */
    private String openid;

    /** nickname */
    private String nickname;

    /** avatarUrl */
    private String avatarUrl;

    /** realName */
    private String realName;

    /** phone */
    private String phone;

    /** wechatId */
    private String wechatId;

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

    public String getOpenid()
    {
        return openid;
    }

    public void setOpenid(String openid)
    {
        this.openid = openid;
    }

    public String getNickname()
    {
        return nickname;
    }

    public void setNickname(String nickname)
    {
        this.nickname = nickname;
    }

    public String getAvatarUrl()
    {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl)
    {
        this.avatarUrl = avatarUrl;
    }

    public String getRealName()
    {
        return realName;
    }

    public void setRealName(String realName)
    {
        this.realName = realName;
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
