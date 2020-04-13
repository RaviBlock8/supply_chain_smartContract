pragma solidity ^0.6.0;

import "./Item.sol";
import "./Ownable.sol";


contract ItemManager is Ownable {
    enum SupplyChainState {created, paid, delivered}
    struct S_item {
        string _identifier;
        uint256 _itemPrice;
        ItemManager.SupplyChainState _state;
        Item _item;
    }
    event itemState(
        uint256 _itemIndex,
        ItemManager.SupplyChainState _state,
        address _item
    );
    mapping(uint256 => S_item) public items;
    uint256 itemIndex;

    function createItem(string memory _identifier, uint256 _itemPrice)
        public
        onlyOwner
    {
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.created;
        items[itemIndex]._item = item;
        emit itemState(
            itemIndex,
            items[itemIndex]._state,
            address(items[itemIndex]._item)
        );
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
        emit itemState(
            _itemIndex,
            items[_itemIndex]._state,
            address(items[_itemIndex]._item)
        );
    }

    function triggerDelievery(uint256 _itemIndex) public onlyOwner {
        require(
            items[_itemIndex]._state == SupplyChainState.paid,
            "item is further in the chain"
        );
        items[_itemIndex]._state = SupplyChainState.delivered;
        emit itemState(
            _itemIndex,
            items[_itemIndex]._state,
            address(items[_itemIndex]._item)
        );
    }
}
