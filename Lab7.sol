// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract MyToken {  
    uint _totalSupply = 0; 
    string _symbol;  
    mapping(address => uint) balances;  

    constructor(string memory symbol, uint256 initialSupply) {
        _symbol = symbol;
        _totalSupply = initialSupply;
        balances[msg.sender] = _totalSupply;  
    }  
    
    function transfer(address receiver, uint numTokens) external returns (bool) {    
        require(numTokens <= balances[msg.sender]);        
        balances[msg.sender] = balances[msg.sender] - numTokens;    
        balances[receiver] = balances[receiver] + numTokens;    
        return true;  
    }

    function balanceOf(address account) public view returns(uint256){
        return balances[account];
    }
}


contract Ottoswap {
    int tradeReturn;
    address mTokenCA;
    address tTokenCA;
    string tokenTrading;

    constructor(address mTokenContractAddress, address tTokenContractAddress, string memory tokenExchanging) {
        mTokenCA = mTokenContractAddress;
        tTokenCA = tTokenContractAddress;
        tokenTrading = tokenExchanging;
    }
   
    //Uses the balanceOf function from MyToken
    function balanceOf(address tokenCA, address person) public view returns(uint256){
        uint256 balance = MyToken(tokenCA).balanceOf(person);
        return balance;
    }

    //Sets the current exchange rate of the DEX
    function setExchangeRate(int amountTrading) public returns (int){
        uint mLiquidity = balanceOf(mTokenCA, address(this));
        uint tLiquidity = balanceOf(tTokenCA, address(this));
        int mTokenLiquidity = int(mLiquidity);
        int tTokenLiquidity = int(tLiquidity);

        if(keccak256(abi.encodePacked(tokenTrading)) == keccak256(abi.encodePacked("tToken"))) {
            tradeReturn = -1 * (((mTokenLiquidity * tTokenLiquidity) - ((tTokenLiquidity + amountTrading) * mTokenLiquidity)) 
                     / (tTokenLiquidity + amountTrading));
        } else {
            tradeReturn = -1 * (((mTokenLiquidity * tTokenLiquidity) - ((mTokenLiquidity + amountTrading) * tTokenLiquidity)) 
                     / (mTokenLiquidity + amountTrading));
        }
         return tradeReturn;
    }
    
    //Swaps tokenTrading for the other token
    function swap(address receiver, uint amountTrading) public {
        if(keccak256(abi.encodePacked(tokenTrading)) == keccak256(abi.encodePacked("tToken"))) {
            require(balanceOf(tTokenCA, address(this)) >= amountTrading, "Not enough funds!");
            MyToken(mTokenCA).transfer(receiver, uint(tradeReturn));
        } else {
            require(balanceOf(mTokenCA, address(this)) >= amountTrading, "Not enough funds!");
            MyToken(tTokenCA).transfer(receiver, uint(tradeReturn));
        }
    }
}


contract Cuseswap {
    int tradeReturn;
    address mTokenCA;
    address tTokenCA;
    string tokenTrading;

    constructor(address mTokenContractAddress, address tTokenContractAddress, string memory tokenExchanging) {
        mTokenCA = mTokenContractAddress;
        tTokenCA = tTokenContractAddress;
        tokenTrading = tokenExchanging;
    }
   
    //Uses the balanceOf function from MyToken
    function balanceOf(address tokenCA, address person) public view returns(uint256){
        uint256 balance = MyToken(tokenCA).balanceOf(person);
        return balance;
    }

    //Sets the current exchange rate of the DEX
    function setExchangeRate(int amountTrading) public returns (int){
        uint mLiquidity = balanceOf(mTokenCA, address(this));
        uint tLiquidity = balanceOf(tTokenCA, address(this));
        int mTokenLiquidity = int(mLiquidity);
        int tTokenLiquidity = int(tLiquidity);

        if(keccak256(abi.encodePacked(tokenTrading)) == keccak256(abi.encodePacked("tToken"))) {
            tradeReturn = -1 * (((mTokenLiquidity * tTokenLiquidity) - ((tTokenLiquidity + amountTrading) * mTokenLiquidity)) 
                     / (tTokenLiquidity + amountTrading));
        } else {
            tradeReturn = -1 * (((mTokenLiquidity * tTokenLiquidity) - ((mTokenLiquidity + amountTrading) * tTokenLiquidity)) 
                     / (mTokenLiquidity + amountTrading));
        }
         return tradeReturn;
    }
    
    //Swaps tokenTrading for the other token
    function swap(address receiver, uint amountTrading) public {
        if(keccak256(abi.encodePacked(tokenTrading)) == keccak256(abi.encodePacked("tToken"))) {
            require(balanceOf(tTokenCA, address(this)) >= amountTrading, "Not enough funds!");
            MyToken(mTokenCA).transfer(receiver, uint(tradeReturn));
        } else {
            require(balanceOf(mTokenCA, address(this)) >= amountTrading, "Not enough funds!");
            MyToken(tTokenCA).transfer(receiver, uint(tradeReturn));
        }
    }
}

contract TaskOne {
    address _OttoswapAddress;
    address _CuseswapAddress;

    constructor(address OttoswapAddress, address CuseswapAddress){
        _OttoswapAddress = OttoswapAddress;
        _CuseswapAddress = CuseswapAddress;
    }
    
}