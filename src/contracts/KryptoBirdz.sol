// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import './ERC721Connector.sol';

contract Kryptobirdz is ERC721Connector {

      // NFTを格納するための配列
      string[] public KryptoBirdz;

      mapping(string => bool) _kryptoBirdzExists;

      constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {
            
      }

      function mint(string memory _kryptoBird) public {
            require(!_kryptoBirdzExists[_kryptoBird], 'ERROR - kryptoBird has aleady exists');

            KryptoBirdz.push(_kryptoBird);
            uint _id  = KryptoBirdz.length - 1;

            _mint(msg.sender, _id);
            _kryptoBirdzExists[_kryptoBird] = true;
      }
}