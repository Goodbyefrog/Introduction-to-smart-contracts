// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract OtherWorlds is ERC721, ERC721Enumerable, Pausable, Ownable {

    //Property Variables =========//

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    address _ContractOwner = msg.sender;
    uint256 public  Mint_Price   = 0.01 ether; 
    uint256 public  Max_Supply = 5;

    
    // Life cycle methods =======//
    constructor() ERC721("OtherWorlds", "HEART") {

        _tokenIdCounter.increment();
        

    }

    function Witchdraw() public onlyOwner{
        require (address(this).balance > 0,"Balance is 0");
        payable(owner()).transfer(address(this).balance);

    }

     function transfer(address payable _to, uint _amount) public {
        // Note that "to" is declared as payable
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }

   function sendNFT(address _to, uint256 _tokenId) public {
        safeTransferFrom(msg.sender, _to, _tokenId);
    }

  function buyNFT(uint256 _tokenId) public payable {
    require(ownerOf(_tokenId) != address(0), "Invalid token ID");
    require(msg.value == Mint_Price, "Incorrect amount of ether sent");
    address tokenOwner = ownerOf(_tokenId);
    require(tokenOwner != msg.sender, "Cannot buy your own NFT");
    
    // Transfer ownership of the NFT
    transferFrom(tokenOwner, msg.sender, _tokenId);
    
    // Transfer funds to the previous owner
    payable(tokenOwner).transfer(msg.value);
}






    //Minting Function //

    function safeMint(address to) public payable {

        require(msg.value>= Mint_Price,"Not enough ether.");
        require(totalSupply() < Max_Supply,"No more tokens availabe");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

    }

     function createNFT() public payable onlyOwner returns (uint256) {
        require(msg.value == Mint_Price, "Incorrect amount of ether sent, to create nft");
        uint256 newTokenId = _tokenIdCounter.current();
        Max_Supply = Max_Supply + 1;
         _tokenIdCounter.increment();
       _mint(msg.sender, newTokenId);
        return newTokenId;
    }

         
 



    //Pauseable functions=====//
  

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }



// Other Functions //
    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

     
      function _baseURI() internal pure override returns (string memory) {
        return "https//xxxxxxxxxxxxxxxxxxxxx.jpg/";
    }




    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}





