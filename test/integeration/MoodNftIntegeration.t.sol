// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";



contract MoodNftIntegerationTest is Test {
    MoodNft public moodNft;
    address public user = address(1);
    address public user2 = address(2);

    string public constant SAD_CAT_URI = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDIwMCAyMDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMTAwIiBjeT0iMTAwIiByPSI1MCIgZmlsbD0iZ3JheSIvPjxjaXJjbGUgY3g9IjgwIiBjeT0iODAiIHI9IjUiIGZpbGw9ImdyZWVuIi8+PGNpcmNsZSBjeD0iMTIwIiBjeT0iODAiIHI9IjUiIGZpbGw9ImdyZWVuIi8+PHBhdGggZD0iTTgwIDEyMCBRMTAwIDEzMCAxMjAgMTIwIiBzdHJva2U9ImdyZWVuIiBmaWxsPSJub25lIi8+PC9zdmc+";
    string public constant HAPPY_CAT_URI = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDIwMCAyMDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMTAwIiBjeT0iMTAwIiByPSI1MCIgZmlsbD0ieWVsbG93Ii8+PGNpcmNsZSBjeD0iODAiIGN5PSI4MCIgcj0iNSIgZmlsbD0iZ3JlZW4iLz48Y2lyY2xlIGN4PSIxMjAiIGN5PSI4MCIgcj0iNSIgZmlsbD0iZ3JlZW4iLz48cGF0aCBkPSJNODAgMTIwIFE5MCAxMDAgMTAwIDEyMCBRMTEwIDEwMCAxMjAgMTIwIiBzdHJva2U9ImdyZWVuIiBmaWxsPSJub25lIi8+PC9zdmc+";
    DeployMoodNft public deployer;


    
    function setUp() public {
        DeployMoodNft deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    // Test Constructor
    function test_Constructor() public view {
        assertEq(moodNft.name(), "MoodNFT");
        assertEq(moodNft.symbol(), "MOOD");
    }

    // Test mintNft function
    function test_MintNft() public {
        vm.startPrank(user);
        
        moodNft.mintNft();
        
        assertEq(moodNft.ownerOf(0), user);
        
        vm.stopPrank();
    }

    function test_MintNftIncrementsCounter() public {
        vm.startPrank(user);
        
        moodNft.mintNft();
        moodNft.mintNft();
        
        assertEq(moodNft.ownerOf(0), user);
        assertEq(moodNft.ownerOf(1), user);
        
        vm.stopPrank();
    }

    function test_MultipleUsersCanMint() public {
        vm.startPrank(user);
        moodNft.mintNft();
        vm.stopPrank();
        
        vm.startPrank(user2);
        moodNft.mintNft();
        vm.stopPrank();
        
        assertEq(moodNft.ownerOf(0), user);
        assertEq(moodNft.ownerOf(1), user2);
    }

    // Test tokenURI function
    function test_TokenURIForHappyMood() public {
        vm.startPrank(user);
        moodNft.mintNft();
        vm.stopPrank();
        
        string memory tokenURI = moodNft.tokenURI(0);
        console.log("Token URI for token 0:", tokenURI);
        
        // Should return happy cat URI since default mood is HAPPY
        assertEq(tokenURI, HAPPY_CAT_URI);
    }

    function test_TokenURIForNonExistentToken() public {
        vm.expectRevert("Token ID does not exist");
        moodNft.tokenURI(999);
    }

    // Test flipMood function
    function test_FlipMoodFromHappyToSad() public {
        vm.startPrank(user);
        moodNft.mintNft();
        
        // Verify initial mood is HAPPY
        string memory tokenURI = moodNft.tokenURI(0);
        assertEq(tokenURI, HAPPY_CAT_URI);
        
        // Flip mood to SAD
        moodNft.flipMood(0);
        
        // Verify mood changed to SAD
        string memory newTokenURI = moodNft.tokenURI(0);
        assertEq(newTokenURI, SAD_CAT_URI);
        
        // Flip back to HAPPY
        moodNft.flipMood(0);
        
        // Verify mood changed back to HAPPY
        string memory finalTokenURI = moodNft.tokenURI(0);
        assertEq(finalTokenURI, HAPPY_CAT_URI);
        
        vm.stopPrank();
    }

    function test_FlipMoodOnlyOwnerCanFlip() public {
        vm.startPrank(user);
        moodNft.mintNft();
        vm.stopPrank();
        
        // Try to flip mood from non-owner account
        vm.startPrank(user2);
        vm.expectRevert("MOodnft__cantflipMoodNotOwner");
        moodNft.flipMood(0);
        vm.stopPrank();
        
        // Verify mood is still HAPPY (unchanged)
        string memory tokenURI = moodNft.tokenURI(0);
        assertEq(tokenURI, HAPPY_CAT_URI);
    }

    function test_FlipMoodWithApproval() public {
        vm.startPrank(user);
        moodNft.mintNft();
        moodNft.approve(user2, 0);
        vm.stopPrank();
        
        // user2 should be able to flip mood with approval
        vm.startPrank(user2);
        moodNft.flipMood(0);
        vm.stopPrank();
        
        // Verify mood changed to SAD
        string memory tokenURI = moodNft.tokenURI(0);
        assertEq(tokenURI, SAD_CAT_URI);
    }

    function test_FlipMoodNonExistentToken() public {
        vm.startPrank(user);
        vm.expectRevert("ERC721: invalid token ID");
        moodNft.flipMood(999);
        vm.stopPrank();
    }

    // Test _baseURI function (indirectly through tokenURI)
    function test_BaseURI() public {
        vm.startPrank(user);
        moodNft.mintNft();
        vm.stopPrank();
        
        string memory tokenURI = moodNft.tokenURI(0);
        
        // The tokenURI should start with the base URI
        // Since we're returning the full URI directly, this test verifies the structure
        assertTrue(bytes(tokenURI).length > 0);
        console.log("Base URI test - Token URI length:", bytes(tokenURI).length);
    }

    

    function test_ERC721OwnerOf() public {
        vm.startPrank(user);
        moodNft.mintNft();
        vm.stopPrank();
        
        assertEq(moodNft.ownerOf(0), user);
    }

    function test_ERC721OwnerOfNonExistent() public {
        vm.expectRevert("ERC721: invalid token ID");
        moodNft.ownerOf(999);
    }

    // Test balance tracking
    function test_BalanceOf() public {
        vm.startPrank(user);
        
        assertEq(moodNft.balanceOf(user), 0);
        
        moodNft.mintNft();
        assertEq(moodNft.balanceOf(user), 1);
        
        moodNft.mintNft();
        assertEq(moodNft.balanceOf(user), 2);
        
        vm.stopPrank();
    }

    // Test transfer functionality
    function test_Transfer() public {
        vm.startPrank(user);
        moodNft.mintNft();
        vm.stopPrank();
        
        vm.startPrank(user);
        moodNft.transferFrom(user, user2, 0);
        vm.stopPrank();
        
        assertEq(moodNft.ownerOf(0), user2);
        assertEq(moodNft.balanceOf(user), 0);
        assertEq(moodNft.balanceOf(user2), 1);
    }

    // Test approval functionality
    function test_Approve() public {
        vm.startPrank(user);
        moodNft.mintNft();
        moodNft.approve(user2, 0);
        vm.stopPrank();
        
        vm.startPrank(user2);
        moodNft.transferFrom(user, user2, 0);
        vm.stopPrank();
        
        assertEq(moodNft.ownerOf(0), user2);
    }

    // Test getApproved
    function test_GetApproved() public {
        vm.startPrank(user);
        moodNft.mintNft();
        moodNft.approve(user2, 0);
        vm.stopPrank();
        
        assertEq(moodNft.getApproved(0), user2);
    }

    // Test isApprovedForAll
    function test_IsApprovedForAll() public {
        vm.startPrank(user);
        moodNft.setApprovalForAll(user2, true);
        vm.stopPrank();
        
        assertTrue(moodNft.isApprovedForAll(user, user2));
    }
} 