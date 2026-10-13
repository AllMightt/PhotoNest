package com.ruoyi.file.utils;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import org.apache.commons.io.FilenameUtils;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.core.exception.file.FileException;
import com.ruoyi.common.core.exception.file.FileNameLengthLimitExceededException;
import com.ruoyi.common.core.exception.file.FileSizeLimitExceededException;
import com.ruoyi.common.core.exception.file.InvalidExtensionException;
import com.ruoyi.common.core.utils.DateUtils;
import com.ruoyi.common.core.utils.StringUtils;
import com.ruoyi.common.core.utils.file.FileTypeUtils;
import com.ruoyi.common.core.utils.file.MimeTypeUtils;
import com.ruoyi.common.core.utils.uuid.Seq;

/**
 * 文件上传工具类
 * 
 * @author ruoyi
 */
public class FileUploadUtils
{
    /**
     * 默认大小 50M
     */
    public static final long DEFAULT_MAX_SIZE = 50 * 1024 * 1024L;

    /**
     * 默认的文件名最大长度 100
     */
    public static final int DEFAULT_FILE_NAME_LENGTH = 100;

    /**
     * 根据文件路径上传
     *
     * @param baseDir 相对应用的基目录
     * @param file 上传的文件
     * @return 文件名称
     * @throws IOException
     */
    public static final String upload(String baseDir, MultipartFile file) throws IOException
    {
        try
        {
            return upload(baseDir, file, MimeTypeUtils.DEFAULT_ALLOWED_EXTENSION);
        }
        catch (FileException fe)
        {
            throw new IOException(fe.getDefaultMessage(), fe);
        }
        catch (Exception e)
        {
            throw new IOException(e.getMessage(), e);
        }
    }

    /**
     * 文件上传
     *
     * @param baseDir 相对应用的基目录
     * @param file 上传的文件
     * @param allowedExtension 上传文件类型
     * @return 返回上传成功的文件名
     * @throws FileSizeLimitExceededException 如果超出最大大小
     * @throws FileNameLengthLimitExceededException 文件名太长
     * @throws IOException 比如读写文件出错时
     * @throws InvalidExtensionException 文件校验异常
     */
    public static final String upload(String baseDir, MultipartFile file, String[] allowedExtension)
            throws FileSizeLimitExceededException, IOException, FileNameLengthLimitExceededException,
            InvalidExtensionException
    {
        int fileNamelength = Objects.requireNonNull(file.getOriginalFilename()).length();
        if (fileNamelength > FileUploadUtils.DEFAULT_FILE_NAME_LENGTH)
        {
            throw new FileNameLengthLimitExceededException(FileUploadUtils.DEFAULT_FILE_NAME_LENGTH);
        }

        assertAllowed(file, allowedExtension);

        String fileName = extractFilename(file);

        String absPath = getAbsoluteFile(baseDir, fileName).getAbsolutePath();
        if (isHeicImage(file))
        {
            fileName = replaceExtension(fileName, "jpg");
            absPath = getAbsoluteFile(baseDir, fileName).getAbsolutePath();
            convertHeicToJpeg(file, Paths.get(absPath));
            return getPathFileName(fileName);
        }
        file.transferTo(Paths.get(absPath));
        return getPathFileName(fileName);
    }

    /**
     * 编码文件名
     */
    public static final String extractFilename(MultipartFile file)
    {
        return StringUtils.format("{}/{}_{}.{}", DateUtils.datePath(),
                FilenameUtils.getBaseName(file.getOriginalFilename()), Seq.getId(Seq.uploadSeqType), FileTypeUtils.getExtension(file));
    }

    private static final File getAbsoluteFile(String uploadDir, String fileName) throws IOException
    {
        File desc = new File(uploadDir + File.separator + fileName);

        if (!desc.exists())
        {
            if (!desc.getParentFile().exists())
            {
                desc.getParentFile().mkdirs();
            }
        }
        return desc.isAbsolute() ? desc : desc.getAbsoluteFile();
    }

    private static final String getPathFileName(String fileName) throws IOException
    {
        String pathFileName = "/" + fileName;
        return pathFileName;
    }

