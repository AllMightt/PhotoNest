package com.ruoyi.photo.controller.photographer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.web.controller.BaseController;
import com.ruoyi.common.core.web.domain.AjaxResult;
import com.ruoyi.common.core.web.page.TableDataInfo;
import com.ruoyi.common.security.utils.SecurityUtils;
import com.ruoyi.photo.context.PhotographerAuthService;
import com.ruoyi.photo.domain.PhotoBrandConfig;
import com.ruoyi.photo.domain.PhotoBooking;
import com.ruoyi.photo.domain.PhotoPackage;
import com.ruoyi.photo.domain.PhotoPackageItem;
import com.ruoyi.photo.domain.PhotoWork;
import com.ruoyi.photo.domain.PhotoWorkCategory;
import com.ruoyi.photo.domain.PhotoWorkImage;
import com.ruoyi.photo.service.IPhotoBrandConfigService;
import com.ruoyi.photo.service.IPhotoBookingService;
import com.ruoyi.photo.service.IPhotoPackageItemService;
import com.ruoyi.photo.service.IPhotoPackageService;
import com.ruoyi.photo.service.IPhotoWorkCategoryService;
import com.ruoyi.photo.service.IPhotoWorkImageService;
import com.ruoyi.photo.service.IPhotoWorkService;

/**
 * PhotoNest摄影师工作台接口。
 */
@RestController
@RequestMapping("/photo/photographer")
public class PhotoPhotographerWorkbenchController extends BaseController
{
    @Autowired private PhotographerAuthService photographerAuthService;
    @Autowired private IPhotoBrandConfigService brandConfigService;
    @Autowired private IPhotoWorkCategoryService categoryService;
    @Autowired private IPhotoWorkService workService;
    @Autowired private IPhotoWorkImageService workImageService;
    @Autowired private IPhotoPackageService packageService;
    @Autowired private IPhotoPackageItemService packageItemService;
    @Autowired private IPhotoBookingService bookingService;

    @GetMapping("/brand")
    public AjaxResult brandInfo()
    {
        Long photographerId = photographerAuthService.getCurrentPhotographerId();
        return success(brandConfigService.selectPhotoBrandConfigByPhotographerId(photographerId));
    }

    @PutMapping("/brand")
    public AjaxResult editBrand(@RequestBody PhotoBrandConfig brandConfig)
    {
        Long photographerId = photographerAuthService.getCurrentPhotographerId();
        PhotoBrandConfig current = brandConfigService.selectPhotoBrandConfigByPhotographerId(photographerId);
        brandConfig.setPhotographerId(photographerId);
        brandConfig.setUpdateBy(SecurityUtils.getUsername());
        if (current == null)
        {
            brandConfig.setCreateBy(SecurityUtils.getUsername());
            return toAjax(brandConfigService.insertPhotoBrandConfig(brandConfig));
        }
        brandConfig.setId(current.getId());
        return toAjax(brandConfigService.updatePhotoBrandConfig(brandConfig));
    }

    @GetMapping("/category/list")
    public TableDataInfo categoryList(PhotoWorkCategory category)
    {
        category.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        startPage();
        return getDataTable(categoryService.selectPhotoWorkCategoryList(category));
    }

    @PostMapping("/category")
    public AjaxResult addCategory(@RequestBody PhotoWorkCategory category)
    {
        category.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        category.setCreateBy(SecurityUtils.getUsername());
        return toAjax(categoryService.insertPhotoWorkCategory(category));
    }

    @PutMapping("/category")
    public AjaxResult editCategory(@RequestBody PhotoWorkCategory category)
    {
        category.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        category.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(categoryService.updatePhotoWorkCategory(category));
    }

    @DeleteMapping("/category/{id}")
    public AjaxResult removeCategory(@PathVariable Long id)
    {
        return toAjax(categoryService.deletePhotoWorkCategoryByIdAndPhotographerId(id, photographerAuthService.getCurrentPhotographerId()));
    }

    @GetMapping("/work/list")
    public TableDataInfo workList(PhotoWork work)
    {
        work.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        startPage();
        return getDataTable(workService.selectPhotoWorkList(work));
    }

    @GetMapping("/work/{id}")
    public AjaxResult workInfo(@PathVariable Long id)
    {
        return success(workService.selectPhotoWorkByIdAndPhotographerId(id, photographerAuthService.getCurrentPhotographerId()));
    }

    @PostMapping("/work")
    public AjaxResult addWork(@RequestBody PhotoWork work)
    {
        work.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        work.setCreateBy(SecurityUtils.getUsername());
        return toAjax(workService.insertPhotoWork(work));
    }

    @PutMapping("/work")
    public AjaxResult editWork(@RequestBody PhotoWork work)
    {
        Long photographerId = photographerAuthService.getCurrentPhotographerId();
        work.setPhotographerId(photographerId);
        work.setUpdateBy(SecurityUtils.getUsername());
        PhotoWork dbWork = workService.selectPhotoWorkByIdAndPhotographerId(work.getId(), photographerId);
        if (dbWork == null)
        {
            return error("作品不存在或无权操作");
        }
        return toAjax(workService.updatePhotoWork(work));
    }

    @DeleteMapping("/work/{id}")
    public AjaxResult removeWork(@PathVariable Long id)
    {
        return toAjax(workService.deletePhotoWorkByIdAndPhotographerId(id, photographerAuthService.getCurrentPhotographerId()));
    }

