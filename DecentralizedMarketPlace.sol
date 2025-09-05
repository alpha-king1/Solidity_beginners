// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract MarketPlace
{
    address deployerAddress;

    struct Product{
        uint productId;
        string productName;
        address ownerAddress;
        uint productQuantity;
        uint productPrice;
        bool buyOnce;
    }

    uint uploadProductPrice = 0.1 ether;
    uint buyProductPrice = 0.1 ether;

    event productDetail(uint productId, string  productName, uint productPrice);
    event puchasedDetails(uint totalPrice, string productName, uint amountPurchased);

    Product[] Products;

    mapping(address=> mapping (uint=> bool)) public inabilityToBuy;

    constructor()
    {
        deployerAddress = msg.sender;
    }

    function createProduct(string memory _productname, uint _productQuantity, uint _productPrice, bool _buyOnce)public payable 
    {
        require(msg.value>=uploadProductPrice, 'Not enough balance');

        if (msg.value>=uploadProductPrice) 
        {
            payable(msg.sender).transfer(msg.value-uploadProductPrice);
        }

        Products.push(Product(Products.length, _productname,msg.sender, _productQuantity, _productPrice, _buyOnce));

        emit productDetail(Products.length - 1, _productname, _productPrice);
    }

    function buyProduct(uint _productId, uint _purchaseQuantity) public payable
    {
        uint totalAmount = Products[_productId].productPrice * _purchaseQuantity;

        require(!inabilityToBuy[msg.sender][_productId], "user cant buy this product");

        require(Products[_productId].productQuantity >= _purchaseQuantity, 'user dosent have enough to sell');

        require(msg.value > totalAmount, 'insufficient balance');

        if (msg.value>=totalAmount + buyProductPrice) 
        {
            (bool sendToOwner, ) = (Products[_productId].ownerAddress).call{value: totalAmount}('paid');
            (bool sendToDeployer, ) = deployerAddress.call{value: buyProductPrice}('paid');

            require(sendToOwner && sendToDeployer, 'transactions failed somewhere');
        }

        if(Products[_productId]. buyOnce)
        {
            inabilityToBuy[msg.sender][_productId] = true;
        }

        Products[_productId].productQuantity -= _purchaseQuantity;

        Products.push(Product(Products.length, Products[_productId].productName, msg.sender, _purchaseQuantity, Products[_productId].productPrice, true));

        emit puchasedDetails(totalAmount , Products[_productId].productName, _purchaseQuantity);
    }

}