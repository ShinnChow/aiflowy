package tech.aiflowy.ai.dto;

import jakarta.validation.constraints.NotBlank;

import java.util.Map;

public class WorkflowResumeDTO {

    /**
     * 执行ID
     */
    @NotBlank(message = "执行ID不能为空")
    private String executeId;
    /**
     * 确认参数
     */
    private Map<String, Object> confirmParams;

    public String getExecuteId() {
        return executeId;
    }

    public void setExecuteId(String executeId) {
        this.executeId = executeId;
    }

    public Map<String, Object> getConfirmParams() {
        return confirmParams;
    }

    public void setConfirmParams(Map<String, Object> confirmParams) {
        this.confirmParams = confirmParams;
    }
}
