package tech.aiflowy.publicapi.interceptor;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import tech.aiflowy.common.constant.Constants;
import tech.aiflowy.common.domain.Result;
import tech.aiflowy.common.util.ResponseUtil;
import tech.aiflowy.common.vo.PublicApiEntity;
import tech.aiflowy.system.entity.SysApiKey;
import tech.aiflowy.system.service.SysApiKeyService;

@Component
public class PublicApiInterceptor implements HandlerInterceptor {

    private static final Logger log = LoggerFactory.getLogger(PublicApiInterceptor.class);

    @Resource
    private SysApiKeyService sysApiKeyService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        String requestURI = request.getRequestURI();
        String apiKey = request.getHeader(Constants.API_KEY_HEADER);

        if (apiKey == null || apiKey.isEmpty()) {
            Result<Void> failed = Result.fail(401, "密钥不正确");
            ResponseUtil.renderJson(response, failed);
            return false;
        }
        apiKey = apiKey.replace(Constants.HEADER_PREFIX, "");

        SysApiKey sysApiKey = sysApiKeyService.getSysApiKey(apiKey);
        sysApiKeyService.checkApikeyPermission(sysApiKey, requestURI);
        PublicApiEntity apiEntity = new PublicApiEntity();
        apiEntity.setCreatedBy(sysApiKey.getCreatedBy());
        apiEntity.setApiKey(sysApiKey.getApiKey());
        apiEntity.setDeptId(sysApiKey.getDeptId());
        apiEntity.setTenantId(sysApiKey.getTenantId());
        request.getSession().setAttribute(Constants.CURRENT_KEY, apiEntity);

        return true;
    }
}
