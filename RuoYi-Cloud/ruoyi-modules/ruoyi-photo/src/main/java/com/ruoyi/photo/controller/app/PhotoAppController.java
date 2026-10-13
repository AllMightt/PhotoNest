package com.ruoyi.photo.controller.app;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.web.controller.BaseController;
import com.ruoyi.common.core.web.domain.AjaxResult;
import com.ruoyi.common.core.web.page.TableDataInfo;
import com.ruoyi.photo.context.PhotoAppAuthService;
import com.ruoyi.photo.context.PhotoShareCodeService;
import com.ruoyi.photo.context.PhotoWechatNotifyService;
import com.ruoyi.photo.domain.PhotoBrandConfig;
import com.ruoyi.photo.domain.PhotoBooking;
import com.ruoyi.photo.domain.PhotoCustomer;
import com.ruoyi.photo.domain.PhotoPackage;
import com.ruoyi.photo.domain.PhotoPackageItem;
import com.ruoyi.photo.domain.PhotoPhotographer;
import com.ruoyi.photo.domain.PhotoWork;
import com.ruoyi.photo.domain.PhotoWorkCategory;
import com.ruoyi.photo.domain.PhotoWorkImage;
import com.ruoyi.photo.service.IPhotoBrandConfigService;
import com.ruoyi.photo.service.IPhotoBookingService;
import com.ruoyi.photo.service.IPhotoCustomerService;
import com.ruoyi.photo.service.IPhotoPackageItemService;
import com.ruoyi.photo.service.IPhotoPackageService;
import com.ruoyi.photo.service.IPhotoWorkCategoryService;
import com.ruoyi.photo.service.IPhotoWorkImageService;
import com.ruoyi.photo.service.IPhotoWorkService;

/**
 * PhotoNest客户小程序端接口。
 */
@RestController
@RequestMapping("/photo/app")
public class PhotoAppController extends BaseController
{
    @Autowired private PhotoShareCodeService shareCodeService;
    @Autowired private PhotoAppAuthService appAuthService;
    @Autowired private PhotoWechatNotifyService wechatNotifyService;
    @Autowired private IPhotoBrandConfigService brandConfigService;
    @Autowired private IPhotoWorkService workService;
    @Autowired private IPhotoWorkCategoryService categoryService;
    @Autowired private IPhotoWorkImageService workImageService;
    @Autowired private IPhotoPackageService packageService;
    @Autowired private IPhotoPackageItemService packageItemService;
    @Autowired private IPhotoCustomerService customerService;
    @Autowired private IPhotoBookingService bookingService;

    @PostMapping("/auth/wechat-login")
    public AjaxResult wechatLogin(@RequestBody Map<String, String> body)
    {
        return success(appAuthService.wechatLogin(body.get("shareCode"), body.get("code"), body.get("nickname"), body.get("avatarUrl")));
    }

    @GetMapping("/home/{shareCode}")
    public AjaxResult home(@PathVariable String shareCode)
    {
        appAuthService.requireCustomer(shareCode);
        PhotoPhotographer photographer = shareCodeService.resolvePhotographer(shareCode);
        PhotoBrandConfig brandConfig = brandConfigService.selectPhotoBrandConfigByPhotographerId(photographer.getId());
        List<PhotoWork> homeWorks = workService.selectHomeWorks(photographer.getId(), 8);
        PhotoPackage photoPackage = new PhotoPackage();
        photoPackage.setPhotographerId(photographer.getId());
        List<PhotoPackage> packages = packageService.selectAppPhotoPackageList(photoPackage);
        Map<String, Object> data = new HashMap<>();
        data.put("photographer", photographer);
        data.put("brandConfig", brandConfig);
        data.put("homeWorks", homeWorks);
        data.put("packages", packages);
        return success(data);
    }

    @GetMapping("/about/{shareCode}")
    public AjaxResult about(@PathVariable String shareCode)
    {
        appAuthService.requireCustomer(shareCode);
        PhotoPhotographer photographer = shareCodeService.resolvePhotographer(shareCode);
        return success(brandConfigService.selectPhotoBrandConfigByPhotographerId(photographer.getId()));
    }

