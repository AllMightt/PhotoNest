package com.ruoyi.photo.service;

import java.util.List;
import com.ruoyi.photo.domain.PhotoCustomer;

/**
 * PhotoNest摄影师客户Service接口
 */
public interface IPhotoCustomerService
{
    public PhotoCustomer selectPhotoCustomerById(Long id);

    public PhotoCustomer selectPhotoCustomerByIdAndPhotographerId(Long id, Long photographerId);

    public PhotoCustomer selectPhotoCustomerByOpenidAndPhotographerId(String openid, Long photographerId);

    public List<PhotoCustomer> selectPhotoCustomerList(PhotoCustomer photoCustomer);

    public int insertPhotoCustomer(PhotoCustomer photoCustomer);

    public int updatePhotoCustomer(PhotoCustomer photoCustomer);

    public int deletePhotoCustomerByIds(Long[] ids);

    public int deletePhotoCustomerById(Long id);

    public int deletePhotoCustomerByIdAndPhotographerId(Long id, Long photographerId);
}
