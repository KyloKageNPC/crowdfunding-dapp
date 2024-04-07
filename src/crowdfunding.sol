// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Crowdfunding{
    //let me cook
    address public owner;
    uint256 public amountCollected;
    uint256 public target;
    uint256 public threshold;
    struct Campaign {
        address owner; //owner of the contract
        string title;// title of the campaign 
        string image;// image is a string because the url will go here
        string description;// description of the campaign 
        uint256 target; // target amount of the campaign 
        uint256 deadline; //when the crowdfunding camapign ends 
        address[] donators; //the adress isan array because it will be multiple contributers
        uint256[] donations; //list of donations    
        uint256 threshold; // the minimun amount that could be reached for the owner to withdraw   
        uint256 amountCollected;
    }
    mapping(uint256 => Campaign) public campaigns;//declares a public state variable named campaign that is a mapping 

    //trying something here 
    modifier canWithdraw(){
        require(msg.sender == owner, "only the owner can withdraw");
        
        require(amountCollected >= target || amountCollected >= threshold, "Minimun amount not reacched ");
        _;
    }

    uint256 public numOfCampaigns = 0; // this is set tto zero in oder to properly Id the campaigns 

    //below are the functionalities of the smart contract

    function createCampaign(
        address _owner, 
        string memory _title, 
        string memory _image,
        string memory _description,
        uint256 _threshold,
        uint256 _target,
        uint256 _deadline
        )public returns (uint256){
            Campaign storage campaign = campaigns[numOfCampaigns];

            require(campaign.deadline < block.timestamp, "Future dates only");// to make sure that only futer dates are 

            campaign.owner = _owner;
            campaign.title = _title;
            campaign.description= _description;
            campaign.image = _image;
            campaign.threshold = _threshold;
            campaign.target = _target;
            campaign.deadline = _deadline;
            campaign.amountCollected = 0;

            numOfCampaigns++;

            return numOfCampaigns -1;


        }//function that creaates a campaign

    function donateToCampaign(uint256 _id)public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,) = payable (campaign.owner).call{value: amount}("");

        if (sent){
            campaign.amountCollected = campaign.amountCollected + amount;
        }

    }//function that enables contributors to donate tothe campaign

    function getDonators(uint256 _id)view public returns (address[]memory, uint256[]memory){
        return (campaigns[_id].donators, campaigns[_id].donations);
    }// gets a list of donators

    function getCampaign()public view returns(Campaign[]memory) {
        Campaign[]memory allCampaigns = new Campaign[](numOfCampaigns);

        // creatimg a for loop that fills the variable 
        for(uint i = 0; i < numOfCampaigns; i++){
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }
        return allCampaigns;
    }//gets a list of campaigns 

    //trying somthing again

    function withDraw()public canWithdraw{
        payable (owner).transfer(address(this).balance);
    }
    function getBalance () public view returns (uint){
        return address(this).balance;
    }


}
