<?php
declare(strict_types=1);

namespace MyVendor\AwesomeNeosProject\Eel\Helpers;

use MyVendor\AwesomeNeosProject\DataSources\CustomDataSource;
use Neos\Flow\Annotations as Flow;
use Neos\Eel\ProtectedContextAwareInterface;

class GetUserHelper implements ProtectedContextAwareInterface {

    /**
     * Wrap the incoming string in curly brackets
     *
     *
     * @param $id string
     * @return string
     */
    public function getUser($id) {

        return '{' . 'guten Tach' . '}';
    }

    /**
     * All methods are considered safe, i.e. can be executed from within Eel
     *
     * @param string $methodName
     * @return boolean
     */
    public function allowsCallOfMethod($methodName) {
        return true;
    }
}


