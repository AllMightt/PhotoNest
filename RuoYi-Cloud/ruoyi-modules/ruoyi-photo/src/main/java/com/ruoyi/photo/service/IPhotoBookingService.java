package com.ruoyi.photo.service;

import java.util.List;
import com.ruoyi.photo.domain.PhotoBooking;

/**
 * PhotoNest预约咨询Service接口
 */
public interface IPhotoBookingService
{
    public PhotoBooking selectPhotoBookingById(Long id);

    public PhotoBooking selectPhotoBookingByIdAndPhotographerId(Long id, Long photographerId);

    public List<PhotoBooking> selectPhotoBookingList(PhotoBooking photoBooking);

    public int insertPhotoBooking(PhotoBooking photoBooking);

    public int updatePhotoBooking(PhotoBooking photoBooking);

    public int deletePhotoBookingByIds(Long[] ids);

    public int deletePhotoBookingById(Long id);

    public int deletePhotoBookingByIdAndPhotographerId(Long id, Long photographerId);
}
