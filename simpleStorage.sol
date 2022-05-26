pragma solidity ^0.6.0;

contract SimpleStorage{

    uint256 public faovriteNumber;
    string public name;

    struct People{
        uint256 faovriteNumber;
        string name;
    }

    People[] public person;
    mapping(string => uint) public nameToNumber;

    constructor()public {
        faovriteNumber = 255;
    }

    function retrieve()public view returns(uint256){
        return faovriteNumber;
    }

    function store(string memory _name, uint256 _faovriteNumber) public{
        faovriteNumber = _faovriteNumber;
        name = _name;
        person.push(People(_faovriteNumber, _name));
        //[_name] is key _favoriteNumber is value
        nameToNumber[_name] = _faovriteNumber;
    }
}
