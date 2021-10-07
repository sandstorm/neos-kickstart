<?php
namespace MyVendor\AwesomeNeosProject;

use MyVendor\AwesomeNeosProject\Domain\Service\AssetTitleManager;
use Neos\Flow\Core\Bootstrap;
use Neos\Flow\Package\Package as BasePackage;
use Neos\Media\Domain\Service\AssetService;

class Package extends BasePackage
{
    /**
     * @param Bootstrap $bootstrap The current bootstrap
     * @return void
     */
    public function boot(Bootstrap $bootstrap)
    {
        $dispatcher = $bootstrap->getSignalSlotDispatcher();
        $dispatcher->connect(AssetService::class, 'assetCreated', AssetTitleManager::class, 'addTitleToImportedAsset');
    }
}
