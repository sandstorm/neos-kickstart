<?php


use Sandstorm\E2ETestTools\Tests\Behavior\Bootstrap\PlaywrightTrait;
use function PHPUnit\Framework\assertEquals;
use function PHPUnit\Framework\assertFalse;
use Behat\Gherkin\Node\TableNode;

trait FrontendControlTrait
{

    use PlaywrightTrait;

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
     * @Then there should be a main headline :title
     */
    public function thereShouldBeAMainHeadline($title)
    {
        $actualTitle = $this->playwrightConnector->execute($this->playwrightContext,
            // language=JavaScript
            '
                return await vars.page.textContent(`body .container h1`);
        ');// language=PHP
        assertEquals($title, $actualTitle, 'page main headline mismatch');
    }

    /**
     * @Then there should be no main headline :title
     */
    public function thereShouldBeNoMainHeadline($title)
    {
        $visible = $this->playwrightConnector->execute($this->playwrightContext, sprintf(
        // language=JavaScript
            '
            return await vars.page.isVisible(`body .container h1:has-text("%s")`)
        '// language=PHP
            , $title));
        assertFalse($visible, 'headline is visible');
    }

    /**
     * @Then I should see a externe Verlinkung to Produktionsfirma :link
     */
    public function iShouldSeeAExterneVerlinkungToProduktionsfirma($expectedLink)
    {
        $htmlContent = $this->playwrightConnector->execute($this->playwrightContext, sprintf(
        // language=JavaScript
            '
                return await vars.page.innerHTML(`body .projekt-page__links`);
        '));// language=PHP

        assertEquals(true, str_contains($htmlContent, $expectedLink), 'Link is not found');
    }

    /**
     * @Then I should see a property :propertyName with value :propertyValue
     */
    public function iShouldSeeAPropertyWithValue($propertyName, $propertyValue)
    {
        $htmlContent = $this->playwrightConnector->execute($this->playwrightContext, sprintf(
        // language=JavaScript
            '
                return await vars.page.innerHTML(`body .projekt-page__key-facts-lists`);
        '));// language=PHP

        assertEquals(true, str_contains($htmlContent, $propertyName), 'property is not found');
        assertEquals(true, str_contains($htmlContent, $propertyValue), 'value is not found');
    }

    /**
     * @Then I should not see a property :propertyName
     */
    public function iShouldNotSeeAProperty($propertyName)
    {
        $htmlContent = $this->playwrightConnector->execute($this->playwrightContext, sprintf(
        // language=JavaScript
            '
                return await vars.page.innerHTML(`body .projekt-page__key-facts-lists`);
        '));// language=PHP

        assertEquals(true, str_contains($htmlContent, "<!-- invisible field: visible_" . $propertyName . " -->"), 'property is visible');
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
}
