package com.ruoyi.photo.service;

import java.util.List;
import com.ruoyi.photo.domain.PhotoPhotographer;

/**
 * PhotoNest摄影师账号/租户主体Service接口
 */
public interface IPhotoPhotographerService
{
    public PhotoPhotographer selectPhotoPhotographerById(Long id);

    public PhotoPhotographer selectPhotoPhotographerByIdAndPhotographerId(Long id, Long photographerId);

    public List<PhotoPhotographer> selectPhotoPhotographerList(PhotoPhotographer photoPhotographer);

    public int insertPhotoPhotographer(PhotoPhotographer photoPhotographer);

    public int updatePhotoPhotographer(PhotoPhotographer photoPhotographer);

    public int deletePhotoPhotographerByIds(Long[] ids);

    public int deletePhotoPhotographerById(Long id);

    public int deletePhotoPhotographerByIdAndPhotographerId(Long id, Long photographerId);

    public PhotoPhotographer selectPhotoPhotographerByUserId(Long userId);

    public PhotoPhotographer selectPhotoPhotographerByShareCode(String shareCode);
}
