pragma solidity ^0.4.24;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on overflow.
     * Counterpart to Solidity's `+` operator.
     */
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a, "Overflow.");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on overflow.
     * Counterpart to Solidity's `-` operator.
     */
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a, "Overflow.");
        c = a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
     * Counterpart to Solidity's `*` operator.
     */
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b, "Overflow.");
    }

    /**
     * @dev Returns the division of two unsigned integers, division by zero.
     * Counterpart to Solidity's `/` operator.
     */
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b != 0, "Division by zero.");
        c = a / b;
    }

    /**
     * @dev Returns the remainder of dividing of two unsigned integers.
     * Reverts with custom message when dividing by zero.
     * Counterpart to Solidity's `%` operator.
     */
    function mod(uint a, uint b) internal pure returns (uint c) {
        require(b != 0, "Division by zero.");
        c = a % b;
    }
}
