package com.ruoyi.photo.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.photo.domain.PhotoWork;

/**
 * PhotoNest作品组Mapper接口
 */
public interface PhotoWorkMapper
{
    public PhotoWork selectPhotoWorkById(Long id);

    public List<PhotoWork> selectPhotoWorkList(PhotoWork photoWork);

    public int insertPhotoWork(PhotoWork photoWork);

    public int updatePhotoWork(PhotoWork photoWork);

    public int deletePhotoWorkById(Long id);

    public int deletePhotoWorkByIds(Long[] ids);

    public int deletePhotoWorkByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public PhotoWork selectPhotoWorkByIdAndPhotographerId(@Param("id") Long id, @Param("photographerId") Long photographerId);

    public List<PhotoWork> selectHomeRecommendList(@Param("photographerId") Long photographerId, @Param("limit") Integer limit);

    public List<PhotoWork> selectHomeLatestList(@Param("photographerId") Long photographerId, @Param("limit") Integer limit);

    public List<PhotoWork> selectAppPhotoWorkList(PhotoWork photoWork);
}
