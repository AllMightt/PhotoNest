package com.ruoyi.photo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.ruoyi.common.security.annotation.EnableCustomConfig;
import com.ruoyi.common.security.annotation.EnableRyFeignClients;

/**
 * PhotoNest摄影业务模块
 */
@EnableCustomConfig
@EnableRyFeignClients
@SpringBootApplication
public class RuoYiPhotoApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(RuoYiPhotoApplication.class, args);
        System.out.println("PhotoNest摄影业务模块启动成功");
    }
}
