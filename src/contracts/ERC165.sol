// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import './interface/IERC165.sol';

contract ERC165 is IERC165 {

    // インターフェースのフィンガープリントとサポートの有無を保有するマップ
    mapping(bytes4 => bool) private _supportedInterfaces;

    // コンストラクター
    constructor() {
        // インターフェースIDを登録する。
        _registerInterface(bytes4(keccak256("supportsInterface(bytes4)")));
    }

    function supportsInterface(bytes4 interfaceId) external override view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    // 関数のフィンガープリントを計算する関数
    function calcFngerPrint() public view returns(bytes4) {
        return bytes4(keccak256("supportsInterface(bytes4)"));
    }

    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, 'ERROR - ERC165: Invalid Interface');
        _supportedInterfaces[interfaceId] = true;
    }
}