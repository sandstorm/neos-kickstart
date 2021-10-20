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
     * @param $size string
     * @return string
     *
     */
    public function customTruncate($text, $size)
    {
        $stringLength = match ($size) {
            'length-20' => 20,
            'length-40' => 40,
            'length-60' => 60,
            'length-80' => 80,
            default => 80,
        };
        if(!$text) {
            return 'Bitte geben Sie einen Text ein';
        } else {
            return substr($text, 0, $stringLength);
        }
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

