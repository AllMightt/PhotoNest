package com.ruoyi.photo.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.photo.domain.PhotoWork;
import com.ruoyi.photo.mapper.PhotoWorkMapper;
import com.ruoyi.photo.service.IPhotoWorkService;

/**
 * PhotoNest作品组Service业务层处理
 */
@Service
public class PhotoWorkServiceImpl implements IPhotoWorkService
{
    @Autowired
    private PhotoWorkMapper photoWorkMapper;

    @Override
    public PhotoWork selectPhotoWorkById(Long id)
    {
        return photoWorkMapper.selectPhotoWorkById(id);
    }

    @Override
    public PhotoWork selectPhotoWorkByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoWorkMapper.selectPhotoWorkByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public List<PhotoWork> selectPhotoWorkList(PhotoWork photoWork)
    {
        return photoWorkMapper.selectPhotoWorkList(photoWork);
    }

    @Override
    public int insertPhotoWork(PhotoWork photoWork)
    {
        return photoWorkMapper.insertPhotoWork(photoWork);
    }

    @Override
    public int updatePhotoWork(PhotoWork photoWork)
    {
        return photoWorkMapper.updatePhotoWork(photoWork);
    }

    @Override
    public int deletePhotoWorkByIds(Long[] ids)
    {
        return photoWorkMapper.deletePhotoWorkByIds(ids);
    }

    @Override
    public int deletePhotoWorkById(Long id)
    {
        return photoWorkMapper.deletePhotoWorkById(id);
    }

    @Override
    public int deletePhotoWorkByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoWorkMapper.deletePhotoWorkByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public List<PhotoWork> selectHomeWorks(Long photographerId, int limit)
    {
        List<PhotoWork> recommendList = photoWorkMapper.selectHomeRecommendList(photographerId, limit);
        if (!recommendList.isEmpty())
        {
            return recommendList;
        }
        return photoWorkMapper.selectHomeLatestList(photographerId, limit);
    }

    @Override
    public List<PhotoWork> selectAppPhotoWorkList(PhotoWork photoWork)
    {
        return photoWorkMapper.selectAppPhotoWorkList(photoWork);
    }
}
