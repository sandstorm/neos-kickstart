<?php
declare(strict_types = 1);

namespace MyVendor\AwesomeNeosProject\Eel\Helper;

use Neos\Flow\Annotations as Flow;
use Neos\Eel\ProtectedContextAwareInterface;

class TruncateHelper implements ProtectedContextAwareInterface {
    /**
     * Truncate the given string to max 100 characters
     *
     * @param $text string
     * @return string
     *
     */

    public function truncateOneHundred($text) {
        return substr($text, 0, 100);
    }

    /**
     * All methods are considered safe, i.e. can be executed  from within Eel
     *
     * @param string $methodName
     * @return boolean
     */
    public function allowsCallOfMethod($methodName) {
        return true;
    }
}

