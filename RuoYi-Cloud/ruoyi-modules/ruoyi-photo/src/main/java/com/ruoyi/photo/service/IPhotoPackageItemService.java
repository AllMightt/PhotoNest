package com.ruoyi.photo.service;

import java.util.List;
import com.ruoyi.photo.domain.PhotoPackageItem;

/**
 * PhotoNest套系明细Service接口
 */
public interface IPhotoPackageItemService
{
    public PhotoPackageItem selectPhotoPackageItemById(Long id);

    public PhotoPackageItem selectPhotoPackageItemByIdAndPhotographerId(Long id, Long photographerId);

    public List<PhotoPackageItem> selectPhotoPackageItemList(PhotoPackageItem photoPackageItem);

    public int insertPhotoPackageItem(PhotoPackageItem photoPackageItem);

    public int updatePhotoPackageItem(PhotoPackageItem photoPackageItem);

    public int deletePhotoPackageItemByIds(Long[] ids);

    public int deletePhotoPackageItemById(Long id);

    public int deletePhotoPackageItemByIdAndPhotographerId(Long id, Long photographerId);
}
