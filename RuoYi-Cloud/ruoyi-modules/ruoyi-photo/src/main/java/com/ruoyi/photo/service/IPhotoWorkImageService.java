package com.ruoyi.photo.service;

import java.util.List;
import com.ruoyi.photo.domain.PhotoWorkImage;

/**
 * PhotoNest作品图片Service接口
 */
public interface IPhotoWorkImageService
{
    public PhotoWorkImage selectPhotoWorkImageById(Long id);

    public PhotoWorkImage selectPhotoWorkImageByIdAndPhotographerId(Long id, Long photographerId);

    public List<PhotoWorkImage> selectPhotoWorkImageList(PhotoWorkImage photoWorkImage);

    public int insertPhotoWorkImage(PhotoWorkImage photoWorkImage);

    public int updatePhotoWorkImage(PhotoWorkImage photoWorkImage);

    public int deletePhotoWorkImageByIds(Long[] ids);

    public int deletePhotoWorkImageById(Long id);

    public int deletePhotoWorkImageByIdAndPhotographerId(Long id, Long photographerId);
}
