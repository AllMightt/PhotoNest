package com.ruoyi.photo.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.photo.domain.PhotoBooking;
import com.ruoyi.photo.mapper.PhotoBookingMapper;
import com.ruoyi.photo.service.IPhotoBookingService;

/**
 * PhotoNest预约咨询Service业务层处理
 */
@Service
public class PhotoBookingServiceImpl implements IPhotoBookingService
{
    @Autowired
    private PhotoBookingMapper photoBookingMapper;

    @Override
    public PhotoBooking selectPhotoBookingById(Long id)
    {
        return photoBookingMapper.selectPhotoBookingById(id);
    }

    @Override
    public PhotoBooking selectPhotoBookingByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoBookingMapper.selectPhotoBookingByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public List<PhotoBooking> selectPhotoBookingList(PhotoBooking photoBooking)
    {
        return photoBookingMapper.selectPhotoBookingList(photoBooking);
    }

    @Override
    public int insertPhotoBooking(PhotoBooking photoBooking)
    {
        return photoBookingMapper.insertPhotoBooking(photoBooking);
    }

    @Override
    public int updatePhotoBooking(PhotoBooking photoBooking)
    {
        return photoBookingMapper.updatePhotoBooking(photoBooking);
    }

    @Override
    public int deletePhotoBookingByIds(Long[] ids)
    {
        return photoBookingMapper.deletePhotoBookingByIds(ids);
    }

    @Override
    public int deletePhotoBookingById(Long id)
    {
        return photoBookingMapper.deletePhotoBookingById(id);
    }

    @Override
    public int deletePhotoBookingByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoBookingMapper.deletePhotoBookingByIdAndPhotographerId(id, photographerId);
    }
}
