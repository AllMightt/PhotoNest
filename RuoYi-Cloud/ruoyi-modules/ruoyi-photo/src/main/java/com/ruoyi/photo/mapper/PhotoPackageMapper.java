package com.ruoyi.photo.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.photo.domain.PhotoPackage;

/**
 * PhotoNest拍摄套系Mapper接口
 */
public interface PhotoPackageMapper
{
    public PhotoPackage selectPhotoPackageById(Long id);

    public List<PhotoPackage> selectPhotoPackageList(PhotoPackage photoPackage);

    public int insertPhotoPackage(PhotoPackage photoPackage);

    public int updatePhotoPackage(PhotoPackage photoPackage);

    public int deletePhotoPackageById(Long id);

    public int deletePhotoPackageByIds(Long[] ids);

    public int deletePhotoPackageByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoPackage selectPhotoPackageByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public List<PhotoPackage> selectAppPhotoPackageList(PhotoPackage photoPackage);
}
