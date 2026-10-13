package com.ruoyi.photo.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.photo.domain.PhotoPhotographer;

/**
 * PhotoNest摄影师账号/租户主体Mapper接口
 */
public interface PhotoPhotographerMapper
{
    public PhotoPhotographer selectPhotoPhotographerById(Long id);

    public List<PhotoPhotographer> selectPhotoPhotographerList(PhotoPhotographer photoPhotographer);

    public int insertPhotoPhotographer(PhotoPhotographer photoPhotographer);

    public int updatePhotoPhotographer(PhotoPhotographer photoPhotographer);

    public int deletePhotoPhotographerById(Long id);

    public int deletePhotoPhotographerByIds(Long[] ids);

    public int deletePhotoPhotographerByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoPhotographer selectPhotoPhotographerByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoPhotographer selectPhotoPhotographerByUserId(Long userId);

    public PhotoPhotographer selectPhotoPhotographerByShareCode(String shareCode);
}
