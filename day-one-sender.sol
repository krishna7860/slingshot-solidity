pragma solidity ^0.8.6;

contract Helpers {
    function balance() public view returns(uint256){
        return address(this).balance;
    }

    struct Payer {
        uint256 amount;
        address ethaddress;
    }
}

contract Sender is Helpers {
    function send(Payer[] memory users) external payable {
        for(uint256 i = 0; i < users.length ; i++ ) {
            address payable user = payable(users[i].ethaddress);
            require(users[i].amount <= balance(), "not enough balance");
            user.transfer(users[i].amount);
        }
        payable(msg.sender).transfer(balance());
    }
}
// function input:  [[1, "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]]

