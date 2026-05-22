package tech.aiflowy.ai.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.math.BigInteger;
import java.util.Map;

public class WorkflowSingleRunDTO {

    /**
     * 工作流ID
     */
    @NotNull(message = "workflowId不能为空")
    private BigInteger workflowId;
    /**
     * 节点ID
     */
    @NotEmpty(message = "nodeId不能为空")
    private String nodeId;
    /**
     * 执行参数
     */
    private Map<String, Object> variables;

    public BigInteger getWorkflowId() {
        return workflowId;
    }

    public void setWorkflowId(BigInteger workflowId) {
        this.workflowId = workflowId;
    }

    public String getNodeId() {
        return nodeId;
    }

    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }

    public Map<String, Object> getVariables() {
        return variables;
    }

    public void setVariables(Map<String, Object> variables) {
        this.variables = variables;
    }
}
