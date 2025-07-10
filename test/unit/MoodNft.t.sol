// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";

contract MoodNftTest is Test {
    MoodNft public moodNft;
    address public user = address(1);
    address public user2 = address(2);

    string public constant SAD_CAT_URI = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDIwMCAyMDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMTAwIiBjeT0iMTAwIiByPSI1MCIgZmlsbD0iZ3JheSIvPjxjaXJjbGUgY3g9IjgwIiBjeT0iODAiIHI9IjUiIGZpbGw9ImdyZWVuIi8+PGNpcmNsZSBjeD0iMTIwIiBjeT0iODAiIHI9IjUiIGZpbGw9ImdyZWVuIi8+PHBhdGggZD0iTTgwIDEyMCBRMTAwIDEzMCAxMjAgMTIwIiBzdHJva2U9ImdyZWVuIiBmaWxsPSJub25lIi8+PC9zdmc+";
    string public constant HAPPY_CAT_URI = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDIwMCAyMDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMTAwIiBjeT0iMTAwIiByPSI1MCIgZmlsbD0ieWVsbG93Ii8+PGNpcmNsZSBjeD0iODAiIGN5PSI4MCIgcj0iNSIgZmlsbD0iZ3JlZW4iLz48Y2lyY2xlIGN4PSIxMjAiIGN5PSI4MCIgcj0iNSIgZmlsbD0iZ3JlZW4iLz48cGF0aCBkPSJNODAgMTIwIFE5MCAxMDAgMTAwIDEyMCBRMTEwIDEwMCAxMjAgMTIwIiBzdHJva2U9ImdyZWVuIiBmaWxsPSJub25lIi8+PC9zdmc+";

    function setUp() public {
        moodNft = new MoodNft(SAD_CAT_URI, HAPPY_CAT_URI);
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

    // Test flipMood function
    function test_FlipMoodFromHappyToSad() public {
        // Mint an NFT (starts as HAPPY by default)
        vm.startPrank(user);
        moodNft.mintNft();
        
        // Build expected happy tokenURI
        string memory expectedHappyJSON = string(abi.encodePacked(
            '{"name":"MoodNFT", "description":"A mood NFT", "image":"',
            HAPPY_CAT_URI,
            '"}'
        ));
        string memory expectedHappyTokenURI = string(abi.encodePacked(
            "data:application/json;base64,",
            encodeBase64(bytes(expectedHappyJSON))
        ));
        
        // Verify initial mood is HAPPY
        string memory initialURI = moodNft.tokenURI(0);
        assertEq(
            keccak256(abi.encodePacked(initialURI)),
            keccak256(abi.encodePacked(expectedHappyTokenURI)),
            "Token should start as happy"
        );
        
        // Flip the mood
        moodNft.flipMood(0);
        
        // Build expected sad tokenURI
        string memory expectedSadJSON = string(abi.encodePacked(
            '{"name":"MoodNFT", "description":"A mood NFT", "image":"',
            SAD_CAT_URI,
            '"}'
        ));
        string memory expectedSadTokenURI = string(abi.encodePacked(
            "data:application/json;base64,",
            encodeBase64(bytes(expectedSadJSON))
        ));
        
        // Verify mood changed to SAD
        string memory flippedURI = moodNft.tokenURI(0);
        assertEq(
            keccak256(abi.encodePacked(flippedURI)),
            keccak256(abi.encodePacked(expectedSadTokenURI)),
            "Token should be sad after flip"
        );
        
        vm.stopPrank();
    }

    function test_FlipMoodOnlyOwnerCanFlip() public {
        // Mint an NFT as user
        vm.startPrank(user);
        moodNft.mintNft();
        vm.stopPrank();
        
        // Try to flip mood as non-owner (user2)
        vm.startPrank(user2);
        vm.expectRevert(); // Should revert with MOodnft__cantflipMoodNotOwner error
        moodNft.flipMood(0);
        vm.stopPrank();
    }

    // Simple base64 encoding function
    function encodeBase64(bytes memory data) internal pure returns (string memory) {
        string memory table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        if (data.length == 0) return "";
        
        string memory result = new string(4 * ((data.length + 2) / 3));
        bytes memory resultBytes = bytes(result);
        
        uint256 resultIndex = 0;
        for (uint256 i = 0; i < data.length; i += 3) {
            uint256 b = (uint256(uint8(data[i])) << 16);
            if (i + 1 < data.length) {
                b |= (uint256(uint8(data[i + 1])) << 8);
            }
            if (i + 2 < data.length) {
                b |= uint256(uint8(data[i + 2]));
            }
            
            resultBytes[resultIndex++] = bytes1(uint8(bytes(table)[b >> 18]));
            resultBytes[resultIndex++] = bytes1(uint8(bytes(table)[(b >> 12) & 0x3F]));
            resultBytes[resultIndex++] = bytes1(uint8(bytes(table)[(b >> 6) & 0x3F]));
            resultBytes[resultIndex++] = bytes1(uint8(bytes(table)[b & 0x3F]));
        }
        
        // Add padding
        if (data.length % 3 == 1) {
            resultBytes[resultIndex - 1] = '=';
            resultBytes[resultIndex - 2] = '=';
        } else if (data.length % 3 == 2) {
            resultBytes[resultIndex - 1] = '=';
        }
        
        return result;
    }
} 