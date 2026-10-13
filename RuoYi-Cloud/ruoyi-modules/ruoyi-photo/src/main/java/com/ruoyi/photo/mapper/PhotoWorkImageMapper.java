package com.ruoyi.photo.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.photo.domain.PhotoWorkImage;

/**
 * PhotoNest作品图片Mapper接口
 */
public interface PhotoWorkImageMapper
{
    public PhotoWorkImage selectPhotoWorkImageById(Long id);

    public List<PhotoWorkImage> selectPhotoWorkImageList(PhotoWorkImage photoWorkImage);

    public int insertPhotoWorkImage(PhotoWorkImage photoWorkImage);

    public int updatePhotoWorkImage(PhotoWorkImage photoWorkImage);

    public int deletePhotoWorkImageById(Long id);

    public int deletePhotoWorkImageByIds(Long[] ids);

    public int deletePhotoWorkImageByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoWorkImage selectPhotoWorkImageByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);
}
