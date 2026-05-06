package tech.aiflowy.admin.controller.wiki;

import java.math.BigInteger;

public class WikiOptimizeDto {

    /**
     * 字段 title|description
     */
    private String field;
    /**
     * @see tech.aiflowy.common.constant.enums.EnumWikiType
     */
    private Integer type;
    private BigInteger wikiId;
    private String originValue;

    public String getField() {
        return field;
    }

    public void setField(String field) {
        this.field = field;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public BigInteger getWikiId() {
        return wikiId;
    }

    public void setWikiId(BigInteger wikiId) {
        this.wikiId = wikiId;
    }

    public String getOriginValue() {
        return originValue;
    }

    public void setOriginValue(String originValue) {
        this.originValue = originValue;
    }
}
