// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./Dead_inside.sol";

contract YoungInvestor {
    address investor;
    DeadInsideToken public token;

    CatHouse catInvestee;
    PhilipMorris phInvestee;
    MISiS msInvestee;

    modifier restricted(){
        require(
            msg.sender == investor,
            "You don't have permission to use this function"
        );
        _;
    }

    struct CatHouse{
        string gratitude;
        address add;
    }

    struct PhilipMorris{
        string gratitude;
        address add;
    }

    struct MISiS{
        string gratitude;
        address add;
    }

    constructor(address lol) public{
        token = DeadInsideToken(lol);
    }

    function init(address add_1, address add_2, address add_3) public{
        investor = msg.sender;
        setCatHouse(add_1);
        setPhilipMorris(add_2);
        setMisis(add_3);
    }

    function setCatHouse(address add) private {
        catInvestee = CatHouse("Now cats are more happy!", add);
        token.transfer(catInvestee.add, 0);
    }

    function setPhilipMorris(address add) private {
        phInvestee = PhilipMorris("Now there are more smokers!", add);
        token.transfer(phInvestee.add, 0);
    }
    
    function setMisis(address add) private {
        msInvestee = MISiS("Now we can recruit more teachers!", add);
        token.transfer(msInvestee.add, 0);
    }
    
    function getInvestorAddress() public view returns (address) {
        return investor;
    }

    function getCatHouseAddress() public view returns (address) {
        return catInvestee.add;
    }

    function getPhilipMorrisAddress() public view returns (address) {
        return phInvestee.add;
    }

    function getMisisAddress() public view returns (address) {
        return msInvestee.add;
    }

    function investCats(uint _value) public restricted {
        token.transfer(catInvestee.add, _value);
        emit Gratitude(catInvestee.gratitude);
    }

    function investPhilipMorris(uint _value) public restricted {
        token.transfer(phInvestee.add, _value);
        emit Gratitude(phInvestee.gratitude);
    }

    function investMisis(uint _value) public restricted {
        token.transfer(msInvestee.add, _value);
        emit Gratitude(msInvestee.gratitude);
    }

    function balance() public returns (uint) {
        emit Invested("Balance of investor" ,token.balanceOf(investor));
        return token.balanceOf(investor); 
    }

    function investedMisis() public {
        emit Invested("Invested in MISIS" ,token.balanceOf(msInvestee.add));
    }

    function investedPhilipMorris() public {
        emit Invested("Invested in PhilipMorris" ,token.balanceOf(phInvestee.add));
    }

    function investedCatHouse() public {
        emit Invested("Invested in CatHouse" ,token.balanceOf(catInvestee.add));
    }

    event Balance(uint bal);

    event Gratitude(string gr);

    event Invested(string str, uint inv);
}
