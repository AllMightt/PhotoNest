package com.ruoyi.photo.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.photo.domain.PhotoWorkCategory;

/**
 * PhotoNest作品分类Mapper接口
 */
public interface PhotoWorkCategoryMapper
{
    public PhotoWorkCategory selectPhotoWorkCategoryById(Long id);

    public List<PhotoWorkCategory> selectPhotoWorkCategoryList(PhotoWorkCategory photoWorkCategory);

    public int insertPhotoWorkCategory(PhotoWorkCategory photoWorkCategory);

    public int updatePhotoWorkCategory(PhotoWorkCategory photoWorkCategory);

    public int deletePhotoWorkCategoryById(Long id);

    public int deletePhotoWorkCategoryByIds(Long[] ids);

    public int deletePhotoWorkCategoryByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoWorkCategory selectPhotoWorkCategoryByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);
}
