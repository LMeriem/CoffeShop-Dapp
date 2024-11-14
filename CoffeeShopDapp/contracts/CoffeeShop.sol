// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoffeeShop {
    enum OrderStatus { Pending, InDelivery, Delivered, Confirmed }

    struct MenuItem {
        string name;
        uint price;
    }

    struct Order {
        uint id;
        address customer;
        uint itemId;
        OrderStatus status;
        uint256 timestamp;
    }

    MenuItem[] public menu;
    Order[] public orders;
    uint public nextOrderId;
    address public owner;

    event OrderPlaced(uint indexed orderId, address indexed customer, uint indexed itemId);
    event OrderStatusUpdated(uint indexed orderId, OrderStatus status);
    event OrderConfirmed(uint indexed orderId, address indexed customer);
    event Withdrawal(address indexed owner, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;

        // Initialize the menu with given items and prices
        menu.push(MenuItem("Hot Cappuccino S", 850));
        menu.push(MenuItem("Hot Cappuccino L", 1050));
        menu.push(MenuItem("Hot Americano S", 950));
        menu.push(MenuItem("Hot Americano L", 1250));
        menu.push(MenuItem("Hot Latte M", 1175));
        menu.push(MenuItem("Hot Latte L", 1475));
        menu.push(MenuItem("Hot Espresso", 0)); // Set price if needed
        menu.push(MenuItem("Hot Chocolate M", 1175));
        menu.push(MenuItem("Hot Chocolate L", 1475));
        menu.push(MenuItem("Iced Cappuccino Small", 1000));
        menu.push(MenuItem("Iced Cappuccino Large", 1500));
        menu.push(MenuItem("Iced Americano Small", 1250));
        menu.push(MenuItem("Iced Americano Large", 1650));
        menu.push(MenuItem("Iced Milky Latte Small", 1400));
        menu.push(MenuItem("Iced Milky Latte Large", 1800));
        menu.push(MenuItem("Iced Espresso", 0)); // Set price if needed
        menu.push(MenuItem("Iced Mocha Small", 1000));
        menu.push(MenuItem("Iced Mocha Large", 1500));
    }

    function placeOrder(uint itemId) external payable {
        require(itemId < menu.length, "Invalid item ID");
        require(msg.value == menu[itemId].price, "Incorrect payment amount");

        orders.push(Order({
            id: nextOrderId,
            customer: msg.sender,
            itemId: itemId,
            status: OrderStatus.Pending,
            timestamp: block.timestamp
        }));

        emit OrderPlaced(nextOrderId, msg.sender, itemId);
        nextOrderId++;
    }

    function updateOrderStatus(uint orderId, OrderStatus status) external onlyOwner {
        require(orderId < orders.length, "Invalid order ID");
        require(status == OrderStatus.InDelivery || status == OrderStatus.Delivered, "Invalid status update");

        orders[orderId].status = status;
        emit OrderStatusUpdated(orderId, status);
    }

    function confirmDelivery(uint orderId) external {
        require(orderId < orders.length, "Invalid order ID");
        require(orders[orderId].customer == msg.sender, "Not your order");
        require(orders[orderId].status == OrderStatus.Delivered, "Order not delivered yet");

        orders[orderId].status = OrderStatus.Confirmed;
        emit OrderConfirmed(orderId, msg.sender);
    }

    function getOrder(uint orderId) external view returns (Order memory) {
        require(orderId < orders.length, "Invalid order ID");
        return orders[orderId];
    }

    function getMenu() external view returns (MenuItem[] memory) {
        return menu;
    }

    function withdraw() external onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        
        payable(owner).transfer(balance);
        emit Withdrawal(owner, balance);
    }
}
