// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;
pragma abicoder v2;



contract Wallet {

    uint limit;
    // address owner;
    address[] public owners;
    address payable reciever;

    constructor (uint _limit, address[] memory _owners)  {
                limit  = _limit;
                owners = _owners;

    }


    struct Transfer {
        uint amount;
        address payable receiver;
        // string reasonForTransfer;
        uint approvals;
        bool hasBeenSent;
        uint id;
    }

    Transfer[] transferRequests;

    mapping(address => mapping(uint => bool )) approvals;

    modifier onlyOwners() {
        bool owner = false;
        for(uint i=0; i < owners.length; i++) {
            if(owners[i]  == msg.sender ) {
                owner = true;
            }

        }

        require ( owner == true);
        _;
    }


        
    // }

    function createTransfer(uint _amount, address payable _receiver)  public  onlyOwners{
        transferRequests.push(
            Transfer(_amount, _receiver, 0, false, transferRequests.length)
        );
    }


    function approve(uint _id) public onlyOwners {
        require(approvals[msg.sender][_id] == false);
        require(transferRequests[_id].hasBeenSent == false);

        approvals[msg.sender][_id] = true;
        transferRequests[_id].approvals++;

        if(transferRequests[_id].approvals >= limit ) {
            transferRequests[_id].hasBeenSent = true;
            transferRequests[_id].receiver.transfer(transferRequests[_id].amount);
        }

    }

    function deposit() public payable returns (uint)  {
    }


    function getAccountBalance() public view returns (uint){
        return address(this).balance;
    }

    function getTranferRequests() public view returns(Transfer[] memory) {
        return transferRequests;
    }

}
