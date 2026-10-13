package com.ruoyi.photo.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.photo.domain.PhotoCustomer;
import com.ruoyi.photo.mapper.PhotoCustomerMapper;
import com.ruoyi.photo.service.IPhotoCustomerService;

/**
 * PhotoNest摄影师客户Service业务层处理
 */
@Service
public class PhotoCustomerServiceImpl implements IPhotoCustomerService
{
    @Autowired
    private PhotoCustomerMapper photoCustomerMapper;

    @Override
    public PhotoCustomer selectPhotoCustomerById(Long id)
    {
        return photoCustomerMapper.selectPhotoCustomerById(id);
    }

    @Override
    public PhotoCustomer selectPhotoCustomerByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoCustomerMapper.selectPhotoCustomerByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public PhotoCustomer selectPhotoCustomerByOpenidAndPhotographerId(String openid, Long photographerId)
    {
        return photoCustomerMapper.selectPhotoCustomerByOpenidAndPhotographerId(openid, photographerId);
    }

    @Override
    public List<PhotoCustomer> selectPhotoCustomerList(PhotoCustomer photoCustomer)
    {
        return photoCustomerMapper.selectPhotoCustomerList(photoCustomer);
    }

    @Override
    public int insertPhotoCustomer(PhotoCustomer photoCustomer)
    {
        return photoCustomerMapper.insertPhotoCustomer(photoCustomer);
    }

    @Override
    public int updatePhotoCustomer(PhotoCustomer photoCustomer)
    {
        return photoCustomerMapper.updatePhotoCustomer(photoCustomer);
    }

    @Override
    public int deletePhotoCustomerByIds(Long[] ids)
    {
        return photoCustomerMapper.deletePhotoCustomerByIds(ids);
    }

    @Override
    public int deletePhotoCustomerById(Long id)
    {
        return photoCustomerMapper.deletePhotoCustomerById(id);
    }

    @Override
    public int deletePhotoCustomerByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoCustomerMapper.deletePhotoCustomerByIdAndPhotographerId(id, photographerId);
    }
}
