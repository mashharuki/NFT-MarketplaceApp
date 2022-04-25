// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

library SafeMath {

      function add(uint256 a, uint256 b) internal pure returns(uint256) {
            uint256 r = a + b;
            require(r >= a, 'SafeMath: Addition Overflow');
            return r;
      }

      function sub(uint256 a, uint256 b) internal pure returns(uint256) {
            require(b <= a, 'SafeMath: Substraction Overflow');
            uint256 r = a - b;
            return r;
      }

      function mul(uint256 a, uint256 b) internal pure returns(uint256) {
            if (a == 0) {
                  return 0;
            }

            uint256 r = a * b;
            // 小数で割った場合などは、rよりも大きな数になる可能性があるため
            require(r / a == b, 'SafeMath: Multiplication Overflow');
            return r;
      }

      function div(uint256 a, uint256 b) internal pure returns(uint256) {
            require(b > 0, 'SafeMath: Division by zero');
            uint256 r = a / b;
            return r;
      }

      function mod(uint256 a, uint256 b) internal pure returns(uint256) {
            require(b != 0, 'SafeMath: Divide Overflow');
            return a % b;
      }
}