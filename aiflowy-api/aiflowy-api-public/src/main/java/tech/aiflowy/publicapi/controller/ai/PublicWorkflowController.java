package tech.aiflowy.publicapi.controller.ai;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.IdUtil;
import com.mybatisflex.core.query.QueryWrapper;
import dev.tinyflow.core.chain.ChainDefinition;
import dev.tinyflow.core.chain.Parameter;
import dev.tinyflow.core.chain.runtime.ChainExecutor;
import dev.tinyflow.core.parser.ChainParser;
import jakarta.annotation.Resource;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import tech.aiflowy.ai.dto.GetChainStatusDTO;
import tech.aiflowy.ai.dto.WorkflowResumeDTO;
import tech.aiflowy.ai.dto.WorkflowRunDTO;
import tech.aiflowy.ai.dto.WorkflowSingleRunDTO;
import tech.aiflowy.ai.entity.BotWorkflow;
import tech.aiflowy.ai.entity.Workflow;
import tech.aiflowy.ai.service.BotWorkflowService;
import tech.aiflowy.ai.service.ModelService;
import tech.aiflowy.ai.service.WorkflowService;
import tech.aiflowy.ai.tinyflow.entity.ChainInfo;
import tech.aiflowy.ai.tinyflow.entity.NodeInfo;
import tech.aiflowy.ai.tinyflow.service.TinyFlowService;
import tech.aiflowy.common.constant.Constants;
import tech.aiflowy.common.domain.Result;
import tech.aiflowy.common.entity.LoginAccount;
import tech.aiflowy.common.satoken.util.SaTokenUtil;
import tech.aiflowy.common.web.controller.BaseCurdController;
import tech.aiflowy.common.web.exceptions.BusinessException;
import tech.aiflowy.system.service.SysApiKeyService;
import tech.aiflowy.system.service.SysOptionService;

import java.io.InputStream;
import java.io.Serializable;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 工作流
 *
 * @author michael
 * @since 2024-08-23
 */
@RestController
@RequestMapping("/public-api/v1/workflow")
public class PublicWorkflowController extends BaseCurdController<WorkflowService, Workflow> {
    private final ModelService modelService;

    @Resource
    private SysApiKeyService apiKeyService;
    @Resource
    private BotWorkflowService botWorkflowService;
    @Resource
    private ChainExecutor chainExecutor;
    @Resource
    private ChainParser chainParser;
    @Resource
    private TinyFlowService tinyFlowService;
    @Resource
    private SysOptionService sysOptionService;

    public PublicWorkflowController(WorkflowService service, ModelService modelService) {
        super(service);
        this.modelService = modelService;
    }

    /**
     * 节点单独运行
     */
    @PostMapping("/singleRun")
    public Result<?> singleRun(@RequestBody WorkflowSingleRunDTO dto) {
        BigInteger workflowId = dto.getWorkflowId();
        Workflow workflow = service.getById(workflowId);
        if (workflow == null) {
            return Result.fail(1, "工作流不存在");
        }
        Map<String, Object> res = chainExecutor.executeNode(workflowId.toString(), dto.getNodeId(), dto.getVariables());
        return Result.ok(res);
    }

    /**
     * 运行工作流 - v2
     */
    @PostMapping("/runAsync")
    public Result<String> runAsync(@RequestBody WorkflowRunDTO dto) {
        Map<String, Object> variables = dto.getVariables();
        if (variables == null) {
            variables = new HashMap<>();
        }
        Workflow workflow = service.getById(dto.getId());
        if (workflow == null) {
            throw new RuntimeException("工作流不存在");
        }
        if (StpUtil.isLogin()) {
            variables.put(Constants.LOGIN_USER_KEY, SaTokenUtil.getLoginAccount());
        }
        Map<String, Object> envVariables = sysOptionService.getEnvVariables();
        String executeId = chainExecutor.executeAsync(dto.getId().toString(), variables, envVariables);
        return Result.ok(executeId);
    }

    /**
     * 获取工作流运行状态 - v2
     */
    @PostMapping("/getChainStatus")
    public Result<ChainInfo> getChainStatus(@RequestBody GetChainStatusDTO dto) {
        String executeId = dto.getExecuteId();
        List<NodeInfo> nodes = dto.getNodes();
        ChainInfo res = tinyFlowService.getChainStatus(executeId, nodes);
        return Result.ok(res);
    }

    /**
     * 恢复工作流运行 - v2
     */
    @PostMapping("/resume")
    public Result<Void> resume(@RequestBody WorkflowResumeDTO resumeDTO) {
        chainExecutor.resumeAsync(resumeDTO.getExecuteId(), resumeDTO.getConfirmParams());
        return Result.ok();
    }

    /**
     * 导入工作流
     */
    @PostMapping("/importWorkFlow")
    public Result<Void> importWorkFlow(Workflow workflow, MultipartFile jsonFile) throws Exception {
        InputStream is = jsonFile.getInputStream();
        String content = IoUtil.read(is, StandardCharsets.UTF_8);
        workflow.setContent(content);
        save(workflow);
        return Result.ok();
    }

    /**
     * 导出工作流
     */
    @GetMapping("/exportWorkFlow")
    public Result<String> exportWorkFlow(BigInteger id) {
        Workflow workflow = service.getById(id);
        return Result.ok("", workflow.getContent());
    }

    /**
     * 获取运行时参数
     */
    @GetMapping("getRunningParameters")
    public Result<?> getRunningParameters(@RequestParam BigInteger id) {
        Workflow workflow = service.getById(id);

        if (workflow == null) {
            return Result.fail(1, "can not find the workflow by id: " + id);
        }

        ChainDefinition definition = chainParser.parse(workflow.getContent());
        if (definition == null) {
            return Result.fail(2, "节点配置错误，请检查! ");
        }
        List<Parameter> chainParameters = definition.getStartParameters();
        Map<String, Object> res = new HashMap<>();
        res.put("parameters", chainParameters);
        res.put("title", workflow.getTitle());
        res.put("description", workflow.getDescription());
        res.put("icon", workflow.getIcon());
        return Result.ok(res);
    }

    @Override
    public Result<Workflow> detail(String id) {
        Workflow workflow = service.getDetail(id);
        return Result.ok(workflow);
    }

    /**
     * 复制工作流
     */
    @GetMapping("/copy")
    public Result<Void> copy(BigInteger id) {
        LoginAccount account = SaTokenUtil.getLoginAccount();
        Workflow workflow = service.getById(id);
        workflow.setId(null);
        workflow.setAlias(IdUtil.fastSimpleUUID());
        commonFiled(workflow, account.getId(), account.getTenantId(), account.getDeptId());
        service.save(workflow);
        return Result.ok();
    }

    @Override
    protected Result onSaveOrUpdateBefore(Workflow entity, boolean isSave) {

        String alias = entity.getAlias();
        if (StringUtils.hasLength(alias)) {
            Workflow workflow = service.getByAlias(alias);
            if (workflow == null) {
                return null;
            }
            if (isSave) {
                throw new BusinessException("别名已存在！");
            }
            BigInteger id = entity.getId();
            if (id.compareTo(workflow.getId()) != 0) {
                throw new BusinessException("别名已存在！");
            }
        } else {
            entity.setAlias(null);
        }
        return null;
    }

    @Override
    protected Result<?> onRemoveBefore(Collection<Serializable> ids) {
        QueryWrapper queryWrapper = QueryWrapper.create();
        queryWrapper.in(BotWorkflow::getWorkflowId, ids);
        botWorkflowService.remove(queryWrapper);
        return null;
    }
}