// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import './ERC165.sol';
import './interface/IERC721.sol';

contract ERC721 is ERC165, IERC721 {

      // トークンIDと所有者の紐付けマップ
      mapping(uint256 => address) private _tokenOwner;
      // 所有者と保有しているNFTの数を保有するマップ
      mapping(address => uint256) private _OwnedTokensCount;
      // 承認されたトークンIDとアドレスを紐づけるマップ
      mapping(uint256 => address) private _tokenApprovals;

      function _mint(address to, uint256 tokenId) internal virtual {
            require( to != address(0), 'ERC721: minting to the zero address');
            require(!_exists(tokenId), 'ERC721, token aleady minted');

            _tokenOwner[tokenId] = to;
            _OwnedTokensCount[to] += 1;
            
            emit Transfer(address(0), to, tokenId);
      }

      // NFTの所有権を移譲させる関数(受信先が受信できるかは確認しない。)
      function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
            require( _to != address(0), 'ERROR - ERC721: transfer to the zero address');
            require(ownerOf(_tokenId) == _from, 'ERROR - ERC721: Trying to transfer a token the address does not own!');

            _tokenOwner[_tokenId] = _to;
            _OwnedTokensCount[_from] -= 1;
            _OwnedTokensCount[_to] += 1;

            emit Transfer(_from, _to, _tokenId);
      }

      function transferFrom(address _from, address _to, uint256 _tokenId) override public {
            require(isApprovedOrOwner(msg.sender, _tokenId), 'ERROR - ERC721: approve caller is not owner nor approved for all');
            _transferFrom(_from, _to, _tokenId);
      }

      function approve(address _to, uint256 _tokenId) public {
            address owner = ownerOf(_tokenId);
            require(_to != owner, 'ERROR - approval to current owner');
            require(msg.sender == owner, 'ERROR - Current caller is not the owner');

            _tokenApprovals[_tokenId] = _to;
            emit Approval(owner, _to, _tokenId);
      }

      // NFTの承認者か承認されたアドレスであることを確認する関数
      function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
            require(_exists(tokenId), 'ERC721, token does not exist');
            address owner = ownerOf(tokenId);
            return (spender == owner || getApproved(tokenId) == spender);
      }

      // トークンIDに紐づく承認されたアドレスを取得するメソッド
      function getApproved(uint256 tokenId) public view returns (address) {
            return _tokenApprovals[tokenId];
      }

      function balanceOf(address owner) public override view returns(uint256) {
            require( owner != address(0), 'owner query for non-exitst token');
            return _OwnedTokensCount[owner];
      }

      function ownerOf(uint256 _tokenId) public override view returns (address) {
            address owner = _tokenOwner[_tokenId];
            require( owner != address(0), 'owner query for non-exitst token');
            return owner;
      }

      function _exists(uint256 tokenId) internal view returns(bool) {
            address owner = _tokenOwner[tokenId];
            return owner != address(0);
      }
}