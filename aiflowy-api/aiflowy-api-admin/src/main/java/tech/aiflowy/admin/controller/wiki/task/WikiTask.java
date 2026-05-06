package tech.aiflowy.admin.controller.wiki.task;

import com.mybatisflex.core.query.QueryWrapper;
import com.mybatisflex.core.tenant.TenantManager;
import jakarta.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import tech.aiflowy.admin.controller.wiki.event.WikiUpdateEvent;
import tech.aiflowy.ai.agentsflex.ocrModel.OcrModel;
import tech.aiflowy.ai.agentsflex.ocrModel.ParseResult;
import tech.aiflowy.ai.entity.Model;
import tech.aiflowy.ai.service.ModelService;
import tech.aiflowy.common.constant.enums.EnumOcrTaskStatus;
import tech.aiflowy.common.constant.enums.EnumRecognitionMode;
import tech.aiflowy.wiki.entity.Wiki;
import tech.aiflowy.wiki.service.WikiService;

import java.math.BigInteger;
import java.util.List;

@Component
public class WikiTask {

    private static final Logger log = LoggerFactory.getLogger(WikiTask.class);
    @Resource
    private WikiService wikiService;
    @Resource
    private ModelService modelService;
    @Value("${job.wiki.enabled:true}")
    private boolean enabled;
    @Resource
    private ApplicationEventPublisher publisher;

    @Scheduled(fixedDelay = 10000)
    public void queryTaskStatus() {
        if (!enabled) return;
        try {
            log.info("开始查询 OCR 任务状态");
            TenantManager.ignoreTenantCondition();
            QueryWrapper w = QueryWrapper.create();
            w.eq(Wiki::getRecognitionMode,EnumRecognitionMode.OCR.getCode());
            w.eq(Wiki::getTaskStatus, EnumOcrTaskStatus.IN_PROGRESS.getCode());
            List<Wiki> wikis = wikiService.list(w);
            wikis.forEach(this::handleQuery);
        } finally {
            log.info("查询 OCR 任务状态完成");
            TenantManager.restoreTenantCondition();
        }
    }

    private void handleQuery(Wiki wiki) {
        String taskId = wiki.getTaskId();
        BigInteger ocrModelId = wiki.getOcrModelId();
        Model model = modelService.getModelInstance(ocrModelId);
        OcrModel ocrModel = model.toOcrModel();
        ParseResult res = ocrModel.queryTask(taskId);
        if (EnumOcrTaskStatus.COMPLETED.getCode().equals(res.getStatus())) {
            wiki.setTaskStatus(EnumOcrTaskStatus.COMPLETED.getCode());
            wiki.setContent(res.getContent());
            wikiService.updateById(wiki);
            WikiUpdateEvent event = new WikiUpdateEvent();
            event.setWikiId(wiki.getId());
            event.setContent(res.getContent());
            publisher.publishEvent(event);
        }
        if (EnumOcrTaskStatus.FAILED.getCode().equals(res.getStatus())) {
            wiki.setTaskStatus(EnumOcrTaskStatus.FAILED.getCode());
            wiki.setFailReason(res.getErrorMsg());
            wikiService.updateById(wiki);
        }
    }
}
