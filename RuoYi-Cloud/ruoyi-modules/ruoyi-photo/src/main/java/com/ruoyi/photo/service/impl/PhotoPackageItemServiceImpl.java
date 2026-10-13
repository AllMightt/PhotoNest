package com.ruoyi.photo.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.photo.domain.PhotoPackageItem;
import com.ruoyi.photo.mapper.PhotoPackageItemMapper;
import com.ruoyi.photo.service.IPhotoPackageItemService;

/**
 * PhotoNest套系明细Service业务层处理
 */
@Service
public class PhotoPackageItemServiceImpl implements IPhotoPackageItemService
{
    @Autowired
    private PhotoPackageItemMapper photoPackageItemMapper;

    @Override
    public PhotoPackageItem selectPhotoPackageItemById(Long id)
    {
        return photoPackageItemMapper.selectPhotoPackageItemById(id);
    }

    @Override
    public PhotoPackageItem selectPhotoPackageItemByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoPackageItemMapper.selectPhotoPackageItemByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public List<PhotoPackageItem> selectPhotoPackageItemList(PhotoPackageItem photoPackageItem)
    {
        return photoPackageItemMapper.selectPhotoPackageItemList(photoPackageItem);
    }

    @Override
    public int insertPhotoPackageItem(PhotoPackageItem photoPackageItem)
    {
        return photoPackageItemMapper.insertPhotoPackageItem(photoPackageItem);
    }

    @Override
    public int updatePhotoPackageItem(PhotoPackageItem photoPackageItem)
    {
        return photoPackageItemMapper.updatePhotoPackageItem(photoPackageItem);
    }

    @Override
    public int deletePhotoPackageItemByIds(Long[] ids)
    {
        return photoPackageItemMapper.deletePhotoPackageItemByIds(ids);
    }

    @Override
    public int deletePhotoPackageItemById(Long id)
    {
        return photoPackageItemMapper.deletePhotoPackageItemById(id);
    }

    @Override
    public int deletePhotoPackageItemByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoPackageItemMapper.deletePhotoPackageItemByIdAndPhotographerId(id, photographerId);
    }
}
