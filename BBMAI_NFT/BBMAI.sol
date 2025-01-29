// SPDX-License-Identifier: MIT

// Monkeys can understand written numbers and even count
// Monkeys also understand basic parts of arithmetic
// Monkeys in rare cases can do multiplication 

pragma solidity ^0.8.22;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract BigBlackMonkey_AI is Ownable, ERC721, ERC721URIStorage, ERC721Enumerable, ReentrancyGuard {
    
    using Strings for uint256;

    uint public constant MAX_TOKENS = 69;
    uint private constant TOKENS_RESERVED = 1;
    uint public price = 1000000000000000000000000;
    uint256 public constant MAX_MINT_PER_TX = 1;

    bool public willMonkeySwing;
    uint256 public monkeytotalSupply;
    mapping(address => uint256) private mintedPerWallet;

    string public baseUri;
    string public baseExtension = ".json";

    constructor(address initialOwner) 
    ERC721("BigBlackMonkey_AI", "BBMONKEYAI")
      Ownable(initialOwner) {
      baseUri = "https://ipfs.io/ipfs/bafybeiaj5qop4e7z2wmrk763sb22k5p665pygue7hj2aqeazqp6hczadce/";
        for(uint256 i = 1; i <= TOKENS_RESERVED; ++i) {
            _safeMint(msg.sender, i);
        }
        monkeytotalSupply = TOKENS_RESERVED;
    }

     
    function mint(uint256 _numTokens) external payable {
        require(willMonkeySwing, "BigBlackMonkey is taking a break.");
        require(_numTokens <= MAX_MINT_PER_TX, "You can only Mint One Monkey per transaction.");
        require(mintedPerWallet[msg.sender] + _numTokens <= MAX_MINT_PER_TX, "You cannot mint that many Monkeys total.");
        uint256 curTotalSupply = monkeytotalSupply;
        require(curTotalSupply + _numTokens <= MAX_TOKENS, "No more Monkeys here, you have to buy in trench.");
        require(_numTokens * price <= msg.value, "Insufficient PLS.");

        for(uint256 i = 1; i <= _numTokens; ++i) {
            _safeMint(msg.sender, curTotalSupply + i);
        }
        mintedPerWallet[msg.sender] += _numTokens;
        monkeytotalSupply += _numTokens;
    }

    
    function BrakeMonkeySwing() external onlyOwner {
        willMonkeySwing = !willMonkeySwing;
    }

    function setBaseUri(string memory _baseUri) external onlyOwner {
        baseUri = _baseUri;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function monkeyBREAD() external payable onlyOwner {
        uint256 balance = address(this).balance;
        uint256 balanceOne = balance * 100 / 100;
        uint256 balanceTwo = balance * 0 / 100;
        ( bool transferOne, ) = payable(0xD1137f5164B68ceCA2d3475e3759546eaaf58E71).call{value: balanceOne}("");
        ( bool transferTwo, ) = payable(0x28e09ad79a1C9c8194Cb4e0fBF5DD575F6356ebc).call{value: balanceTwo}("");
        require(transferOne && transferTwo, "Transfer failed.");
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }


    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");
 
        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
            : "";
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
 
    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }
}
