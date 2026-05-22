package tech.aiflowy.system.service;

import tech.aiflowy.system.entity.SysOption;
import com.mybatisflex.core.service.IService;

import java.util.Map;

/**
 * 系统配置信息表。 服务层。
 *
 * @author michael
 * @since 2024-03-13
 */
public interface SysOptionService extends IService<SysOption> {

    SysOption getByOptionKey(String key);

    Map<String, Object> getEnvVariables();
}
