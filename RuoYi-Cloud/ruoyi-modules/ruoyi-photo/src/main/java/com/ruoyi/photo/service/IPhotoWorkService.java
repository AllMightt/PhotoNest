package com.ruoyi.photo.service;

import java.util.List;
import com.ruoyi.photo.domain.PhotoWork;

/**
 * PhotoNest作品组Service接口
 */
public interface IPhotoWorkService
{
    public PhotoWork selectPhotoWorkById(Long id);

    public PhotoWork selectPhotoWorkByIdAndPhotographerId(Long id, Long photographerId);

    public List<PhotoWork> selectPhotoWorkList(PhotoWork photoWork);

    public int insertPhotoWork(PhotoWork photoWork);

    public int updatePhotoWork(PhotoWork photoWork);

    public int deletePhotoWorkByIds(Long[] ids);

    public int deletePhotoWorkById(Long id);

    public int deletePhotoWorkByIdAndPhotographerId(Long id, Long photographerId);

    public List<PhotoWork> selectHomeWorks(Long photographerId, int limit);

    public List<PhotoWork> selectAppPhotoWorkList(PhotoWork photoWork);
}
