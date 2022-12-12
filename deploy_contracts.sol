//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;



contract Proxy{ // This contract can deploy any arbitray contract by passing the byte code
    event Deploy(address);
             function deploy(bytes memory _code) public payable returns(address addr ){
            //to deploy any arbitrary congtract we need to use "assembly"
            assembly{
                //create(v,p,n)
                //V = amount of ETh to send
                // P = pointer in memory to start a code
                // n = sixe of the code 
             addr := create(callvalue(),add(_code, 0x20),mload(_code))
            } 
              // we need to check if the address is not equals to zero address
              require(addr != address(0),"Deploy Failed");

              emit Deploy(addr); 
        }
    }
