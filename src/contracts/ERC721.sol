// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract ERC721 {
      // event
      event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

      // トークンIDと所有者の紐付けマップ
      mapping(uint256 => address) private _tokenOwner;
      // 所有者と保有しているNFTの数を保有するマップ
      mapping(address => uint256) private _OwnedTokensCount;

      function _mint(address to, uint256 tokenId) internal virtual {
            require( to != address(0), 'ERC721: minting to the zero address');
            require(!_exists(tokenId), 'ERC721, token aleady minted');

            _tokenOwner[tokenId] = to;
            _OwnedTokensCount[to] += 1;
            
            emit Transfer(address(0), to, tokenId);
      }

      function balanceOf(address owner) public view returns(uint256) {
            require( owner != address(0), 'owner query for non-exitst token');
            return _OwnedTokensCount[owner];
      }

      function ownerOf(uint256 _tokenId) external view returns (address) {
            address owner = _tokenOwner[_tokenId];
            require( owner != address(0), 'owner query for non-exitst token');
            return owner;
      }

      function _exists(uint256 tokenId) internal view returns(bool) {
            address owner = _tokenOwner[tokenId];
            return owner != address(0);
      }
}