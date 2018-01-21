pragma solidity ^0.4.17;

contract Lottery {
  address public manager;
  address[] public players;
  address public lastWinner;

  function Lottery() public {
    manager = msg.sender;
  }

  function enter() public payable {
    require(msg.value >= 2 ether);
    players.push(msg.sender);
  }

  function random() private view returns (uint) {
    return uint(keccak256(block.difficulty, now, players));
  }

  function pickWinner() public isManager {
    uint index = random() % players.length;
    players[index].transfer(this.balance);
    lastWinner = players[index];
    players = new address[](0);
  }

  function getPlayers() public view returns (address[]) {
    return players;
  }

  modifier isManager() {
    require(msg.sender == manager);
    _;
  }
}
