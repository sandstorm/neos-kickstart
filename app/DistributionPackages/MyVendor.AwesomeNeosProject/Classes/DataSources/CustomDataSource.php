<?php
namespace MyVendor\AwesomeNeosProject\DataSources;

use Neos\Flow\Annotations as Flow;
use Neos\Neos\Domain\Service\UserService;
use Neos\Neos\Service\DataSource\AbstractDataSource;
use Neos\ContentRepository\Domain\Model\NodeInterface;

class CustomDataSource extends AbstractDataSource
{
    /**
     * @var string
     */
    static protected $identifier = 'vendor-site-authors';

    /**
     * @Flow\Inject
     * @var UserService
     */
    protected $userService;

    /**
     * @param NodeInterface $node The node that is currently edited (optional)
     * @param array $arguments Additional arguments (key / value)
     * @return array
     */
    public function getData(NodeInterface $node = null, array $arguments = [])
    {
        $options = [];
        foreach ($this->userService->getUsers() as $user) {
            $options[$user->getLabel()] = $user;
        }
        return $options;
    }
}
