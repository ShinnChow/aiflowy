package tech.aiflowy.publicapi.controller.wiki;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import tech.aiflowy.common.web.controller.BaseCurdController;
import tech.aiflowy.wiki.entity.WikiCategory;
import tech.aiflowy.wiki.service.WikiCategoryService;

/**
 * Wiki知识树-分类
 */
@RequestMapping("/public-api/v1/wikiCategory")
@RestController
public class PublicWikiCategoryController extends BaseCurdController<WikiCategoryService, WikiCategory> {

    public PublicWikiCategoryController(WikiCategoryService service) {
        super(service);
    }

}
