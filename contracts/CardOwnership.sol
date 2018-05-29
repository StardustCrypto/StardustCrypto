pragma solidity ^0.4.23;

import "./ERC721.sol";
import "./Card.sol";
import "./SafeMath.sol";

contract CardOwnership is CardFactory, ERC721 {

    using SafeMath for uint256;

    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address from, address to, uint256 tokenId);

    mapping (uint256 => address) public cardTransferApprovals;

    modifier onlyOwnerOf(uint _tokenId) {
        require(msg.sender == cardToOwner[_tokenId]);
        _;
    }

    function totalSupply() public view returns (uint256 total) {
        return cards.length;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return tokenBalance[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address owner) {
        return cardToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private onlyOwnerOf(_tokenId) {
        tokenBalance[_to] = tokenBalance[_to].add(1);
        tokenBalance[msg.sender] = tokenBalance[msg.sender].sub(1);
        cardToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) external onlyOwnerOf(_tokenId) {
        cardTransferApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) external onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external {
        require(cardTransferApprovals[_tokenId] == msg.sender);
        _transfer(_from, msg.sender, _tokenId);
    }

}