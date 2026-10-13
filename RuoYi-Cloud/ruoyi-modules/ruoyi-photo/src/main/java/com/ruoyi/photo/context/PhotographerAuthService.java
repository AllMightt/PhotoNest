package com.ruoyi.photo.context;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.exception.ServiceException;
import com.ruoyi.common.security.utils.SecurityUtils;
import com.ruoyi.photo.domain.PhotoPhotographer;
import com.ruoyi.photo.service.IPhotoPhotographerService;

/**
 * 摄影师身份解析服务。
 */
@Service
public class PhotographerAuthService
{
    @Autowired
    private IPhotoPhotographerService photographerService;

    /**
     * 根据当前登录 userId 获取摄影师主体ID。
     *
     * TODO 后续接入摄影师专属登录/角色后，可在 token 中缓存 photographerId。
     */
    public Long getCurrentPhotographerId()
    {
        Long userId = SecurityUtils.getUserId();
        if (userId == null)
        {
            throw new ServiceException("未获取到当前登录用户");
        }
        PhotoPhotographer photographer = photographerService.selectPhotoPhotographerByUserId(userId);
        if (photographer == null)
        {
            throw new ServiceException("当前用户未绑定摄影师账号");
        }
        return photographer.getId();
    }

    public PhotoPhotographer getCurrentPhotographer()
    {
        Long photographerId = getCurrentPhotographerId();
        return photographerService.selectPhotoPhotographerById(photographerId);
    }
}
