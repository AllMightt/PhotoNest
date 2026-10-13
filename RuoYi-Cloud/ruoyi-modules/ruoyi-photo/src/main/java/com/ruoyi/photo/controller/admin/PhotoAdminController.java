package com.ruoyi.photo.controller.admin;

import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.utils.StringUtils;
import com.ruoyi.common.core.web.controller.BaseController;
import com.ruoyi.common.core.web.domain.AjaxResult;
import com.ruoyi.common.core.web.page.TableDataInfo;
import com.ruoyi.common.security.annotation.RequiresPermissions;
import com.ruoyi.common.security.utils.SecurityUtils;
import com.ruoyi.photo.domain.PhotoBrandConfig;
import com.ruoyi.photo.domain.PhotoBooking;
import com.ruoyi.photo.domain.PhotoPackage;
import com.ruoyi.photo.domain.PhotoPackageItem;
import com.ruoyi.photo.domain.PhotoPhotographer;
import com.ruoyi.photo.domain.PhotoWork;
import com.ruoyi.photo.domain.PhotoWorkCategory;
import com.ruoyi.photo.domain.PhotoWorkImage;
import com.ruoyi.photo.service.IPhotoBrandConfigService;
import com.ruoyi.photo.service.IPhotoBookingService;
import com.ruoyi.photo.service.IPhotoPackageItemService;
import com.ruoyi.photo.service.IPhotoPackageService;
import com.ruoyi.photo.service.IPhotoPhotographerService;
import com.ruoyi.photo.service.IPhotoWorkCategoryService;
import com.ruoyi.photo.service.IPhotoWorkImageService;
import com.ruoyi.photo.service.IPhotoWorkService;

/**
 * PhotoNest平台管理端接口。
 */
@RestController
@RequestMapping("/photo/admin")
public class PhotoAdminController extends BaseController
{
    @Autowired private IPhotoPhotographerService photographerService;
    @Autowired private IPhotoBrandConfigService brandConfigService;
    @Autowired private IPhotoWorkCategoryService categoryService;
    @Autowired private IPhotoWorkService workService;
    @Autowired private IPhotoWorkImageService workImageService;
    @Autowired private IPhotoPackageService packageService;
    @Autowired private IPhotoPackageItemService packageItemService;
    @Autowired private IPhotoBookingService bookingService;

    @RequiresPermissions("photo:photographer:list")
    @GetMapping("/photographer/list")
    public TableDataInfo photographerList(PhotoPhotographer photographer)
    {
        startPage();
        return getDataTable(photographerService.selectPhotoPhotographerList(photographer));
    }

    @RequiresPermissions("photo:photographer:query")
    @GetMapping("/photographer/{id}")
    public AjaxResult photographerInfo(@PathVariable Long id)
    {
        return success(photographerService.selectPhotoPhotographerById(id));
    }

    @RequiresPermissions("photo:photographer:add")
    @PostMapping("/photographer")
    public AjaxResult addPhotographer(@RequestBody PhotoPhotographer photographer)
    {
        if (StringUtils.isBlank(photographer.getShareCode()))
        {
            photographer.setShareCode("pn_" + UUID.randomUUID().toString().replace("-", "").substring(0, 10));
        }
        photographer.setCreateBy(SecurityUtils.getUsername());
        return toAjax(photographerService.insertPhotoPhotographer(photographer));
    }

    @RequiresPermissions("photo:photographer:edit")
    @PutMapping("/photographer")
    public AjaxResult editPhotographer(@RequestBody PhotoPhotographer photographer)
    {
        photographer.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(photographerService.updatePhotoPhotographer(photographer));
    }

    @RequiresPermissions("photo:photographer:status")
    @PutMapping("/photographer/status")
    public AjaxResult changePhotographerStatus(@RequestBody PhotoPhotographer photographer)
    {
        photographer.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(photographerService.updatePhotoPhotographer(photographer));
    }

    @RequiresPermissions("photo:photographer:remove")
    @DeleteMapping("/photographer/{ids}")
    public AjaxResult removePhotographer(@PathVariable Long[] ids)
    {
        return toAjax(photographerService.deletePhotoPhotographerByIds(ids));
    }

