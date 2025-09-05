// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract MarketPlace
{
    address owner;
    constructor()
    {
        owner = msg.sender;
    }

    struct Product
    {
        uint productId;
        address sellerAddress;
        string productName;
        uint quantity;
        uint productPrice;
        bool active;
    }

    enum Status
    {
        pending,
        shipped,
        accepted,
        rejected,
        cancelled
    }

    struct Order
    {
        uint orderId;
        uint productId;
        address sellerAddress;
        string productName;
        uint quantityPurchased;
        uint totalPrice;
        //Status Created, Paid, Shipped, Delivered, Disputed, ResolvedSeller, ResolvedBuyer, Cancelled
    }

    struct SellersMoney 
    {
        address sellerAddress;
        uint balance;
    }

    SellersMoney[] SellersMoneys;

    uint Fee = 0.1 ether;

    Product[] Products;
    event ProductListed(uint id, string name, uint price, uint stock);

    function listProduct(string memory _productName, uint _quantity, uint _price) public payable 
    {
        require(_price <=  0, 'Price of product must be Above zero');
        require(_quantity <= 0, 'Product quantity must be above zero');
        require(msg.value >= Fee, 'Not enough Fee to List Product');

        if (msg.value >= Fee) 
        {
            payable (msg.sender).transfer(msg.value-Fee);
        }

        Products.push(Product(Products.length, msg.sender, _productName, _quantity, _price, true));

        emit ProductListed(Products.length, _productName, _price, _quantity);
    }

    // function updateProduct(uint _productId, string memory _productName, uint _quantity, uint _price) public returns (string memory)
    // {
    //     Product memory productToEdit = Products[_productId]; 
    //     require(msg.sender == productToEdit.sellerAddress, 'user not allowed to edit product');

    //     // if ((_productName)) 
    //     // {
    //     //        productToEdit.productName = _productName;
    //     // }

    //     // if(_quantity)
    //     // {
    //     //     productToEdit.quantity = _quantity;
    //     // }

    //     // if (_price) {
    //     //     productToEdit.productPrice = _price;
    //     // }
        
    //     return "update sucessfull";
    // }

    function buyProduct(uint _productId) public payable 
    {
        Product memory userProduct = Products[_productId];
        uint purchasePrice = userProduct.productPrice;
        require(msg.value >= Fee + purchasePrice, 'Not enough token to cover transaction');

        if (msg.value >= Fee + purchasePrice) 
        {
            (bool sendToOwner, ) = (owner).call{value: Fee}('paid');
            require(sendToOwner, 'unable to send');
        }

    }

}