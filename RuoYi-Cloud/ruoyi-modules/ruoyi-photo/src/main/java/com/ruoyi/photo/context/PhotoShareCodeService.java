package com.ruoyi.photo.context;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.exception.ServiceException;
import com.ruoyi.common.core.utils.StringUtils;
import com.ruoyi.photo.domain.PhotoPhotographer;
import com.ruoyi.photo.service.IPhotoPhotographerService;

/**
 * 客户端 shareCode 解析服务。
 */
@Service
public class PhotoShareCodeService
{
    @Autowired
    private IPhotoPhotographerService photographerService;

    public PhotoPhotographer resolvePhotographer(String shareCode)
    {
        if (StringUtils.isBlank(shareCode))
        {
            throw new ServiceException("shareCode不能为空");
        }
        PhotoPhotographer photographer = photographerService.selectPhotoPhotographerByShareCode(shareCode);
        if (photographer == null)
        {
            throw new ServiceException("摄影师主页不存在或已停用");
        }
        return photographer;
    }
}