    @RequiresPermissions("photo:brand:view")
    @GetMapping("/brand/{photographerId}")
    public AjaxResult brandInfo(@PathVariable Long photographerId)
    {
        return success(brandConfigService.selectPhotoBrandConfigByPhotographerId(photographerId));
    }

    @RequiresPermissions("photo:brand:edit")
    @PutMapping("/brand")
    public AjaxResult editBrand(@RequestBody PhotoBrandConfig brandConfig)
    {
        brandConfig.setUpdateBy(SecurityUtils.getUsername());
        if (brandConfig.getId() == null)
        {
            brandConfig.setCreateBy(SecurityUtils.getUsername());
            return toAjax(brandConfigService.insertPhotoBrandConfig(brandConfig));
        }
        return toAjax(brandConfigService.updatePhotoBrandConfig(brandConfig));
    }

    @RequiresPermissions("photo:category:list")
    @GetMapping("/category/list")
    public TableDataInfo categoryList(PhotoWorkCategory category)
    {
        startPage();
        return getDataTable(categoryService.selectPhotoWorkCategoryList(category));
    }

    @RequiresPermissions("photo:category:list")
    @GetMapping("/category/{id}")
    public AjaxResult categoryInfo(@PathVariable Long id)
    {
        return success(categoryService.selectPhotoWorkCategoryById(id));
    }

    @RequiresPermissions("photo:category:add")
    @PostMapping("/category")
    public AjaxResult addCategory(@RequestBody PhotoWorkCategory category)
    {
        category.setCreateBy(SecurityUtils.getUsername());
        return toAjax(categoryService.insertPhotoWorkCategory(category));
    }

    @RequiresPermissions("photo:category:edit")
    @PutMapping("/category")
    public AjaxResult editCategory(@RequestBody PhotoWorkCategory category)
    {
        category.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(categoryService.updatePhotoWorkCategory(category));
    }

    @RequiresPermissions("photo:category:remove")
    @DeleteMapping("/category/{ids}")
    public AjaxResult removeCategory(@PathVariable Long[] ids)
    {
        return toAjax(categoryService.deletePhotoWorkCategoryByIds(ids));
    }

    @RequiresPermissions("photo:work:list")
    @GetMapping("/work/list")
    public TableDataInfo workList(PhotoWork work)
    {
        startPage();
        return getDataTable(workService.selectPhotoWorkList(work));
    }

    @RequiresPermissions("photo:work:list")
    @GetMapping("/work/{id}")
    public AjaxResult workInfo(@PathVariable Long id)
    {
        return success(workService.selectPhotoWorkById(id));
    }

    @RequiresPermissions("photo:work:add")
    @PostMapping("/work")
    public AjaxResult addWork(@RequestBody PhotoWork work)
    {
        work.setCreateBy(SecurityUtils.getUsername());
        return toAjax(workService.insertPhotoWork(work));
    }

    @RequiresPermissions("photo:work:edit")
    @PutMapping("/work")
    public AjaxResult editWork(@RequestBody PhotoWork work)
    {
        work.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(workService.updatePhotoWork(work));
    }

    @RequiresPermissions("photo:work:status")
    @PutMapping("/work/status")
    public AjaxResult changeWorkStatus(@RequestBody PhotoWork work)
    {
        work.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(workService.updatePhotoWork(work));
    }

    @RequiresPermissions("photo:work:remove")
    @DeleteMapping("/work/{ids}")
    public AjaxResult removeWork(@PathVariable Long[] ids)
    {
        return toAjax(workService.deletePhotoWorkByIds(ids));
    }

    @RequiresPermissions("photo:workImage:list")
    @GetMapping("/workImage/list")
    public TableDataInfo workImageList(PhotoWorkImage image)
    {
        startPage();
        return getDataTable(workImageService.selectPhotoWorkImageList(image));
    }

    @RequiresPermissions("photo:workImage:list")
    @GetMapping("/workImage/{id}")
    public AjaxResult workImageInfo(@PathVariable Long id)
    {
        return success(workImageService.selectPhotoWorkImageById(id));
    }

    @RequiresPermissions("photo:workImage:add")
    @PostMapping("/workImage")
    public AjaxResult addWorkImage(@RequestBody PhotoWorkImage image)
    {
        image.setCreateBy(SecurityUtils.getUsername());
        return toAjax(workImageService.insertPhotoWorkImage(image));
    }

