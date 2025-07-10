//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";

contract BasicNftTest is Test {
    BasicNFT public basicNFT;
    address public USER = makeAddr("user");
    string public constant TOKEN_URI = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        // Deploy BasicNFT directly for integration testing
        basicNFT = new BasicNFT();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNFT.name();
        assertEq(expectedName, actualName, "Name does not match");
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNFT.mintNFT(TOKEN_URI);
        uint256 balance = basicNFT.balanceOf(USER);
        assertEq(balance, 1, "Balance should be 1 after minting");
    }
}