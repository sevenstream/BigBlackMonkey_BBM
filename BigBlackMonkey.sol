// SPDX-License-Identifier: MIT
Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20FlashMint} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20FlashMint.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract BigBlackMonkey is ERC20, ERC20Permit, ERC20FlashMint {
     constructo() ERC20("BigBlackMonkey", "BBM") ERC20Permit("BigBlackMonkey") {
         _mint(msg.sender, 1000000000 * 10 ** decimals());
     }
}





