pragma solidity ^0.4.24;

import "./SafeMath.sol";

contract Hexcoin {
    using SafeMath for uint;
    uint public fieldWidth;
    uint public fieldHeight;
    uint public minPrice;
    uint public minStep;
    uint public lastActionTime;
    uint public maxDelay;
    uint public funds;
    uint public ownedBlocks;
    uint public round;
    
    struct User {
        uint ownedBlocks;
    }
    
    struct Hexagon {
        address owner;
        uint price;
    }
    
    struct Coordinate {
        uint x;
        uint y;
        uint z;
    }
    
    address[] public users;
    mapping(address => User) public userInfo;
    mapping (bytes32 => Hexagon) public field;

    function sendRewards() private {
        
    }
    
    // TODO: push dublicates
    function buyBlock(uint x, uint y, uint z) public payable {
        uint blockId = keccak256(abi.encodePacked(x, y, z));
        if (lastActionTime + maxDelay < block.number) {
            sendRewards();
        }
        // check last action time
        if (userInfo[msg.sender].ownedBlocks == 0) {
            require(field[blockId].price == msg.value);
            users.push(msg.sender);
        } else {
            uint price = field[blockId].price;
            // checks
            require(price == msg.value);
        }
        field[blockId].owner = msg.sender;
        field[blockId].price = msg.value;
        lastActionTime = block.number;
        userInfo[msg.sender].ownedBlocks += 1;
        funds += msg.value;
        ownedBlocks += 1;
    } 
}