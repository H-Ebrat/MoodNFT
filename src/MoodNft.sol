//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {

    //errors
    error MOodnft__cantflipMoodNotOwner();



    uint256 private s_tokenCounter;
    string private s_sadCatImageUri;
    string private s_happyCatImageUri;

    enum Mood {
        SAD,
        HAPPY
    }

    // Mapping from token ID to mood
    mapping(uint256 => Mood) private s_tokenIdToMood;
    
    constructor(string memory sadCatImageUri, string memory happyCatImageUri) ERC721("MoodNFT", "MOOD") {
        s_tokenCounter = 0;
        s_sadCatImageUri = sadCatImageUri;
        s_happyCatImageUri = happyCatImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY; // Default mood is HAPPY
        s_tokenCounter++;
    }





    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }


    function flipMood(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        if (msg.sender != owner && !isApprovedForAll(owner, msg.sender) && getApproved(tokenId) != msg.sender) {
            revert MOodnft__cantflipMoodNotOwner();
        }
        
        // Flip the mood
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }


    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(tokenId < s_tokenCounter, "Token ID does not exist");

        string memory imageUri;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageUri = s_happyCatImageUri;
        } else {
            imageUri = s_sadCatImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "description":"A mood NFT", "image":"',
                            imageUri,
                            '"}'
                        )
                    )
                )
            )
        );
    }

}