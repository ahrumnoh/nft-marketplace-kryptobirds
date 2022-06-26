//SPDX-License-Indentifier:MIT
pragma solidity ^0.8.4;

// should bring oepnzeppelin ERC721 functionality


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
//security against transactions for multiple requests
import 'hardhat/console.sol';

contract KBMarket is ReentrancyGuard {
    using Counters for Counters.Counter;

    //number of items minting, number of transactions, tokens that have not been sold
    //keep track of tokens total number - tokenId
    //array need to know the length - help to keep track for arrays

    Counters.Counter private _tokenIds;
    Counters.Counter private _tokenSold;

    //determine who is the owner of the contract
    //charge a listing fee so the owner makes a commission

    address payable owner;
    //we are deploying to matic the API is the same so you can use ether the same as matic
    //they both have 18 decimals
    //0.045 is in the cents
    uint256 listingPrice = 0.045 ether;

    constructor() {
        //set the owner
        owner = payable(msg.sender);
    }

    //structs can act like objects ( we cannot create object, instead of it, we can use struct instead!)

    struct MarketToken {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }


    //tokenId return which marketToken - fetch which one it is



     //mapping is ' to create database , so we can access' 
    mapping(uint256 => MarketToken) private idToMarketToken;


    //listen to events from front end applications
    event MarketTokenMinted(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );


    //get the listing price
    //related with line 30:: uint256 listingPrice = 0.045 ether;
    function getListingPrice() public view returns (uint256) {           
               return listingPrice;
    }


    //two functions to interact with contract
    //1. create a market item to put it up for sale
    //2. create a market sale for buying and selling between parties


    function mintMarketItem(
        address nftContract,
        uint tokenId,
        uint price
    )

    public payable nonReentrant {
        //nonReentrant is a midifier to prevent reentry attack

        require(price > 0, 'Price must be at least one wei');
        require(msg.value == listingPrice, 'Price must be equal to listing price');

        _tokenIds.increment();
        uint itemId = _tokenIds.current();


        //putting it up for sale - bool - no owner
        idToMarketToken[itemId] = MarketToken(
              itemId,
              nftContract,
              tokenId,
              payable(msg.sender),//--person who minting
              payable(address(0)), //-- no owner yet ==address(0)
              price,
              false  //not sold, yet == false

        );


        //NFT transaction


    }
}