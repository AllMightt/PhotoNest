package com.ruoyi.photo.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.photo.domain.PhotoPackage;
import com.ruoyi.photo.mapper.PhotoPackageMapper;
import com.ruoyi.photo.service.IPhotoPackageService;

/**
 * PhotoNest拍摄套系Service业务层处理
 */
@Service
public class PhotoPackageServiceImpl implements IPhotoPackageService
{
    @Autowired
    private PhotoPackageMapper photoPackageMapper;

    @Override
    public PhotoPackage selectPhotoPackageById(Long id)
    {
        return photoPackageMapper.selectPhotoPackageById(id);
    }

    @Override
    public PhotoPackage selectPhotoPackageByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoPackageMapper.selectPhotoPackageByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public List<PhotoPackage> selectPhotoPackageList(PhotoPackage photoPackage)
    {
        return photoPackageMapper.selectPhotoPackageList(photoPackage);
    }

    @Override
    public int insertPhotoPackage(PhotoPackage photoPackage)
    {
        return photoPackageMapper.insertPhotoPackage(photoPackage);
    }

    @Override
    public int updatePhotoPackage(PhotoPackage photoPackage)
    {
        return photoPackageMapper.updatePhotoPackage(photoPackage);
    }

    @Override
    public int deletePhotoPackageByIds(Long[] ids)
    {
        return photoPackageMapper.deletePhotoPackageByIds(ids);
    }

    @Override
    public int deletePhotoPackageById(Long id)
    {
        return photoPackageMapper.deletePhotoPackageById(id);
    }

    @Override
    public int deletePhotoPackageByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoPackageMapper.deletePhotoPackageByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public List<PhotoPackage> selectAppPhotoPackageList(PhotoPackage photoPackage)
    {
        return photoPackageMapper.selectAppPhotoPackageList(photoPackage);
    }
}
