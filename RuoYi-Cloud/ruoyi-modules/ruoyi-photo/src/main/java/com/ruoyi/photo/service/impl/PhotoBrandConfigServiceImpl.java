package com.ruoyi.photo.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.photo.domain.PhotoBrandConfig;
import com.ruoyi.photo.mapper.PhotoBrandConfigMapper;
import com.ruoyi.photo.service.IPhotoBrandConfigService;

/**
 * PhotoNest摄影师品牌主页配置Service业务层处理
 */
@Service
public class PhotoBrandConfigServiceImpl implements IPhotoBrandConfigService
{
    @Autowired
    private PhotoBrandConfigMapper photoBrandConfigMapper;

    @Override
    public PhotoBrandConfig selectPhotoBrandConfigById(Long id)
    {
        return photoBrandConfigMapper.selectPhotoBrandConfigById(id);
    }

    @Override
    public PhotoBrandConfig selectPhotoBrandConfigByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoBrandConfigMapper.selectPhotoBrandConfigByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public List<PhotoBrandConfig> selectPhotoBrandConfigList(PhotoBrandConfig photoBrandConfig)
    {
        return photoBrandConfigMapper.selectPhotoBrandConfigList(photoBrandConfig);
    }

    @Override
    public int insertPhotoBrandConfig(PhotoBrandConfig photoBrandConfig)
    {
        return photoBrandConfigMapper.insertPhotoBrandConfig(photoBrandConfig);
    }

    @Override
    public int updatePhotoBrandConfig(PhotoBrandConfig photoBrandConfig)
    {
        return photoBrandConfigMapper.updatePhotoBrandConfig(photoBrandConfig);
    }

    @Override
    public int deletePhotoBrandConfigByIds(Long[] ids)
    {
        return photoBrandConfigMapper.deletePhotoBrandConfigByIds(ids);
    }

    @Override
    public int deletePhotoBrandConfigById(Long id)
    {
        return photoBrandConfigMapper.deletePhotoBrandConfigById(id);
    }

    @Override
    public int deletePhotoBrandConfigByIdAndPhotographerId(Long id, Long photographerId)
    {
        return photoBrandConfigMapper.deletePhotoBrandConfigByIdAndPhotographerId(id, photographerId);
    }

    @Override
    public PhotoBrandConfig selectPhotoBrandConfigByPhotographerId(Long photographerId)
    {
        return photoBrandConfigMapper.selectPhotoBrandConfigByPhotographerId(photographerId);
    }
}
