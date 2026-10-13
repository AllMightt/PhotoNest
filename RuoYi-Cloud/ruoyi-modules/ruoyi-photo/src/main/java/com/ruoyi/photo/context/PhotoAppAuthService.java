package com.ruoyi.photo.context;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.core.constant.CacheConstants;
import com.ruoyi.common.core.constant.SecurityConstants;
import com.ruoyi.common.core.constant.TokenConstants;
import com.ruoyi.common.core.exception.ServiceException;
import com.ruoyi.common.core.utils.JwtUtils;
import com.ruoyi.common.core.utils.ServletUtils;
import com.ruoyi.common.core.utils.StringUtils;
import com.ruoyi.common.redis.service.RedisService;
import com.ruoyi.photo.domain.PhotoCustomer;
import com.ruoyi.photo.domain.PhotoPhotographer;
import com.ruoyi.photo.service.IPhotoCustomerService;

/**
 * PhotoNest客户小程序登录与当前客户解析。
 */
@Service
public class PhotoAppAuthService
{
    private static final String CUSTOMER_TOKEN_PREFIX = "photo_customer:";

    @Value("${photonest.wechat.appid:}")
    private String appid;

    @Value("${photonest.wechat.secret:}")
    private String secret;

    @Autowired private RedisService redisService;
    @Autowired private PhotoShareCodeService shareCodeService;
    @Autowired private IPhotoCustomerService customerService;

    public Map<String, Object> wechatLogin(String shareCode, String code, String nickname, String avatarUrl)
    {
        PhotoPhotographer photographer = shareCodeService.resolvePhotographer(shareCode);
        String openid = resolveOpenid(code);
        PhotoCustomer customer = customerService.selectPhotoCustomerByOpenidAndPhotographerId(openid, photographer.getId());
        if (customer == null)
        {
            customer = new PhotoCustomer();
            customer.setPhotographerId(photographer.getId());
            customer.setOpenid(openid);
            customer.setNickname(StringUtils.isNotEmpty(nickname) ? nickname : "微信客户");
            customer.setAvatarUrl(StringUtils.isNotEmpty(avatarUrl) ? avatarUrl : "");
            customer.setStatus("0");
            customer.setDelFlag("0");
            customerService.insertPhotoCustomer(customer);
        }
        else
        {
            PhotoCustomer update = new PhotoCustomer();
            update.setId(customer.getId());
            if (StringUtils.isNotEmpty(nickname))
            {
                update.setNickname(nickname);
                customer.setNickname(nickname);
            }
            if (StringUtils.isNotEmpty(avatarUrl))
            {
                update.setAvatarUrl(avatarUrl);
                customer.setAvatarUrl(avatarUrl);
            }
            if (StringUtils.isNotEmpty(nickname) || StringUtils.isNotEmpty(avatarUrl))
            {
                customerService.updatePhotoCustomer(update);
            }
        }

        String tokenKey = CUSTOMER_TOKEN_PREFIX + UUID.randomUUID().toString().replace("-", "");
        Map<String, Object> claimsMap = new HashMap<>();
        claimsMap.put(SecurityConstants.USER_KEY, tokenKey);
        claimsMap.put(SecurityConstants.DETAILS_USER_ID, customer.getId());
        claimsMap.put(SecurityConstants.DETAILS_USERNAME, "photo_customer_" + customer.getId());
        claimsMap.put("photographer_id", photographer.getId());
        claimsMap.put("openid", openid);
        String accessToken = JwtUtils.createToken(claimsMap);

        Map<String, Object> cache = new HashMap<>();
        cache.put("customerId", customer.getId());
        cache.put("photographerId", photographer.getId());
        cache.put("openid", openid);
        cache.put("username", "photo_customer_" + customer.getId());
        cache.put("token", tokenKey);
        redisService.setCacheObject(CacheConstants.LOGIN_TOKEN_KEY + tokenKey, cache, CacheConstants.EXPIRATION, TimeUnit.MINUTES);

        Map<String, Object> result = new HashMap<>();
        result.put("access_token", accessToken);
        result.put("token", accessToken);
        result.put("customer", customer);
        result.put("photographer", photographer);
        return result;
    }

    public PhotoCustomer requireCustomer(String shareCode)
    {
        PhotoPhotographer photographer = shareCodeService.resolvePhotographer(shareCode);
        String token = ServletUtils.getRequest().getHeader(SecurityConstants.AUTHORIZATION_HEADER);
        if (StringUtils.isNotEmpty(token) && token.startsWith(TokenConstants.PREFIX))
        {
            token = token.replaceFirst(TokenConstants.PREFIX, "");
        }
        if (StringUtils.isEmpty(token))
        {
            throw new ServiceException("请先登录后再访问");
        }
        Long customerId = Long.valueOf(JwtUtils.getUserId(token));
        PhotoCustomer customer = customerService.selectPhotoCustomerByIdAndPhotographerId(customerId, photographer.getId());
        if (customer == null)
        {
            throw new ServiceException("当前客户无权访问该摄影师内容");
        }
        return customer;
    }

    private String resolveOpenid(String code)
    {
        if (StringUtils.isEmpty(code))
        {
            throw new ServiceException("微信登录code不能为空");
        }
        if (StringUtils.isEmpty(appid) || StringUtils.isEmpty(secret) || code.startsWith("dev-"))
        {
            return "dev_openid_" + code.replaceAll("[^A-Za-z0-9_\\-]", "_");
        }
        try
        {
            String url = "https://api.weixin.qq.com/sns/jscode2session?appid=" + encode(appid)
                    + "&secret=" + encode(secret)
                    + "&js_code=" + encode(code)
                    + "&grant_type=authorization_code";
            HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            connection.setRequestMethod("GET");
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8)))
            {
                StringBuilder body = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null)
                {
                    body.append(line);
                }
                JSONObject json = JSON.parseObject(body.toString());
                String openid = json.getString("openid");
                if (StringUtils.isEmpty(openid))
                {
                    throw new ServiceException("微信登录失败：" + json.getString("errmsg"));
                }
                return openid;
            }
        }
        catch (Exception e)
        {
            throw new ServiceException("微信登录失败：" + e.getMessage());
        }
    }

    private String encode(String value)
    {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
