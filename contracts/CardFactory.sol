pragma solidity ^0.4.23;

import "./Ownable.sol";
import "./SafeMath.sol";

contract CardFactory is Ownable {

    using SafeMath for uint;

    event NewCard();

    struct Card {
        string metadataURI;
    }

    Card[] public cards;
    mapping (address => uint256) public ownerCardCount;
    mapping (uint256 => address) public cardToOwner;

    function _createCard(string _metadataURI) internal {
        uint id = cards.push(Card(_metadataURI)) - 1;
        cardToOwner[id] = msg.sender;
        ownerCardCount[msg.sender] = ownerCardCount[msg.sender].add(1);
        emit NewCard();
    }

    function setMetadataURI(uint _tokenId, string _metadataURI) external onlyOwner {
        require(_tokenId > 0);
        require(_tokenId <= cards.length);
        cards[_tokenId].metadataURI = _metadataURI;
    }

    function createCard(string _metadataURI) public {
        _createCard(_metadataURI);
    }

}


