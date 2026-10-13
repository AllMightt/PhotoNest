package com.ruoyi.photo.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.photo.domain.PhotoPhotographer;
import com.ruoyi.photo.mapper.PhotoPhotographerMapper;
import com.ruoyi.photo.service.IPhotoPhotographerService;

/**
 * PhotoNest摄影师账号/租户主体Service业务层处理
 */
@Service
public class PhotoPhotographerServiceImpl implements IPhotoPhotographerService
{
    @Autowired
    private PhotoPhotographerMapper photoPhotographerMapper;

    @Override
    public PhotoPhotographer selectPhotoPhotographerById(Long id)
    {
        return photoPhotographerMapper.selectPhotoPhotographerById(id);
    }

    @Override
    public PhotoPhotographer selectPhotoPhotographerByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoPhotographerMapper.selectPhotoPhotographerByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public List<PhotoPhotographer> selectPhotoPhotographerList(PhotoPhotographer photoPhotographer)
    {
        return photoPhotographerMapper.selectPhotoPhotographerList(photoPhotographer);
    }

    @Override
    public int insertPhotoPhotographer(PhotoPhotographer photoPhotographer)
    {
        return photoPhotographerMapper.insertPhotoPhotographer(photoPhotographer);
    }

    @Override
    public int updatePhotoPhotographer(PhotoPhotographer photoPhotographer)
    {
        return photoPhotographerMapper.updatePhotoPhotographer(photoPhotographer);
    }

    @Override
    public int deletePhotoPhotographerByIds(Long[] ids)
    {
        return photoPhotographerMapper.deletePhotoPhotographerByIds(ids);
    }

    @Override
    public int deletePhotoPhotographerById(Long id)
    {
        return photoPhotographerMapper.deletePhotoPhotographerById(id);
    }

    @Override
    public int deletePhotoPhotographerByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoPhotographerMapper.deletePhotoPhotographerByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public PhotoPhotographer selectPhotoPhotographerByUserId(Long userId)
    {
        return photoPhotographerMapper.selectPhotoPhotographerByUserId(userId);
    }

    @Override
    public PhotoPhotographer selectPhotoPhotographerByShareCode(String shareCode)
    {
        return photoPhotographerMapper.selectPhotoPhotographerByShareCode(shareCode);
    }
}