    @GetMapping("/workImage/list")
    public TableDataInfo workImageList(PhotoWorkImage image)
    {
        image.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        startPage();
        return getDataTable(workImageService.selectPhotoWorkImageList(image));
    }

    @PostMapping("/workImage")
    public AjaxResult addWorkImage(@RequestBody PhotoWorkImage image)
    {
        image.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        image.setCreateBy(SecurityUtils.getUsername());
        return toAjax(workImageService.insertPhotoWorkImage(image));
    }

    @PutMapping("/workImage")
    public AjaxResult editWorkImage(@RequestBody PhotoWorkImage image)
    {
        Long photographerId = photographerAuthService.getCurrentPhotographerId();
        image.setPhotographerId(photographerId);
        image.setUpdateBy(SecurityUtils.getUsername());
        if (workImageService.selectPhotoWorkImageByIdAndPhotographerId(image.getId(), photographerId) == null)
        {
            return error("作品图片不存在或无权操作");
        }
        return toAjax(workImageService.updatePhotoWorkImage(image));
    }

    @DeleteMapping("/workImage/{id}")
    public AjaxResult removeWorkImage(@PathVariable Long id)
    {
        return toAjax(workImageService.deletePhotoWorkImageByIdAndPhotographerId(id, photographerAuthService.getCurrentPhotographerId()));
    }

    @GetMapping("/package/list")
    public TableDataInfo packageList(PhotoPackage photoPackage)
    {
        photoPackage.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        startPage();
        return getDataTable(packageService.selectPhotoPackageList(photoPackage));
    }

    @GetMapping("/package/{id}")
    public AjaxResult packageInfo(@PathVariable Long id)
    {
        return success(packageService.selectPhotoPackageByIdAndPhotographerId(id, photographerAuthService.getCurrentPhotographerId()));
    }

    @PostMapping("/package")
    public AjaxResult addPackage(@RequestBody PhotoPackage photoPackage)
    {
        photoPackage.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        photoPackage.setCreateBy(SecurityUtils.getUsername());
        return toAjax(packageService.insertPhotoPackage(photoPackage));
    }

    @PutMapping("/package")
    public AjaxResult editPackage(@RequestBody PhotoPackage photoPackage)
    {
        Long photographerId = photographerAuthService.getCurrentPhotographerId();
        photoPackage.setPhotographerId(photographerId);
        photoPackage.setUpdateBy(SecurityUtils.getUsername());
        if (packageService.selectPhotoPackageByIdAndPhotographerId(photoPackage.getId(), photographerId) == null)
        {
            return error("套系不存在或无权操作");
        }
        return toAjax(packageService.updatePhotoPackage(photoPackage));
    }

    @DeleteMapping("/package/{id}")
    public AjaxResult removePackage(@PathVariable Long id)
    {
        return toAjax(packageService.deletePhotoPackageByIdAndPhotographerId(id, photographerAuthService.getCurrentPhotographerId()));
    }

    @GetMapping("/packageItem/list")
    public TableDataInfo packageItemList(PhotoPackageItem item)
    {
        item.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        startPage();
        return getDataTable(packageItemService.selectPhotoPackageItemList(item));
    }

    @PostMapping("/packageItem")
    public AjaxResult addPackageItem(@RequestBody PhotoPackageItem item)
    {
        item.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        item.setCreateBy(SecurityUtils.getUsername());
        return toAjax(packageItemService.insertPhotoPackageItem(item));
    }

    @PutMapping("/packageItem")
    public AjaxResult editPackageItem(@RequestBody PhotoPackageItem item)
    {
        Long photographerId = photographerAuthService.getCurrentPhotographerId();
        item.setPhotographerId(photographerId);
        item.setUpdateBy(SecurityUtils.getUsername());
        if (packageItemService.selectPhotoPackageItemByIdAndPhotographerId(item.getId(), photographerId) == null)
        {
            return error("套系明细不存在或无权操作");
        }
        return toAjax(packageItemService.updatePhotoPackageItem(item));
    }

    @DeleteMapping("/packageItem/{id}")
    public AjaxResult removePackageItem(@PathVariable Long id)
    {
        return toAjax(packageItemService.deletePhotoPackageItemByIdAndPhotographerId(id, photographerAuthService.getCurrentPhotographerId()));
    }

    @GetMapping("/booking/list")
    public TableDataInfo bookingList(PhotoBooking booking)
    {
        booking.setPhotographerId(photographerAuthService.getCurrentPhotographerId());
        startPage();
        return getDataTable(bookingService.selectPhotoBookingList(booking));
    }

    @GetMapping("/booking/{id}")
    public AjaxResult bookingInfo(@PathVariable Long id)
    {
        return success(bookingService.selectPhotoBookingByIdAndPhotographerId(id, photographerAuthService.getCurrentPhotographerId()));
    }

    @PutMapping("/booking/status")
    public AjaxResult changeBookingStatus(@RequestBody PhotoBooking booking)
    {
        Long photographerId = photographerAuthService.getCurrentPhotographerId();
        booking.setPhotographerId(photographerId);
        booking.setUpdateBy(SecurityUtils.getUsername());
        if (bookingService.selectPhotoBookingByIdAndPhotographerId(booking.getId(), photographerId) == null)
        {
            return error("预约咨询不存在或无权操作");
        }
        return toAjax(bookingService.updatePhotoBooking(booking));
    }
}
