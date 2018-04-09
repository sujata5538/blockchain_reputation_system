pragma solidity ^0.4.18;

import "./EDSToken.sol";

contract Endorsement is EDSToken {
	address owner;
    
    struct Participant { 
        address identifier;
        string name;
        // uint nEG;
        // uint nER;
        // uint RE;
        // uint usedPower;
    }
    
    struct Endorser {
        address sender;
        uint nEG;
        uint usedPower;
        address[] givenTo;
        mapping(address => bool) hasGivenTo;
    }
    
    struct Endorsee { 
        address receiver;
        uint nER;
        uint RE;
        address[] receivedFrom;
        mapping(address => bool) hasReceivedFrom;
    }
    
    struct Profile { 
        address identifier;
        uint nER;
        uint nEG;
        address[] receivedFrom;
        uint RE;
    }
    
    mapping(address => uint) nEG;
    mapping(address => uint) nER;
    mapping(address => uint) RE;
    mapping(address => uint) usedPower;
    mapping(address => uint) impact;
    mapping(address => uint) totalImpact;
    
    mapping(address => bool) joined;
    
    mapping(address => address[]) public outGoingConnections;
    mapping(address => address[]) public inComingConnections;
    
    Participant [] public participants;
    //Endorser [] public endorsers;
    
    mapping(address => Endorser[]) endorsers; 
    
    Endorsee [] public endorsees;
    Profile [] public profiles;
    
	// modifiers
	modifier onlyOwner() { 
		require(msg.sender == owner );
		_;
	}


	//constructor
	function Endorsement() public { 
		//EDSToken( );
		owner = msg.sender;
	}

	//deactivate the contract
	function kill() public onlyOwner { 
		selfdestruct(owner);
	}
	
	function joinNetwork(string _userName) public{
	    require(!joined[msg.sender]);
	    joined[msg.sender] = true;
	    Participant memory newParticipant = Participant({
	        identifier: msg.sender,
	        name: _userName
	    });
	    participants.push(newParticipant);
	}
	
	function endorse(uint _index) public {
	    address receiver = participants[_index].identifier;
	    require(receiver != 0x0);
	    require(receiver != msg.sender);
	    nEG[msg.sender]++;
	    nER[receiver]++;
	    usedPower[msg.sender] = Division(1,nEG[msg.sender],9);
	    Endorser memory newEndorser = Endorser({
	        sender: msg.sender,
	        nEG: nEG[msg.sender],
	        usedPower: Division(1,nEG[msg.sender],9),
	        givenTo: new address[](0)
	        
	    });
	    //with address to Endorser[] mapping
	    endorsers[msg.sender].push(newEndorser);
	    
	    //with array Endorser [] public endorsers
	    //endorsers.push(newEndorser);
	   // endorsers[endorsers.length-1].givenTo.push(receiver);
	   // endorsers[endorsers.length-1].hasGivenTo[receiver] = true;
	    
	    outGoingConnections[msg.sender].push(receiver);
	    //check outGoingConnections[address,index_of_array]
	    
	    //uint RE = RE[receiver];
	    
	    
	    //udpate participants for endorser identifier
	    
	   // Participant memory newParticipant = Participant({
	   //     identifier: participants[_index].identifier,
	   //     name: participants[_index].name,
	   //     nEG: nEG[participants[_index].identifier],
	   //     nER: nER[participants[_index].identifier],
	   //     usedPower: usedPower[participants[_index].identifier],
	   // });
	    
	   // Endorsee memory newEndorsee = Endorsee({
	   //    receiver: receiver,
	   //    nER: nER[receiver],
	   //    //RE: RE[receiver] + endorsers[endorsers.length-1].usedPower,
	   //    receivedFrom: new address[](0)
	   // });
	   // endorsees.push(newEndorsee);
	   // endorsees[endorsees.length-1].receivedFrom.push(msg.sender);
	   // endorsees[endorsees.length-1].hasReceivedFrom[msg.sender] = true;
	    
	   // inComingConnections[receiver].push(msg.sender);
	    
	    
	    
	    
	    //updateParticipants code - new function
	   // Participant memory newParticipant = Participant({
	        
	        
	   // });
	    
	    //updateParticipants(_index);
	}
	

	function computeImpact(uint _index) public view returns (uint){
	    //compute score for users in participants array, give index of array
	    address user = participants[_index].identifier;
	    require(joined[user]);
	    uint minVal = min((nEG[user]), (nER[user]));
	    uint maxVal = max((nEG[user]),(nER[user]));
	    uint ratio = Division(minVal,maxVal, 9);
	    
	    //summation of usedpower of all endorsers for the given user,
	    //no other way but to iterate the array which can be of max size 300
	    uint len = inComingConnections[user].length;
	    //address incomingConns = inComingConnections[user](0);
	    uint points = usedPower[user];
	    uint totalReceivedPower;
	    for (uint i=0; i< len; i++) {
	        //totalReceivedPower = usedPower(inComingConnections[user](i));
	        //inComingConnections[user,i]
	    }
	    
	    return points;
	    
	    
	}




	
	//some helper functions for calculations
	function Division( uint _numerator, uint _denominator, uint _precision) internal pure returns (uint _quotient) {
		uint numerator = _numerator * 10 ** (_precision + 1);
		uint quotient = ((numerator / _denominator) + 5  ) / 10;

		return (quotient);		
	}

	function max (uint x, uint y ) internal pure returns (uint) {
		if (x < y) {
			return y;
		} else  {  
			return x;
		}
	}

	function min (uint x, uint y ) internal pure returns (uint) { 
		if (x < y) { 
			return x;
		} else {
			return y;
		}
	}

	//compute trust score
	//supports decimal upto 9 place
	//can convert to decimal by dividing all values with 1e9 and get the exact score on 
	//client side
//	function computeTrust( address _user) public view returns (uint) { 
//		address user = _user;
//		require (nEG[user] >= 1 );
//		uint temp1 = (min(nEG[user], nER[user]));
//		uint temp2 = (max(nEG[user], nER[user]));
//		uint ratio = Division( temp1, temp2, 9 );
//		
//		uint edsImpact = ratio * usedPower( user ) *  RE(user)
//
//		return ratio;
		//uint  
		
		//return usedPower;
		//ratio = Division( ( nEG[  _user] ), ( nER[ _user ] ), 9 );
		//usedPower = Division(1, (nEG[_user ]), 9 );
		//receivedEDS = ReceivedEDS( _user );
		//totalImpact = ratio  up  RE;  

//	}

}
























