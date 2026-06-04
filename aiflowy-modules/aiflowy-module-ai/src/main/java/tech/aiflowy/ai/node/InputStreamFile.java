package tech.aiflowy.ai.node;

import cn.hutool.core.io.FileUtil;
import org.jetbrains.annotations.NotNull;
import org.springframework.web.multipart.MultipartFile;
import tech.aiflowy.common.util.StringUtil;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.UUID;

/**
 * 基于 InputStream 实现的 MultipartFile，用于将输入流转换为 Spring MVC 的文件上传对象
 */
public class InputStreamFile implements MultipartFile {

    private final Map<String, String> headers;
    private final String name;
    private byte[] bytes;
    private boolean loaded = false;

    /**
     * 构造函数
     *
     * @param inputStream 输入流
     * @param headers     HTTP 请求头信息
     */
    public InputStreamFile(InputStream inputStream, Map<String, String> headers) {
        this.headers = headers;

        // 解析文件名
        this.name = parseFileName(headers);

        // 懒加载：在首次需要时读取流数据
        if (inputStream != null) {
            try {
                loadBytes(inputStream);
            } catch (IOException e) {
                throw new RuntimeException("Failed to read input stream", e);
            }
        }
    }

    /**
     * 从输入流加载字节数据
     */
    private synchronized void loadBytes(InputStream inputStream) throws IOException {
        if (loaded) {
            return;
        }

        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        byte[] buffer = new byte[4096];
        int bytesRead;
        while ((bytesRead = inputStream.read(buffer)) != -1) {
            bos.write(buffer, 0, bytesRead);
        }
        this.bytes = bos.toByteArray();
        this.loaded = true;

        // 关闭输入流（如果支持）
        try {
            inputStream.close();
        } catch (IOException e) {
            // 忽略关闭异常
        }
    }

    /**
     * 解析文件名
     */
    private String parseFileName(Map<String, String> headers) {
        // 优先从 Content-Disposition 解析
        String contentDisposition = headers.get("Content-Disposition");
        if (StringUtil.hasText(contentDisposition)) {
            try {
                String[] parts = contentDisposition.split(";");
                for (String part : parts) {
                    part = part.trim();
                    if (part.startsWith("filename=")) {
                        String filename = part.substring("filename=".length());
                        filename = filename.replace("\"", "").trim();
                        if (StringUtil.hasText(filename)) {
                            return filename;
                        }
                    }
                }
            } catch (Exception e) {
                // 解析失败，继续尝试其他方式
            }
        }

        // 从 Content-Type 推断扩展名
        String contentType = headers.get("Content-Type");
        if (StringUtil.hasText(contentType)) {
            try {
                String suffix = contentType.split("/")[1].split(";")[0].trim();
                return UUID.randomUUID() + "." + suffix;
            } catch (Exception e) {
                // 忽略
            }
        }

        // 默认生成 UUID 文件名
        return UUID.randomUUID().toString();
    }

    @NotNull
    @Override
    public String getName() {
        return this.name != null ? this.name : "file";
    }

    @Override
    public String getOriginalFilename() {
        return this.name;
    }

    @Override
    public String getContentType() {
        return headers != null ? headers.get("Content-Type") : null;
    }

    @Override
    public boolean isEmpty() {
        return bytes == null || bytes.length == 0;
    }

    @Override
    public long getSize() {
        return bytes != null ? bytes.length : 0;
    }

    @NotNull
    @Override
    public byte[] getBytes() throws IOException {
        if (bytes == null) {
            throw new IOException("No data available");
        }
        return bytes;
    }

    @NotNull
    @Override
    public InputStream getInputStream() throws IOException {
        if (bytes == null) {
            throw new IOException("No data available");
        }
        // 每次返回新的 ByteArrayInputStream，支持多次读取
        return new ByteArrayInputStream(bytes);
    }

    @Override
    public void transferTo(@NotNull File dest) throws IOException, IllegalStateException {
        if (bytes == null) {
            throw new IllegalStateException("No data available to transfer");
        }
        FileUtil.writeBytes(bytes, dest);
    }
}