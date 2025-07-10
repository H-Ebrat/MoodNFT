// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {MoodNft} from "../../src/MoodNft.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }



    function test_SvgToImageUri() public {
        string memory testSvg = '<svg width="100" height="100"><circle cx="50" cy="50" r="25" fill="red"/></svg>';
        string memory imageUri = deployer.svgToImageUri(testSvg);
        
        // Verify the image URI starts with the correct prefix
        assertTrue(
            startsWith(imageUri, "data:image/svg+xml;base64,"),
            "Image URI should start with data:image/svg+xml;base64,"
        );
        
        // Verify the URI is longer than just the prefix (contains encoded data)
        assertTrue(
            bytes(imageUri).length > 26, // length of "data:image/svg+xml;base64,"
            "Image URI should contain encoded SVG data"
        );
        
        console.log("Generated image URI:", imageUri);
    }

    function test_SvgToImageUriWithComplexSvg() public view {
        string memory complexSvg = '<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg"><circle cx="100" cy="100" r="50" fill="blue"/><rect x="75" y="75" width="50" height="50" fill="red"/></svg>';
        string memory imageUri = deployer.svgToImageUri(complexSvg);
        
        assertTrue(
            startsWith(imageUri, "data:image/svg+xml;base64,"),
            "Complex SVG should be properly encoded"
        );
        
        console.log("Complex SVG URI:", imageUri);
    }

    function test_SvgToImageUriWithEmptySvg() public view{
        string memory emptySvg = "";
        string memory imageUri = deployer.svgToImageUri(emptySvg);
        
        assertTrue(
            startsWith(imageUri, "data:image/svg+xml;base64,"),
            "Empty SVG should still have correct prefix"
        );
        
        console.log("Empty SVG URI:", imageUri);
    }

    function test_ReadSvgFiles() public view {
        // Test reading SVG files from the filesystem
        string memory sadSvg = vm.readFile("img/SadCat.svg");
        string memory happySvg = vm.readFile("img/HappyCat.svg");
        
        // Verify files are not empty
        assertTrue(bytes(sadSvg).length > 0, "SadCat.svg should not be empty");
        assertTrue(bytes(happySvg).length > 0, "HappyCat.svg should not be empty");
        
        // Verify they contain SVG content
        assertTrue(startsWith(sadSvg, "<svg"), "SadCat.svg should start with <svg");
        assertTrue(startsWith(happySvg, "<svg"), "HappyCat.svg should start with <svg");
        
        console.log("SadCat.svg length:", bytes(sadSvg).length);
        console.log("HappyCat.svg length:", bytes(happySvg).length);
    }

    function test_DeployMoodNftContract() public {
        // Test the actual contract deployment logic using readFile
        string memory sadSvg = vm.readFile("img/SadCat.svg");
        string memory happySvg = vm.readFile("img/HappyCat.svg");
        
        string memory sadCatImageUri = deployer.svgToImageUri(sadSvg);
        string memory happyCatImageUri = deployer.svgToImageUri(happySvg);
        
        // Deploy the contract
        MoodNft moodNft = new MoodNft(sadCatImageUri, happyCatImageUri);
        
        // Verify the contract was deployed correctly
        assertEq(moodNft.name(), "MoodNFT");
        assertEq(moodNft.symbol(), "MOOD");
        
        console.log("MoodNft deployed successfully at:", address(moodNft));
    }

    // Helper function to check if a string starts with a prefix
    function startsWith(string memory str, string memory prefix) internal pure returns (bool) {
        bytes memory strBytes = bytes(str);
        bytes memory prefixBytes = bytes(prefix);
        
        if (strBytes.length < prefixBytes.length) {
            return false;
        }
        
        for (uint i = 0; i < prefixBytes.length; i++) {
            if (strBytes[i] != prefixBytes[i]) {
                return false;
            }
        }
        
        return true;
    }
} 