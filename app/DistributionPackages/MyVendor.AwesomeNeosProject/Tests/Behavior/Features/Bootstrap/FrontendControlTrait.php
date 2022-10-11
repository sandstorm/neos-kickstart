<?php


use function PHPUnit\Framework\assertEquals;
use function PHPUnit\Framework\assertTrue;
use Behat\Gherkin\Node\TableNode;
use Neos\Neos\Fusion\Cache\ContentCacheFlusher;
use Neos\Utility\ObjectAccess;

trait FrontendControlTrait
{
    /**
     * @When I reload the current page
     */
    public function iReloadTheCurrentPage()
    {
        $this->playwrightConnector->execute($this->playwrightContext,
            // language=JavaScript
            '
            // sleep time expects milliseconds
            await vars.page.reload();
        '// language=PHP
        );
    }

    /**
     * @Given I accepted the Cookie Consent
     */
    public function iAcceptedTheCookieConsent()
    {
        $this->playwrightConnector->execute($this->playwrightContext,
            // language=JavaScript
            '
            await context.addCookies([{
                name: "cookie_punch",
                value: "%7B%22default%22%3Atrue%2C%22media%22%3Atrue%7D",
                url: "BASEURL"
            }]);
        '// language=PHP
        );
    }

    /**
     * @When the content cache flush is executed
     */
    public function theContentCacheFlushIsExecuted(): void
    {
        $contentCacheFlusher = $this->getObjectManager()->get(ContentCacheFlusher::class);
        $contentCacheFlusher->shutdownObject();
        ObjectAccess::setProperty($contentCacheFlusher, 'tagsToFlush', [], true);
    }

    /**
     * @Then the page title should be :title
     */
    public function thePageTitleShouldBe($title)
    {
        $actualTitle = $this->playwrightConnector->execute($this->playwrightContext,
            // language=JavaScript
            '
                return await vars.page.textContent(`head title`);
        ');// language=PHP
        assertEquals($title, $actualTitle, 'page title mismatch');
    }

    /**
     * @Then the current element in the breadcrumb should be :elementName
     */
    public function theCurrentElementInTheBreadcrumbShouldBe($elementName)
    {
        $actualCurrentElement = $this->playwrightConnector->execute($this->playwrightContext,
            // language=JavaScript
            '
                return await vars.page.textContent(`body .breadcrumb .current`);
        ');// language=PHP

        assertEquals($elementName, $actualCurrentElement, 'current element mismatch');

    }

    /**
     * @Then the breadcrumb should contain the following elements:
     */
    public function theBreadcrumbShouldContainTheFollowingElements(TableNode $elements)
    {
        $actualElements = $this->playwrightConnector->execute($this->playwrightContext,
            // language=JavaScript
            '
                const elements = await vars.page.$$(`body .breadcrumb li`);
                return await Promise.all(elements.map(item => item.textContent()));
        ');// language=PHP

        assertEquals($elements->getColumn(0), $actualElements, 'breadcrumb elements mismatch');
    }

    /**
     * @Then there must be a blog post overview
     */
    public function thereMustBeABlogPostOverview()
    {
        $this->playwrightConnector->execute($this->playwrightContext,
            // language=JavaScript
            '
            await vars.page.locator(`.blog-post-overview`).waitFor();
        '// language=PHP
        );
    }

    /**
     * @Then there must be :blogPostCount blog-posts inside the blog overview
     */
    public function thereMustBeXBlogPostsInsideTheBlogOverview(int $blogPostCount)
    {
        $actualBlogPostCount = $this->playwrightConnector->execute($this->playwrightContext,
            // language=JavaScript
            '
            return await vars.page.locator(`.blog-post-overview .blog-post-overview__post`).count();
        '// language=PHP
        );
        assertEquals($blogPostCount, $actualBlogPostCount, "expected $blogPostCount blog posts inside the overview, but found $actualBlogPostCount");
    }

    /**
     * @Then there must be :tagCount tags inside the blog overview
     */
    public function thereMustBeXTagsInsideTheBlogOverview(int $tagCount)
    {
        $actualTagCount = $this->playwrightConnector->execute($this->playwrightContext,
            // language=JavaScript
            '
            return await vars.page.locator(`.blog-tag-list .blog-tag`).count();
        '// language=PHP
        );
        assertEquals($tagCount, $actualTagCount, "expected $tagCount tags inside the overview, but found $actualTagCount");
    }

    /**
     * @Then I must see a blog post with the headline :expectedHeadline inside the blog overview
     */
    public function iMustSeeABlogPostWithTheHeadlineXInsideTheBlogOverview(string $expectedHeadline): void
    {
        $isVisible = $this->playwrightConnector->execute($this->playwrightContext, sprintf(
        // language=JavaScript
            '
            return await vars.page.isVisible(`.blog-post-overview .blog-post-preview__title:text-matches("^%s$", "i")`)
        '// language=PHP
            , $expectedHeadline));
        assertTrue($isVisible, "expected blog post with headline '$expectedHeadline' inside the overview not found");
    }

    /**
     * @Then the size of column :column should be :size
     */
    public function theSizeOfColumnXShouldBeY(int $column, string $size)
    {
        $classList = $this->getClassListForColumn($column);
        $expectedSizeClassName = "columns__cell--size-$size";
        assertEquals(true, in_array($expectedSizeClassName, $classList), "expected column '$column' to have size '$size'. But class list is: ". implode(",", $classList));
    }

    private function getClassListForColumn(int $column): array
    {
        return $this->playwrightConnector->execute($this->playwrightContext,  sprintf(
        // language=JavaScript
            '
                return await vars.page.$eval(".columns .columns__cell:nth-of-type(%s)", el => el.classList);
        ', $column));// language=PHP
    }
}
