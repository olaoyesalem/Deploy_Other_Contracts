//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

contract TestContract1{
    address public owner = msg.sender;

    function setOwner(address _owner) public {
        require(msg.sender==owner, "not sender");
        owner = _owner;
    }
}



contract TestContract2{
    address public owner = msg.sender;
    uint256 public value = msg.value;
    uint256 public x;
    uint256 public y;

    constructor(uint256 _x, uint256 _y) payable{
        x=_x;
        y=_y;
    }
}


contract Proxy{ // This contract can deploy any arbitray contract by passing the byte code

    fallback() external payable{} 
    event Deploy(address);
             function deploy(bytes memory _code) public payable returns(address addr ){
            //to deploy any arbitrary contract we need to use "assembly"
            assembly{
                //create(v,p,n)
                //V = amount of ETh to send
                // P = pointer in memory to start a code
                // n = size of the code 
             addr := create(callvalue(),add(_code, 0x20),mload(_code))
            } 
              // we need to check if the address is not equals to zero address
              require(addr != address(0),"Deploy Failed");

              emit Deploy(addr); 
        }

        // To be able to call function from the contract

        function execute(address _target, bytes memory _data) public payable{
            (bool success, )= _target.call{value:msg.value}(_data);
            require(success,"Failed");
        }

        
    }

    //To get the byte code of a contract
    contract Helper{
        function getByterCode1() public pure returns (bytes memory){
            bytes memory bytecode = type(TestContract1).creationCode;
            return bytecode;
        }
        function getByterCode2(uint256 _x,uint256 _y) public pure returns(bytes memory){
            bytes memory bytecode = type(TestContract2).creationCode;
            return abi.encodePacked(bytecode, abi.encode(_x,_y));
        }
        function getCallData(address _owner) public pure returns(bytes memory){
            return abi.encodeWithSignature("setOwner(address)",_owner);
        }
    }
