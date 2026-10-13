package com.ruoyi.photo.service;

import java.util.List;
import com.ruoyi.photo.domain.PhotoBrandConfig;

/**
 * PhotoNest摄影师品牌主页配置Service接口
 */
public interface IPhotoBrandConfigService
{
    public PhotoBrandConfig selectPhotoBrandConfigById(Long id);

    public PhotoBrandConfig selectPhotoBrandConfigByIdAndPhotographerId(Long id, Long photographerId);

    public List<PhotoBrandConfig> selectPhotoBrandConfigList(PhotoBrandConfig photoBrandConfig);

    public int insertPhotoBrandConfig(PhotoBrandConfig photoBrandConfig);

    public int updatePhotoBrandConfig(PhotoBrandConfig photoBrandConfig);

    public int deletePhotoBrandConfigByIds(Long[] ids);

    public int deletePhotoBrandConfigById(Long id);

    public int deletePhotoBrandConfigByIdAndPhotographerId(Long id, Long photographerId);

    public PhotoBrandConfig selectPhotoBrandConfigByPhotographerId(Long photographerId);
}
