package com.ruoyi.photo.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.photo.domain.PhotoBrandConfig;

/**
 * PhotoNest摄影师品牌主页配置Mapper接口
 */
public interface PhotoBrandConfigMapper
{
    public PhotoBrandConfig selectPhotoBrandConfigById(Long id);

    public List<PhotoBrandConfig> selectPhotoBrandConfigList(PhotoBrandConfig photoBrandConfig);

    public int insertPhotoBrandConfig(PhotoBrandConfig photoBrandConfig);

    public int updatePhotoBrandConfig(PhotoBrandConfig photoBrandConfig);

    public int deletePhotoBrandConfigById(Long id);

    public int deletePhotoBrandConfigByIds(Long[] ids);

    public int deletePhotoBrandConfigByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoBrandConfig selectPhotoBrandConfigByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoBrandConfig selectPhotoBrandConfigByPhotographerId(Long photographerId);
}
