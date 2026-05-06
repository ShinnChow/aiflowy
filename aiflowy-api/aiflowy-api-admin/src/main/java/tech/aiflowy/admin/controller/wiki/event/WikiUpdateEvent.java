package tech.aiflowy.admin.controller.wiki.event;

import java.math.BigInteger;

public class WikiUpdateEvent {

    private BigInteger wikiId;
    private String content;

    public BigInteger getWikiId() {
        return wikiId;
    }

    public void setWikiId(BigInteger wikiId) {
        this.wikiId = wikiId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
