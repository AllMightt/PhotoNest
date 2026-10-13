package com.ruoyi.file.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.unit.DataSize;
import jakarta.servlet.MultipartConfigElement;

/**
 * 文件上传限制配置。
 *
 * @author PhotoNest
 */
@Configuration
public class UploadConfig
{
    @Value("${spring.servlet.multipart.max-file-size:20MB}")
    private String maxFileSize;

    @Value("${spring.servlet.multipart.max-request-size:20MB}")
    private String maxRequestSize;

    @Bean
    public MultipartConfigElement multipartConfigElement()
    {
        return new MultipartConfigElement("", DataSize.parse(maxFileSize).toBytes(),
                DataSize.parse(maxRequestSize).toBytes(), 0);
    }
}
