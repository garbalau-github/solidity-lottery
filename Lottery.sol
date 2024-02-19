// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public players;
    address payable public winner;

    // Set the manager
    constructor() {
        manager = msg.sender;
    }

    function participate() public payable {
        require(msg.value == 0.1 ether, "Please, we require at least 0.1 ETH.");
        players.push(payable(msg.sender));
    }

    function random() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }

    // Only manager can execute this function
    function getBalance() public view returns(uint) {
        require(msg.sender == manager, "You are not the manager.");
        return address(this).balance;
    }

    // Only manager can execute this function
    function pickWinner() public {
        require(msg.sender == manager, "You are not the manager.");
        require(players.length >= 3, "Not enough players.");

        uint r = random();
        uint index = r % players.length;
        winner = players[index];

        // Transfer amount to the winner
        winner.transfer(getBalance());
        players = new address payable[](0);
    }
}
