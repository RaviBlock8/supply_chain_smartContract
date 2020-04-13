pragma solidity ^0.6.0;


contract ItemManager {
    enum SupplyChainState {created, paid, delivered}
    struct S_item {
        string _identifier;
        uint256 _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    event itemState(uint256 _itemIndex, ItemManager.SupplyChainState _state);
    mapping(uint256 => S_item) public items;
    uint256 itemIndex;

    function createItem(string memory _identifier, uint256 _itemPrice) public {
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.created;
        itemIndex++;
    }

    function triggerPayment(uint256 _itemIndex) public payable {
        require(
            items[_itemIndex]._itemPrice == msg.value,
            "only full payments accepted"
        );
        require(
            items[_itemIndex]._state == SupplyChainState.created,
            "item is further in the chain"
        );
        items[_itemIndex]._state = SupplyChainState.paid;
        emit itemState(_itemIndex, items[_itemIndex]._state);
    }

    function triggerDelievery(uint256 _itemIndex) public {
        require(
            items[_itemIndex]._state == SupplyChainState.paid,
            "item is further in the chain"
        );
        items[_itemIndex]._state = SupplyChainState.delivered;
        emit itemState(_itemIndex, items[_itemIndex]._state);
    }
}
