<?php

use Behat\Behat\Context\Context;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Neos\Behat\Tests\Behat\FlowContextTrait;
use Neos\ContentRepository\Tests\Behavior\Features\Bootstrap\NodeOperationsTrait;
use Neos\Flow\Configuration\ConfigurationManager;
use Neos\Flow\ObjectManagement\Exception\UnknownObjectException;
use Neos\Flow\ObjectManagement\ObjectManagerInterface;
use Neos\Flow\Tests\Behavior\Features\Bootstrap\SecurityOperationsTrait;
use Sandstorm\E2ETestTools\Tests\Behavior\Bootstrap\FusionRenderingTrait;
use Sandstorm\E2ETestTools\Tests\Behavior\Bootstrap\NeosBackendControlTrait;
use Sandstorm\E2ETestTools\Tests\Behavior\Bootstrap\PlaywrightTrait;

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
    use FrontendControlTrait;

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
        $this->setupFlowContextForSUT($this->objectManager);
        // TODO configure enable/disable tracing?
        //$this->setPlaywrightTracingMode(self::$PLAYWRIGHT_TRACING_MODE_ALWAYS);
    }

    /**
     * @BeforeScenario @fixtures
     * @throws Exception
     */
    public function clearCacheBeforeScenario(BeforeScenarioScope $event): void
    {
        $this->executeFlowCommand( "cache:flushone --identifier Neos_Fusion_Content", "flush Fusion cache");
        $this->executeFlowCommand( "cache:warmup", "warmup Fusion cache");
    }

    /**
     * @return ObjectManagerInterface
     */
    public function getObjectManager(): ObjectManagerInterface
    {
        return $this->objectManager;
    }

    /**
     * @param ObjectManagerInterface $objectManager
     * @throws \Neos\Flow\Configuration\Exception\InvalidConfigurationTypeException
     */
    private function setupFlowContextForSUT(ObjectManagerInterface $objectManager): void {
        $configurationManager = $objectManager->get(ConfigurationManager::class);
        $flowContext = $configurationManager->getConfiguration(
            ConfigurationManager::CONFIGURATION_TYPE_SETTINGS,
            'MyVendor.AwesomeNeosProject.E2ETest.e2eFlowContext'
        );
        if (!is_string($flowContext)) {
            throw new \Exception("Could not get MyVendor.AwesomeNeosProject.E2ETest.e2eFlowContext configuration");
        }
        $this->flowContextForSystemUnderTest = $flowContext;
    }

    private function executeFlowCommand(string $command, string $errorDescription): bool {
        $output = [];
        $resultCode = -100;
        exec("FLOW_CONTEXT=$this->flowContextForSystemUnderTest ./flow $command", $output, $resultCode);
        if ($resultCode !== 0) {
            echo "ERROR: could not $errorDescription";
            echo print_r($output, true);
            return false;
        }
        return true;
    }
}
