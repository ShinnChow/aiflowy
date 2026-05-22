package tech.aiflowy.ai.dto;

import jakarta.validation.constraints.NotEmpty;
import tech.aiflowy.ai.tinyflow.entity.NodeInfo;

import java.util.List;

public class GetChainStatusDTO {

    /**
     * 执行ID
     */
    @NotEmpty(message = "执行ID不能为空")
    private String executeId;
    /**
     * 节点信息
     */
    private List<NodeInfo> nodes;

    public String getExecuteId() {
        return executeId;
    }

    public void setExecuteId(String executeId) {
        this.executeId = executeId;
    }

    public List<NodeInfo> getNodes() {
        return nodes;
    }

    public void setNodes(List<NodeInfo> nodes) {
        this.nodes = nodes;
    }
}