    private static boolean isHeicImage(MultipartFile file) throws IOException
    {
        byte[] header = new byte[32];
        int len;
        try (InputStream inputStream = file.getInputStream())
        {
            len = inputStream.read(header);
        }
        if (len < 12)
        {
            return false;
        }
        String signature = new String(header, 4, Math.max(0, len - 4), java.nio.charset.StandardCharsets.ISO_8859_1);
        return signature.contains("ftypheic") || signature.contains("ftypheix")
                || signature.contains("ftyphevc") || signature.contains("ftyphevx")
                || signature.contains("ftypmif1") || signature.contains("ftypmsf1");
    }

    private static String replaceExtension(String fileName, String extension)
    {
        return FilenameUtils.removeExtension(fileName) + "." + extension;
    }

    private static void convertHeicToJpeg(MultipartFile file, Path targetPath) throws IOException
    {
        Files.createDirectories(targetPath.getParent());
        Path tempFile = Files.createTempFile("ruoyi-heic-", ".heic");
        try
        {
            file.transferTo(tempFile);
            List<String> command = Arrays.asList(resolveMagickCommand(), tempFile.toString(), targetPath.toString());
            Process process = new ProcessBuilder(command).redirectErrorStream(true).start();
            try
            {
                if (process.waitFor() != 0)
                {
                    throw new IOException("HEIC图片转换失败，请确认已安装ImageMagick并支持HEIC格式");
                }
            }
            catch (InterruptedException e)
            {
                Thread.currentThread().interrupt();
                throw new IOException("HEIC图片转换被中断", e);
            }
        }
        finally
        {
            Files.deleteIfExists(tempFile);
        }
    }

    private static String resolveMagickCommand()
    {
        String configured = System.getenv("PHOTONEST_MAGICK_PATH");
        if (StringUtils.isNotEmpty(configured))
        {
            return configured;
        }
        String[] candidates = { "/opt/homebrew/bin/magick", "/usr/local/bin/magick", "magick" };
        for (String candidate : candidates)
        {
            if (candidate.contains(File.separator) && Files.isExecutable(Paths.get(candidate)))
            {
                return candidate;
            }
        }
        return "magick";
    }

    /**
     * 文件大小校验
     *
     * @param file 上传的文件
     * @throws FileSizeLimitExceededException 如果超出最大大小
     * @throws InvalidExtensionException 文件校验异常
     */
    public static final void assertAllowed(MultipartFile file, String[] allowedExtension)
            throws FileSizeLimitExceededException, InvalidExtensionException
    {
        long size = file.getSize();
        if (size > DEFAULT_MAX_SIZE)
        {
            throw new FileSizeLimitExceededException(DEFAULT_MAX_SIZE / 1024 / 1024);
        }

        String fileName = file.getOriginalFilename();
        String extension = FileTypeUtils.getExtension(file);
        if (allowedExtension != null && !isAllowedExtension(extension, allowedExtension))
        {
            if (allowedExtension == MimeTypeUtils.IMAGE_EXTENSION)
            {
                throw new InvalidExtensionException.InvalidImageExtensionException(allowedExtension, extension,
                        fileName);
            }
            else if (allowedExtension == MimeTypeUtils.FLASH_EXTENSION)
            {
                throw new InvalidExtensionException.InvalidFlashExtensionException(allowedExtension, extension,
                        fileName);
            }
            else if (allowedExtension == MimeTypeUtils.MEDIA_EXTENSION)
            {
                throw new InvalidExtensionException.InvalidMediaExtensionException(allowedExtension, extension,
                        fileName);
            }
            else if (allowedExtension == MimeTypeUtils.VIDEO_EXTENSION)
            {
                throw new InvalidExtensionException.InvalidVideoExtensionException(allowedExtension, extension,
                        fileName);
            }
            else
            {
                throw new InvalidExtensionException(allowedExtension, extension, fileName);
            }
        }
    }

    /**
     * 判断MIME类型是否是允许的MIME类型
     *
     * @param extension 上传文件类型
     * @param allowedExtension 允许上传文件类型
     * @return true/false
     */
    public static final boolean isAllowedExtension(String extension, String[] allowedExtension)
    {
        for (String str : allowedExtension)
        {
            if (str.equalsIgnoreCase(extension))
            {
                return true;
            }
        }
        return false;
    }
}