    @GetMapping("/work/category/{shareCode}")
    public AjaxResult workCategories(@PathVariable String shareCode)
    {
        appAuthService.requireCustomer(shareCode);
        PhotoPhotographer photographer = shareCodeService.resolvePhotographer(shareCode);
        PhotoWorkCategory category = new PhotoWorkCategory();
        category.setPhotographerId(photographer.getId());
        category.setStatus("0");
        return success(categoryService.selectPhotoWorkCategoryList(category));
    }

    @GetMapping("/work/list/{shareCode}")
    public TableDataInfo workList(@PathVariable String shareCode, PhotoWork work)
    {
        appAuthService.requireCustomer(shareCode);
        PhotoPhotographer photographer = shareCodeService.resolvePhotographer(shareCode);
        work.setPhotographerId(photographer.getId());
        startPage();
        return getDataTable(workService.selectAppPhotoWorkList(work));
    }

    @GetMapping("/work/{shareCode}/{id}")
    public AjaxResult workDetail(@PathVariable String shareCode, @PathVariable Long id)
    {
        appAuthService.requireCustomer(shareCode);
        PhotoPhotographer photographer = shareCodeService.resolvePhotographer(shareCode);
        PhotoWork work = workService.selectPhotoWorkByIdAndPhotographerId(id, photographer.getId());
        if (work == null || !"0".equals(work.getStatus()))
        {
            return error("作品不存在或已下架");
        }
        PhotoWorkImage query = new PhotoWorkImage();
        query.setPhotographerId(photographer.getId());
        query.setWorkId(id);
        query.setStatus("0");
        Map<String, Object> data = new HashMap<>();
        data.put("work", work);
        data.put("images", workImageService.selectPhotoWorkImageList(query));
        return success(data);
    }

    @GetMapping("/package/list/{shareCode}")
    public TableDataInfo packageList(@PathVariable String shareCode, PhotoPackage photoPackage)
    {
        appAuthService.requireCustomer(shareCode);
        PhotoPhotographer photographer = shareCodeService.resolvePhotographer(shareCode);
        photoPackage.setPhotographerId(photographer.getId());
        startPage();
        return getDataTable(packageService.selectAppPhotoPackageList(photoPackage));
    }

    @GetMapping("/package/{shareCode}/{id}")
    public AjaxResult packageDetail(@PathVariable String shareCode, @PathVariable Long id)
    {
        appAuthService.requireCustomer(shareCode);
        PhotoPhotographer photographer = shareCodeService.resolvePhotographer(shareCode);
        PhotoPackage photoPackage = packageService.selectPhotoPackageByIdAndPhotographerId(id, photographer.getId());
        if (photoPackage == null || !"0".equals(photoPackage.getStatus()))
        {
            return error("套系不存在或已下架");
        }
        PhotoPackageItem item = new PhotoPackageItem();
        item.setPhotographerId(photographer.getId());
        item.setPackageId(id);
        Map<String, Object> data = new HashMap<>();
        data.put("package", photoPackage);
        data.put("items", packageItemService.selectPhotoPackageItemList(item));
        return success(data);
    }

    @PostMapping("/booking/{shareCode}")
    public AjaxResult createBooking(@PathVariable String shareCode, @RequestBody PhotoBooking booking)
    {
        PhotoCustomer customer = appAuthService.requireCustomer(shareCode);
        PhotoPhotographer photographer = shareCodeService.resolvePhotographer(shareCode);
        PhotoCustomer updateCustomer = new PhotoCustomer();
        updateCustomer.setId(customer.getId());
        updateCustomer.setRealName(booking.getCustomerName());
        updateCustomer.setPhone(booking.getPhone());
        updateCustomer.setWechatId(booking.getWechatId());
        customerService.updatePhotoCustomer(updateCustomer);

        booking.setPhotographerId(photographer.getId());
        booking.setCustomerId(customer.getId());
        booking.setBookingNo("PN" + System.currentTimeMillis());
        if (booking.getStatus() == null)
        {
            booking.setStatus("0");
        }
        int rows = bookingService.insertPhotoBooking(booking);
        if (rows > 0)
        {
            wechatNotifyService.notifyPhotographerBooking(photographer, booking);
        }
        return toAjax(rows);
    }
}
