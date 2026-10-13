package com.ruoyi.photo.service;

import java.util.List;
import com.ruoyi.photo.domain.PhotoWorkCategory;

/**
 * PhotoNest作品分类Service接口
 */
public interface IPhotoWorkCategoryService
{
    public PhotoWorkCategory selectPhotoWorkCategoryById(Long id);

    public PhotoWorkCategory selectPhotoWorkCategoryByIdAndPhotographerId(Long id, Long photographerId);

    public List<PhotoWorkCategory> selectPhotoWorkCategoryList(PhotoWorkCategory photoWorkCategory);

    public int insertPhotoWorkCategory(PhotoWorkCategory photoWorkCategory);

    public int updatePhotoWorkCategory(PhotoWorkCategory photoWorkCategory);

    public int deletePhotoWorkCategoryByIds(Long[] ids);

    public int deletePhotoWorkCategoryById(Long id);

    public int deletePhotoWorkCategoryByIdAndPhotographerId(Long id, Long photographerId);
}
