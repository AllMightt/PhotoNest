package com.ruoyi.photo.service;

import java.util.List;
import com.ruoyi.photo.domain.PhotoPackage;

/**
 * PhotoNest拍摄套系Service接口
 */
public interface IPhotoPackageService
{
    public PhotoPackage selectPhotoPackageById(Long id);

    public PhotoPackage selectPhotoPackageByIdAndPhotographerId(Long id, Long photographerId);

    public List<PhotoPackage> selectPhotoPackageList(PhotoPackage photoPackage);

    public int insertPhotoPackage(PhotoPackage photoPackage);

    public int updatePhotoPackage(PhotoPackage photoPackage);

    public int deletePhotoPackageByIds(Long[] ids);

    public int deletePhotoPackageById(Long id);

    public int deletePhotoPackageByIdAndPhotographerId(Long id, Long photographerId);

    public List<PhotoPackage> selectAppPhotoPackageList(PhotoPackage photoPackage);
}