    @RequiresPermissions("photo:workImage:edit")
    @PutMapping("/workImage")
    public AjaxResult editWorkImage(@RequestBody PhotoWorkImage image)
    {
        image.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(workImageService.updatePhotoWorkImage(image));
    }

    @RequiresPermissions("photo:workImage:remove")
    @DeleteMapping("/workImage/{ids}")
    public AjaxResult removeWorkImage(@PathVariable Long[] ids)
    {
        return toAjax(workImageService.deletePhotoWorkImageByIds(ids));
    }

    @RequiresPermissions("photo:package:list")
    @GetMapping("/package/list")
    public TableDataInfo packageList(PhotoPackage photoPackage)
    {
        startPage();
        return getDataTable(packageService.selectPhotoPackageList(photoPackage));
    }

    @RequiresPermissions("photo:package:list")
    @GetMapping("/package/{id}")
    public AjaxResult packageInfo(@PathVariable Long id)
    {
        return success(packageService.selectPhotoPackageById(id));
    }

    @RequiresPermissions("photo:package:add")
    @PostMapping("/package")
    public AjaxResult addPackage(@RequestBody PhotoPackage photoPackage)
    {
        photoPackage.setCreateBy(SecurityUtils.getUsername());
        return toAjax(packageService.insertPhotoPackage(photoPackage));
    }

    @RequiresPermissions("photo:package:edit")
    @PutMapping("/package")
    public AjaxResult editPackage(@RequestBody PhotoPackage photoPackage)
    {
        photoPackage.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(packageService.updatePhotoPackage(photoPackage));
    }

    @RequiresPermissions("photo:package:status")
    @PutMapping("/package/status")
    public AjaxResult changePackageStatus(@RequestBody PhotoPackage photoPackage)
    {
        photoPackage.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(packageService.updatePhotoPackage(photoPackage));
    }

    @RequiresPermissions("photo:package:remove")
    @DeleteMapping("/package/{ids}")
    public AjaxResult removePackage(@PathVariable Long[] ids)
    {
        return toAjax(packageService.deletePhotoPackageByIds(ids));
    }

    @RequiresPermissions("photo:packageItem:list")
    @GetMapping("/packageItem/list")
    public TableDataInfo packageItemList(PhotoPackageItem item)
    {
        startPage();
        return getDataTable(packageItemService.selectPhotoPackageItemList(item));
    }

    @RequiresPermissions("photo:packageItem:list")
    @GetMapping("/packageItem/{id}")
    public AjaxResult packageItemInfo(@PathVariable Long id)
    {
        return success(packageItemService.selectPhotoPackageItemById(id));
    }

    @RequiresPermissions("photo:packageItem:add")
    @PostMapping("/packageItem")
    public AjaxResult addPackageItem(@RequestBody PhotoPackageItem item)
    {
        item.setCreateBy(SecurityUtils.getUsername());
        return toAjax(packageItemService.insertPhotoPackageItem(item));
    }

    @RequiresPermissions("photo:packageItem:edit")
    @PutMapping("/packageItem")
    public AjaxResult editPackageItem(@RequestBody PhotoPackageItem item)
    {
        item.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(packageItemService.updatePhotoPackageItem(item));
    }

    @RequiresPermissions("photo:packageItem:remove")
    @DeleteMapping("/packageItem/{ids}")
    public AjaxResult removePackageItem(@PathVariable Long[] ids)
    {
        return toAjax(packageItemService.deletePhotoPackageItemByIds(ids));
    }

    @RequiresPermissions("photo:booking:list")
    @GetMapping("/booking/list")
    public TableDataInfo bookingList(PhotoBooking booking)
    {
        startPage();
        return getDataTable(bookingService.selectPhotoBookingList(booking));
    }

    @RequiresPermissions("photo:booking:query")
    @GetMapping("/booking/{id}")
    public AjaxResult bookingInfo(@PathVariable Long id)
    {
        return success(bookingService.selectPhotoBookingById(id));
    }

    @RequiresPermissions("photo:booking:status")
    @PutMapping("/booking/status")
    public AjaxResult changeBookingStatus(@RequestBody PhotoBooking booking)
    {
        booking.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(bookingService.updatePhotoBooking(booking));
    }
}
