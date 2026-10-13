package com.ruoyi.photo.context;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.ruoyi.photo.domain.PhotoBooking;
import com.ruoyi.photo.domain.PhotoPhotographer;

/**
 * 预约提交后的摄影师微信服务通知。
 */
@Service
public class PhotoWechatNotifyService
{
    private static final Logger log = LoggerFactory.getLogger(PhotoWechatNotifyService.class);

    public void notifyPhotographerBooking(PhotoPhotographer photographer, PhotoBooking booking)
    {
        // TODO 配置小程序模板ID、摄影师openid后，调用微信订阅消息接口发送服务通知。
        log.info("PhotoNest booking notification pending, photographerId={}, bookingNo={}, customerName={}, phone={}, expectedDate={}, expectedTime={}",
                photographer.getId(), booking.getBookingNo(), booking.getCustomerName(), booking.getPhone(),
                booking.getExpectedDate(), booking.getExpectedTime());
    }
}
