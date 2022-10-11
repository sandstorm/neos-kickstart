<?php

namespace MyVendor\AwesomeNeosProject\Command;

use Neos\ContentRepository\Domain\Model\NodeInterface;
use Neos\ContentRepository\Domain\NodeType\NodeTypeConstraints;
use Neos\ContentRepository\Domain\Service\ContextFactoryInterface;
use Neos\Flow\Annotations as Flow;
use Neos\Flow\Cli\CommandController;
use Sandstorm\E2ETestTools\StepGenerator\NodeTable;
use Sandstorm\E2ETestTools\StepGenerator\NodeTableBuilderService;

class StepGeneratorCommandController extends CommandController
{
    /**
     * @Flow\Inject
     * @var ContextFactoryInterface
     */
    protected $contextFactory;

    /**
     * @Flow\Inject
     */
    protected NodeTableBuilderService $nodeTableBuilderService;

    public function homepageCommand()
    {
        $nodeTable = $this->defaultNodeTable('Frontend/Resources/Homepage');
        $siteNode = $this->getSiteNode();

        $nodeTable->addParents($siteNode);
        $nodeTable->addNode($siteNode);
        $nodeTable->addNodesUnderneathExcludingAutoGeneratedChildNodes($siteNode, '!Neos.Neos:Document'); // we recurse into the content of the homepage
        $nodeTable->addNodesUnderneathExcludingAutoGeneratedChildNodes($siteNode, 'Neos.Neos:Document,!MyVendor.AwesomeNeosProject:Document.Blog'); // we render the remaining document nodes so we can have a menu rendered (but without content)

        $nodeTable->print();
    }

    public function notFoundPageCommand()
    {
        $nodeTable = $this->defaultNodeTable('Frontend/Resources/NotFound');
        $siteNode = $this->getSiteNode();

        $nodeTable->addParents($siteNode);
        $nodeTable->addNode($siteNode);
        $filter = new NodeTypeConstraints(false, ['MyVendor.AwesomeNeosProject:Document.NotFoundPage']);
        $notFoundPageNodes = $siteNode->findChildNodes($filter);
        foreach ($notFoundPageNodes as $notFoundPageNode) {
            $nodeTable->addNode($notFoundPageNode);
            $nodeTable->addNodesUnderneathExcludingAutoGeneratedChildNodes($notFoundPageNode, '!Neos.Neos:Document'); // 404 page content
        }

        $nodeTable->print();
    }

    public function blogPageCommand()
    {
        $nodeTable = $this->defaultNodeTable('Frontend/Resources/Blog');
        $siteNode = $this->getSiteNode();

        $nodeTable->addParents($siteNode);
        $nodeTable->addNode($siteNode);
        $filter = new NodeTypeConstraints(false, ['MyVendor.AwesomeNeosProject:Document.Blog']);
        $blogPageNodes = $siteNode->findChildNodes($filter);
        foreach ($blogPageNodes as $blogPageNode) {
            $nodeTable->addNode($blogPageNode);
            $nodeTable->addNodesUnderneathExcludingAutoGeneratedChildNodes($blogPageNode, '!Neos.Neos:Document');
            $nodeTable->addNodesUnderneathExcludingAutoGeneratedChildNodes($blogPageNode, 'Neos.Neos:Document');
        }

        $nodeTable->print();
    }

    private function defaultNodeTable(string $resourceFixturesTestPath): NodeTable
    {
        return $this->nodeTableBuilderService->nodeTable()
            ->withDefaultNodeProperties(['Language' => 'de'])
            ->withFixturesBaseDirectory('MyVendor.AwesomeNeosProject', 'Tests/Behavior/Features/' . $resourceFixturesTestPath)
            ->build();
    }

    /**
     * @return NodeInterface
     */
    public function getSiteNode(): NodeInterface
    {
        $context = $this->contextFactory->create([
            'workspaceName' => 'live',
            'invisibleContentShown' => true,
            'dimensions' => [
            ],
            'targetDimensions' => [
            ]
        ]);
        return $context->getCurrentSiteNode();
    }
}
