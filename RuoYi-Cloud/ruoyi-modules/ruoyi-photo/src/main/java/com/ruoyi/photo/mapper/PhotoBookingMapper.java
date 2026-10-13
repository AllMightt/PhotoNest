package com.ruoyi.photo.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.photo.domain.PhotoBooking;

/**
 * PhotoNest预约咨询Mapper接口
 */
public interface PhotoBookingMapper
{
    public PhotoBooking selectPhotoBookingById(Long id);

    public List<PhotoBooking> selectPhotoBookingList(PhotoBooking photoBooking);

    public int insertPhotoBooking(PhotoBooking photoBooking);

    public int updatePhotoBooking(PhotoBooking photoBooking);

    public int deletePhotoBookingById(Long id);

    public int deletePhotoBookingByIds(Long[] ids);

    public int deletePhotoBookingByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoBooking selectPhotoBookingByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);
}
