pragma solidity ^0.4.24;

import "./SafeMath.sol";

contract Hexcoin {
    using SafeMath for uint;
    uint public fieldWidth = 10;
    uint public fieldHeight = 10;
    uint public minPrice = 6;
    uint public minStep = 6;
    uint public lastActionTime;
    uint public maxDelay = 1000;
    uint public round;
    
    struct User {
        uint ownedBlocks;
        bool active;
    }
    
    struct Hexagon {
        address owner;
        uint price;
    }
    
    address[] public users;
    mapping(address => User) public userInfo;
    mapping(uint => mapping (bytes32 => Hexagon)) public rounds;
    mapping(uint => uint) public funds;
    mapping(uint => uint) public ownedBlocks;
    event Bought(address user, int x, int y, int z);
    function updateRewards() private {
        round += 1;
    }
    
    function calculateId(int x, int y, int z) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(x, y, z));
    }
    
    function getReward(uint requiredRound) public {
        require(requiredRound < round);
        require(userInfo[msg.sender].active);
        userInfo[msg.sender].active = false;
        address(msg.sender).transfer(funds[requiredRound].mul(userInfo[msg.sender].ownedBlocks).div(ownedBlocks[requiredRound]));
    }
    
    // TODO: push dublicates
    function buyBlock(int x, int y, int z) public payable {
        bytes32 blockId = keccak256(abi.encodePacked(x, y, z));
        mapping(bytes32 => Hexagon) field = rounds[round];
    
        if (lastActionTime + maxDelay < block.number) {
            updateRewards();
        }
        uint price = field[blockId].price + minStep;
        if (userInfo[msg.sender].active == false) {
            users.push(msg.sender);
            userInfo[msg.sender].active = true;
        }
        uint userSale;
        userSale += (field[keccak256(abi.encodePacked(x, y + 1, z - 1))].owner == msg.sender) ? 1 : 0;
        userSale += (field[keccak256(abi.encodePacked(x, y - 1, z + 1))].owner == msg.sender) ? 1 : 0;
        userSale += (field[keccak256(abi.encodePacked(x - 1, y, z + 1))].owner == msg.sender) ? 1 : 0;
        userSale += (field[keccak256(abi.encodePacked(x + 1, y, z - 1))].owner == msg.sender) ? 1 : 0;
        userSale += (field[keccak256(abi.encodePacked(x - 1, y + 1, z))].owner == msg.sender) ? 1 : 0;
        userSale += (field[keccak256(abi.encodePacked(x + 1, y - 1, z))].owner == msg.sender) ? 1 : 0;
        require(price.sub(userSale) == msg.value);
        if (field[blockId].owner == address(0)) {
            ownedBlocks[round] += 1;
        } else {
            address(field[blockId].owner).transfer(field[blockId].price);
        }
        field[blockId].owner = msg.sender;
        funds[round] += msg.value - field[blockId].price;
        field[blockId].price = msg.value;
        lastActionTime = block.number;
        userInfo[msg.sender].ownedBlocks += 1;
        funds[round] += msg.value;
        emit Bought(msg.sender, x, y, z);
    } 
}