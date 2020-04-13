pragma solidity ^0.6.0;

import "./eventtrigger/..";


contract Item {
    uint256 public priceInWei;
    uint256 public pricePaid;
    uint256 public index;
    ItemManager paperContract;

    constructor(ItemManager _paperContract, uint256 _priceInWei, uint256 _index)
        public
    {
        priceInWei = _priceInWei;
        index = _index;
        paperContract = _paperContract;
    }

    receive() external payable {
        require(pricePaid == 0, "price is paid already");
        require(priceInWei == msg.value, "only full payment accepted");
        pricePaid += msg.value;
        (bool success, ) = address(paperContract).call.value(msg.value)(
            abi.encodeWithSignature("triggerPayment(uint256)", index)
        );
        require(success, "transfer of payment was not successfull");
    }

    fallback() external {}
}
