package com.ruoyi.photo.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.photo.domain.PhotoCustomer;

/**
 * PhotoNest摄影师客户Mapper接口
 */
public interface PhotoCustomerMapper
{
    public PhotoCustomer selectPhotoCustomerById(Long id);

    public List<PhotoCustomer> selectPhotoCustomerList(PhotoCustomer photoCustomer);

    public int insertPhotoCustomer(PhotoCustomer photoCustomer);

    public int updatePhotoCustomer(PhotoCustomer photoCustomer);

    public int deletePhotoCustomerById(Long id);

    public int deletePhotoCustomerByIds(Long[] ids);

    public int deletePhotoCustomerByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoCustomer selectPhotoCustomerByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoCustomer selectPhotoCustomerByOpenidAndPhotographerId(@Param("openid") String openid, @Param("photographerId") Long photographerId);
}
