package tech.aiflowy.common.constant;

import java.util.Map;

/**
 * 大模型 JSON Schema 定义
 */
public interface ModelJsonSchema {

    Map<String,Object> JSON_RESPONSE_FORMAT = Map.of("type", "json_object");

    String WORKFLOW_PARAMS = """
            {
                 "type": "array",
                 "items": {
                     "type": "object",
                     "properties": {
                         "type": "string",
                         "description": "类型",
                         "enum": [
                             "input",
                             "select",
                             "textarea",
                             "radio",
                             "checkbox",
                             "file"
                         ],
                         "label": {
                             "type": "string",
                             "description": "表单标签"
                         },
                         "options": {
                             "type": "array",
                             "description": "选项",
                             "items": {
                                 "type": "string",
                                 "description": "选项"
                             }
                         }
                     },
                     "required": [
                         "attrName",
                         "type",
                         "label"
                     ]
                 }
             }
            """;

}
