package com.ruoyi.photo.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.photo.domain.PhotoPackageItem;

/**
 * PhotoNest套系明细Mapper接口
 */
public interface PhotoPackageItemMapper
{
    public PhotoPackageItem selectPhotoPackageItemById(Long id);

    public List<PhotoPackageItem> selectPhotoPackageItemList(PhotoPackageItem photoPackageItem);

    public int insertPhotoPackageItem(PhotoPackageItem photoPackageItem);

    public int updatePhotoPackageItem(PhotoPackageItem photoPackageItem);

    public int deletePhotoPackageItemById(Long id);

    public int deletePhotoPackageItemByIds(Long[] ids);

    public int deletePhotoPackageItemByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoPackageItem selectPhotoPackageItemByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);
}
