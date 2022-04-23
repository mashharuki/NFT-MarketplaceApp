// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import './ERC721.sol';
import './interface/IERC721Enumerable.sol';

contract ERC721Enumerable is ERC721, IERC721Enumerable {
      
      uint256[] private _allTokens;

      mapping(address => uint256[]) private _ownedTokens;
      mapping(uint256 => uint256) private _ownedTokensIndex;
      mapping(uint256 => uint256) private _allTokensIndex;

      function totalSupply() public override view returns (uint256) {
            return _allTokens.length;
      }

      function tokenByIndex(uint256 index) public override view returns (uint256) {
            require(index < totalSupply(), 'global index is out of bounds');
            return _allTokens[index];
      }

      function tokenOfOwnerByIndex(address owner, uint256 index) public override view returns (uint256) {
            require(index < balanceOf(owner), 'owner index is out of bounds');
            return _ownedTokens[owner][index];
      }

      function _mint(address to, uint256 tokenId) internal override(ERC721) {
            // 継承元の_mint関数を呼び出す。
            super._mint(to, tokenId);
            // 全体と所有者ごとのマップを更新する。
            _addTokensToAllTokenEnumeration(tokenId);
            _addTokensToOwnerEnumeration(to, tokenId);
      }

      function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
            _allTokensIndex[tokenId] = _allTokens.length;
            _allTokens.push(tokenId);
      }

      function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
            // 所有者のNFTの保有情報を更新する。
            _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
            _ownedTokens[to].push(tokenId);
      }
}