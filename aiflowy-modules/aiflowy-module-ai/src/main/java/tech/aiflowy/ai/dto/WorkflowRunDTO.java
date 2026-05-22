package tech.aiflowy.ai.dto;

import jakarta.validation.constraints.NotEmpty;

import java.math.BigInteger;
import java.util.Map;

public class WorkflowRunDTO {

    /**
     * 工作流ID
     */
    @NotEmpty(message = "工作流ID不能为空")
    private BigInteger id;
    /**
     * 执行参数
     */
    private Map<String, Object> variables;

    public BigInteger getId() {
        return id;
    }

    public void setId(BigInteger id) {
        this.id = id;
    }

    public Map<String, Object> getVariables() {
        return variables;
    }

    public void setVariables(Map<String, Object> variables) {
        this.variables = variables;
    }
}
