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
    public function customTruncate($text, $size) {

        switch($size) {
            case 'length-20':
                $stringLength = 20;
                break;
            case 'length-40':
                $stringLength = 40;
                break;
            case 'length-60':
                $stringLength = 60;
                break;
            case 'length-80':
                $stringLength = 80;
                break;
            default:
                $stringLength = 40;
        }

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

