package com.ruoyi.photo.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.photo.domain.PhotoWorkImage;
import com.ruoyi.photo.mapper.PhotoWorkImageMapper;
import com.ruoyi.photo.service.IPhotoWorkImageService;

/**
 * PhotoNest作品图片Service业务层处理
 */
@Service
public class PhotoWorkImageServiceImpl implements IPhotoWorkImageService
{
    @Autowired
    private PhotoWorkImageMapper photoWorkImageMapper;

    @Override
    public PhotoWorkImage selectPhotoWorkImageById(Long id)
    {
        return photoWorkImageMapper.selectPhotoWorkImageById(id);
    }

    @Override
    public PhotoWorkImage selectPhotoWorkImageByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoWorkImageMapper.selectPhotoWorkImageByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public List<PhotoWorkImage> selectPhotoWorkImageList(PhotoWorkImage photoWorkImage)
    {
        return photoWorkImageMapper.selectPhotoWorkImageList(photoWorkImage);
    }

    @Override
    public int insertPhotoWorkImage(PhotoWorkImage photoWorkImage)
    {
        return photoWorkImageMapper.insertPhotoWorkImage(photoWorkImage);
    }

    @Override
    public int updatePhotoWorkImage(PhotoWorkImage photoWorkImage)
    {
        return photoWorkImageMapper.updatePhotoWorkImage(photoWorkImage);
    }

    @Override
    public int deletePhotoWorkImageByIds(Long[] ids)
    {
        return photoWorkImageMapper.deletePhotoWorkImageByIds(ids);
    }

    @Override
    public int deletePhotoWorkImageById(Long id)
    {
        return photoWorkImageMapper.deletePhotoWorkImageById(id);
    }

    @Override
    public int deletePhotoWorkImageByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoWorkImageMapper.deletePhotoWorkImageByIdAndPhotographerId(id, photographerId);
    }
}
