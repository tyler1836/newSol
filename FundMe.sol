pragma solidity >=0.6.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
//import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);

//   function description() external view returns (string memory);

//   function version() external view returns (uint256);

//   // getRoundData and latestRoundData should both raise "No data present"
//   // if they do not have data to report, instead of returning unset values
//   // which could be misinterpreted as actual reported values.
//   function getRoundData(uint80 _roundId)
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );

//   function latestRoundData()
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );
// }

contract FundMe{
    //using SafeMathChainlink for uint256;
    uint public minimumUsd = 50 *10 ** 18;

    mapping(address => uint256) public addressToAmount;
    address[] public funders;
    address owner;

    constructor(){
        owner = msg.sender;
    }

    function fund() public payable{
        require(getConversionRate(msg.value) >= minimumUsd, "You need to spend more ETH!");
        addressToAmount[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns(uint){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getPrice() public view returns(uint){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
                (uint80 roundId,
                int256 answer,
                uint256 startedAt,
                uint256 updatedAt,
                uint80 answeredInRound) = priceFeed.latestRoundData();
                return uint(answer);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / (10 ** 18);
        return ethAmountInUsd;
    }

    modifier onlyOwner{
        require(msg.sender == owner);
        //run  require before underscores
        _;
    }

    function withdraw() payable onlyOwner public{
        //this refers to contract 
        //address of who called the contract sending * to address account contract is deployed at
        payable(msg.sender).transfer(address(this).balance);
        for(uint256 funderIndex =0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmount[funder]= 0;
        }
        funders = new address[](0);
    }
}