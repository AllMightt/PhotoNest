package com.ruoyi.photo.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.photo.domain.PhotoWorkCategory;
import com.ruoyi.photo.mapper.PhotoWorkCategoryMapper;
import com.ruoyi.photo.service.IPhotoWorkCategoryService;

/**
 * PhotoNest作品分类Service业务层处理
 */
@Service
public class PhotoWorkCategoryServiceImpl implements IPhotoWorkCategoryService
{
    @Autowired
    private PhotoWorkCategoryMapper photoWorkCategoryMapper;

    @Override
    public PhotoWorkCategory selectPhotoWorkCategoryById(Long id)
    {
        return photoWorkCategoryMapper.selectPhotoWorkCategoryById(id);
    }

    @Override
    public PhotoWorkCategory selectPhotoWorkCategoryByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoWorkCategoryMapper.selectPhotoWorkCategoryByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public List<PhotoWorkCategory> selectPhotoWorkCategoryList(PhotoWorkCategory photoWorkCategory)
    {
        return photoWorkCategoryMapper.selectPhotoWorkCategoryList(photoWorkCategory);
    }

    @Override
    public int insertPhotoWorkCategory(PhotoWorkCategory photoWorkCategory)
    {
        return photoWorkCategoryMapper.insertPhotoWorkCategory(photoWorkCategory);
    }

    @Override
    public int updatePhotoWorkCategory(PhotoWorkCategory photoWorkCategory)
    {
        return photoWorkCategoryMapper.updatePhotoWorkCategory(photoWorkCategory);
    }

    @Override
    public int deletePhotoWorkCategoryByIds(Long[] ids)
    {
        return photoWorkCategoryMapper.deletePhotoWorkCategoryByIds(ids);
    }

    @Override
    public int deletePhotoWorkCategoryById(Long id)
    {
        return photoWorkCategoryMapper.deletePhotoWorkCategoryById(id);
    }

    @Override
    public int deletePhotoWorkCategoryByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoWorkCategoryMapper.deletePhotoWorkCategoryByIdAndPhotographerId(id, photographerId);
    }
}
