pragma solidity ^0.4.24;

import "./SafeMath.sol";

contract Hexcoin {
    using SafeMath for uint;
    uint public fieldWidth = 100;
    uint public fieldHeight = 100;
    uint public minPrice = 10;
    uint public minStep = 110; // in %
    uint public salePrice = 90; // in %
    uint public lastActionTime;
    uint public maxDelay;
    uint public ownedBlocks;
    uint public round;
    
    struct User {
        uint ownedBlocks;
    }
    
    struct Hexagon {
        address owner;
        uint price;
    }
    
    address[] public users;
    mapping(address => User) public userInfo;
    mapping(uint => mapping (bytes32 => Hexagon)) public rounds;
    mapping(uint => uint) public funds;

    function updateRewards() private {
        round += 1;
    }
    
    // TODO: push dublicates
    function buyBlock(uint x, uint y, uint z) public payable {
        bytes32 blockId = keccak256(abi.encodePacked(x, y, z));
        mapping(bytes32 => Hexagon) field = rounds[round];
    
        if (lastActionTime + maxDelay < block.number) {
            updateRewards();
        }
        uint price = (field[blockId].price > 0) ? field[blockId].price.mul(minStep).div(100) : minPrice; 
        if (userInfo[msg.sender].ownedBlocks == 0) {
            require(price == msg.value);
            users.push(msg.sender);
        } else {
            uint userSale = (field[keccak256(abi.encodePacked(x, y + 1, z - 1))].owner == msg.sender ||
                field[keccak256(abi.encodePacked(x, y + 1, z - 1))].owner == msg.sender ||
                field[keccak256(abi.encodePacked(x - 1, y, z + 1))].owner == msg.sender ||
                field[keccak256(abi.encodePacked(x + 1, y, z - 1))].owner == msg.sender ||
                field[keccak256(abi.encodePacked(x - 1, y + 1, z))].owner == msg.sender ||
                field[keccak256(abi.encodePacked(x + 1, y - 1, z))].owner == msg.sender) ? salePrice : 100;
            require(price.mul(userSale).div(100) == msg.value);
        }
        field[blockId].owner = msg.sender;
        field[blockId].price = msg.value;
        lastActionTime = block.number;
        userInfo[msg.sender].ownedBlocks += 1;
        funds[round] += msg.value;
        ownedBlocks += 1;
    } 
}