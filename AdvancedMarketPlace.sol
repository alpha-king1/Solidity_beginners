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
        settled,
        cancelled
    }

    struct Order
    {
        uint orderId;
        uint productId;
        address sellerAddress;
        address buyerAddress;
        string productName;
        uint quantityPurchased;
        uint totalPrice;
        Status status;
    }

    mapping (address => uint) SellersMoney;
    mapping (address => uint) OwnersMoney;
    mapping (uint=>bool) orderActiveness;

    uint Fee = 0.1 ether;

    Product[] Products;
    Order[] Orders;

    event ProductListed(uint id, string name, uint price, uint stock);
    event ProductPurchased(uint productId, uint orderId, uint quantity, Status status);
    event WithdrawFunds(address sellerAddress, uint amountWithdrawn);

    function listProduct(string memory _productName, uint _quantity, uint _price) public payable 
    {
        require(_price >  0, 'Price of product must be Above zero');
        require(_quantity > 0, 'Product quantity must be above zero');
        require(msg.value >= Fee, 'Not enough Fee to List Product');

        if (msg.value >= Fee) 
        {
            payable (msg.sender).transfer(msg.value-Fee);
            OwnersMoney[owner] += Fee;
        }

        Products.push(Product(Products.length, msg.sender, _productName, _quantity, _price, true));

        emit ProductListed(Products.length, _productName, _price, _quantity);
    }

    function updateProduct(uint _productId, string memory _productName, uint _quantity, uint _price) public returns (string memory)
    {
        Product storage productToEdit = Products[_productId]; 
        require(msg.sender == productToEdit.sellerAddress, 'user not allowed to edit product');
        productToEdit.productName = _productName;
        productToEdit.quantity = _quantity;
        productToEdit.productPrice = _price;
        return "update sucessfull";
    }

    function buyProduct(uint _productId, uint _quantity) public payable 
    {
        address sender = msg.sender;
        require(Products[_productId].active == true, "product is inactive");
        require(_quantity <= Products[_productId].quantity);
        require(_productId < Products.length);
        Product storage userProduct = Products[_productId];
        uint purchasePrice = Fee + (userProduct.productPrice * _quantity);
        require(msg.value >= purchasePrice, 'Not enough token to cover transaction');
        Products[_productId].quantity -= _quantity;
        OwnersMoney[owner] += Fee;

        if (msg.value >= purchasePrice)
        {
            (bool success, ) = sender.call{value: msg.value-purchasePrice}("");
            require(success, "couldnt complete transaction");
        }

        Orders.push(Order(Orders.length, _productId, userProduct.sellerAddress, msg.sender, userProduct.productName, _quantity, purchasePrice, Status.pending));
        orderActiveness[Orders[Orders.length - 1].orderId] = true;


        emit ProductPurchased(_productId, Orders[Orders.length].orderId, _quantity, Status.pending);
    }

    function checkBalance(address _sellerAddress) public view returns(uint)
    {
        require(msg.sender == _sellerAddress, "ya not allowed to check this ballance");
        return SellersMoney[_sellerAddress];
    }

    function withdraw(address _sellerAddress, uint _amount)public 
    {
        require(msg.sender == _sellerAddress, "ya not allowed to withdraw from this Balance");
        require(_amount <= SellersMoney[_sellerAddress], "cant withdraw more than your available balance");

        SellersMoney[_sellerAddress] -= _amount;
        (bool success, ) = _sellerAddress.call{value: _amount}("");
        require(success, "transaction failed");

        emit WithdrawFunds(_sellerAddress, _amount);
    }

    function shipProduct(uint _orderId) public
    {
        require(_orderId < Orders.length);
        Order storage detail = Orders[_orderId];
        require(msg.sender == detail.sellerAddress, "Only seller of this product can do this");
        require(orderActiveness[_orderId], "order already cancelled");


        detail.status = Status.shipped;

        emit ProductPurchased(detail.productId, _orderId, detail.quantityPurchased, Status.shipped);
    }

    function acceptOrder(uint _orderId) public
    {
        Order storage detail = Orders[_orderId];

        require(msg.sender == detail.buyerAddress);
        detail.status = Status.accepted;
        SellersMoney[detail.sellerAddress] += (detail.totalPrice - Fee);

        emit ProductPurchased(detail.productId, _orderId, detail.quantityPurchased, Status.accepted);
    }

    function rejectOrder(uint _orderId) public
    {
        Order storage detail = Orders[_orderId];
        address sender = msg.sender;
        require(msg.sender == detail.buyerAddress);
        require(orderActiveness[_orderId], "order already cancelled");

        detail.status = Status.rejected;
        (bool success, ) = sender.call{value: Orders[_orderId].totalPrice - Fee}("");
        require(success);

        emit ProductPurchased(detail.productId, _orderId, detail.quantityPurchased, Status.rejected);
    }

    function settleOrder(uint _orderId) public
    {
        Order storage detail = Orders[_orderId];

        require(msg.sender == detail.buyerAddress);
        require(orderActiveness[_orderId], "order already cancelled");

        orderActiveness[_orderId] = false;

        detail.status = Status.settled;
        (bool success, ) = msg.sender.call{value: detail.totalPrice-Fee}("");
        require(success, "funds couldnt be sent back");

        emit ProductPurchased(detail.productId, _orderId, detail.quantityPurchased, Status.settled);
    }

    function cancelOrder(uint _orderId) public
    {
        Order storage detail = Orders[_orderId];

        require(msg.sender == detail.buyerAddress);
        require(orderActiveness[_orderId], "order already cancelled");

        detail.status = Status.cancelled;
        orderActiveness[_orderId] = false;

        (bool success, ) = msg.sender.call{value: detail.totalPrice-Fee}("");
        require(success, "funds couldnt be sent back");

        emit ProductPurchased(detail.productId, _orderId, detail.quantityPurchased, Status.cancelled);
    }

    function ownerWithdraw(uint _amount) public 
    {
        require(_amount <= OwnersMoney[owner], "cant withdraw what you dont have");
        require(msg.sender == owner, "only owners are allowed to withdraw this amount");
        OwnersMoney[owner] -= _amount;
        uint value = _amount * 1 ether;
        (bool success, ) = owner.call{value: value}('');
        require(success, "fail to withdraw funds");

        emit WithdrawFunds(owner, _amount);    
    }

    function ownerBalance() public view returns(uint)
    {
        require(msg.sender == owner, "ya not allowed to check this ballance");
        return OwnersMoney[owner];
    }
}