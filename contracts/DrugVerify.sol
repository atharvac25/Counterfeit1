// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DrugVerify {
    struct drug {
        bool drug_id;
        string drug_name;
        string drug_info_json;
        string drug_status;
        // string drug_current_location;
        bool isSold;
        address manfacturer;
        address distributer;
        address verifier;
    }
    mapping(address => address[]) manufacturer_drugs;  // List of manufacturer's drug
    mapping(address => mapping(uint => address[])) distributer_drugs;  // List of distributer's drug
    mapping(address => mapping(uint => address[])) verifier_drugs;  // List of verifier's drug
    mapping(uint => mapping(string => string)) timestamp;
    mapping(address => drug) public drugs;  // List of drugs deployed into blockchain
    
    uint public no_dis_drugs_index = 0;
    uint public no_verifier_drugs_index = 0;

    // New Drug addition into blockchain
    function addDrug(string memory name, string memory info_json) public {
        address uniqueId = address(bytes20(sha256(abi.encodePacked(msg.sender,block.timestamp))));
        
        //  , uint8 v, bytes32 r, bytes32 s
        // bytes32 hashedMessage = keccak256((abi.encodePacked(name, info_json)));
        //  // Verify the signature using ecrecover
        // address signer = ecrecover(hashedMessage, v, r, s);
        // require(signer == msg.sender, "Invalid signature");
        
        
        
        // drugs.push(drug({
        //     drug_id: drugs.length,
        //     drug_name: name,
        //     drug_info_json: info_json,
        //     drug_status: "manufactured",
        //     isSold: false,
        //     manfacturer: msg.sender,
        //     distributer: 0x0000000000000000000000000000000000000000,
        //     verifier: 0x0000000000000000000000000000000000000000
        // }));
        drugs[uniqueId].drug_id = true;
        drugs[uniqueId].drug_name = name;
        drugs[uniqueId].drug_info_json = info_json;
        drugs[uniqueId].drug_status = "Manufactured";
        drugs[uniqueId].isSold = false;
        drugs[uniqueId].manfacturer = msg.sender;
        drugs[uniqueId].distributer = 0x0000000000000000000000000000000000000000;
        drugs[uniqueId].verifier = 0x0000000000000000000000000000000000000000;
        manufacturer_drugs[msg.sender].push(uniqueId);
    }

    // Returns drug list of manufacturer(msg.sender)
    function ManufacturerDrugsList() public view returns (address[] memory) {
        return manufacturer_drugs[msg.sender];
    }

    // Assign drug ids to a particular distributer
    function drugDispatchToDistributer(address[] memory drug_ids, address _distributer) public {
        for(uint i=0; i<drug_ids.length; i++)
        {
            drugs[drug_ids[i]].drug_status = "Dispatched to distributer";
            drugs[drug_ids[i]].distributer = _distributer;
            // distributer_drugs[_distributer].push(drug_ids[i]);
        }
        distributer_drugs[_distributer][no_dis_drugs_index] = drug_ids;
        no_dis_drugs_index+=1;
    }
    function getDistributerDrugsAddressesList(address _distributer, uint index) public view returns(address[] memory) {
        return distributer_drugs[_distributer][index];
    }

    // function getDistributerDrugsList(address _distributer, uint index) public view returns(drug[] memory) {
    //     drug[] memory tempDrugs;
    //     uint inc = 0;
    //     for(uint i=0; i<distributer_drugs[_distributer][index].length; i++)
    //     {
    //         tempDrugs[inc] = drugs[distributer_drugs[_distributer][index][i]];
    //         inc++;
    //     }
    //     return tempDrugs;
    // }


    function drugDispatchToVerifier(address[] memory drug_ids, address _verifier) public {
        for(uint i=0; i<drug_ids.length; i++)
        {
            drugs[drug_ids[i]].drug_status = "Dispatched to verifer";
            drugs[drug_ids[i]].distributer = _verifier;
            // verifier_drugs[_verifier].push(drug_ids[i]);
        }
        verifier_drugs[_verifier][no_verifier_drugs_index] = drug_ids;
        no_verifier_drugs_index+=1;
    }
    function getVerifierDrugAddressesList(address _verifier, uint index) public view returns(address[] memory) {
        return verifier_drugs[_verifier][index];
    }
}