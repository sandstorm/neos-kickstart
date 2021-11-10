<?php

use Behat\Behat\Context\Context;
use Neos\Behat\Tests\Behat\FlowContextTrait;
use Neos\ContentRepository\Tests\Behavior\Features\Bootstrap\NodeOperationsTrait;
use Neos\Flow\ObjectManagement\Exception\UnknownObjectException;
use Neos\Flow\ObjectManagement\ObjectManagerInterface;
use Neos\Flow\Tests\Behavior\Features\Bootstrap\SecurityOperationsTrait;
use Sandstorm\E2ETestTools\Tests\Behavior\Bootstrap\FusionRenderingTrait;
use Sandstorm\E2ETestTools\Tests\Behavior\Bootstrap\NeosBackendControlTrait;
use Sandstorm\E2ETestTools\Tests\Behavior\Bootstrap\PlaywrightTrait;
use function PHPUnit\Framework\assertEquals;

require_once(__DIR__ . '/../../../../../../Packages/Application/Neos.Behat/Tests/Behat/FlowContextTrait.php');
require_once(__DIR__ . '/../../../../../../Packages/Application/Neos.ContentRepository/Tests/Behavior/Features/Bootstrap/NodeOperationsTrait.php');
require_once(__DIR__ . '/../../../../../../Packages/Framework/Neos.Flow/Tests/Behavior/Features/Bootstrap/SecurityOperationsTrait.php');
require_once(__DIR__ . '/../../../../../../Packages/Application/Sandstorm.E2ETestTools/Tests/Behavior/Bootstrap/FusionRenderingTrait.php');
require_once(__DIR__ . '/../../../../../../Packages/Application/Sandstorm.E2ETestTools/Tests/Behavior/Bootstrap/PlaywrightTrait.php');
require_once(__DIR__ . '/../../../../../../Packages/Application/Sandstorm.E2ETestTools/Tests/Behavior/Bootstrap/NeosBackendControlTrait.php');
require_once(__DIR__ . '/FrontendControlTrait.php');

/**
 * Features context
 */
class FeatureContext implements Context
{
    use FlowContextTrait;
    use SecurityOperationsTrait;
    use FusionRenderingTrait;
    use NeosBackendControlTrait;

    use NodeOperationsTrait {
        FusionRenderingTrait::iHaveTheFollowingNodes insteadof NodeOperationsTrait;
    }
    use PlaywrightTrait;

    protected $isolated = false;

    /**
     * @var ObjectManagerInterface
     */
    protected $objectManager;

    /**
     * @throws \Neos\Flow\Exception
     * @throws UnknownObjectException
     */
    public function __construct()
    {
        if (self::$bootstrap === null) {
            self::$bootstrap = $this->initializeFlow();
        }
        $this->objectManager = self::$bootstrap->getObjectManager();
        $this->setupSecurity();
        $this->setupPlaywright();
        $this->setupFusionRendering('MyVendor.AwesomeNeosProject');
        // TODO configure enable/disable tracing?
        //$this->setPlaywrightTracingMode(self::$PLAYWRIGHT_TRACING_MODE_ALWAYS);
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
     * @return ObjectManagerInterface
     */
    public function getObjectManager(): ObjectManagerInterface
    {
        return $this->objectManager;
    }

    /**
     * @Then the async response with url part :urlPart should have status code :status
     */
    public function theAsyncResponseWithUrlPartShouldHaveStatusCode($urlPart, $status)
    {
        $actualStatusCode = $this->playwrightConnector->execute($this->playwrightContext, sprintf(
        // language=JavaScript
            '
                const response = await vars.page.waitForResponse(response => response.url().includes(`%s`));
                return response.status()
        ', $urlPart));// language=PHP

        assertEquals($status, $actualStatusCode, 'HTTP response status code mismatch');
    }
}
