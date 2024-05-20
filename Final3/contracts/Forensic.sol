// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./UserControl.sol";

contract Forensic {
    UserControl public access;

    constructor(address _userControlAddress) {
        access = UserControl(_userControlAddress);
    }

    modifier onlyForensic() {
        require(access.hasRole(access.FORENSIC(), msg.sender), "Caller is not a forensic user");
        _;
    }

    struct Evidence {
        uint evidenceID;
        uint crimeID;
        string crimeDescription;
        string evidenceType;
        string location;
        string time;
        string officerName;
    }

    mapping(uint => Evidence[]) public evidencesByCrimeId;

    function addEvidence(uint crimeID, uint evidenceID, string memory crimeDescription, string memory evidenceType, string memory location, string memory time, string memory officerName) public onlyForensic() {
        evidencesByCrimeId[crimeID].push(Evidence(evidenceID, crimeID, crimeDescription, evidenceType, location, time, officerName));
    }

    function getEvidenceByCrimeId(uint _crimeID) public view returns (uint[] memory, string[] memory, string[] memory, string[] memory, string[] memory, string[] memory) {
        Evidence[] storage evidences = evidencesByCrimeId[_crimeID];
        uint length = evidences.length;
        uint[] memory evidenceIDs = new uint[](length);
        string[] memory crimeDescriptions = new string[](length);
        string[] memory evidenceTypes = new string[](length);
        string[] memory locations = new string[](length);
        string[] memory times = new string[](length);
        string[] memory officerNames = new string[](length);
        
        for (uint i = 0; i < length; i++) {
            Evidence memory evidence = evidences[i];
            evidenceIDs[i] = evidence.evidenceID;
            crimeDescriptions[i] = evidence.crimeDescription;
            evidenceTypes[i] = evidence.evidenceType;
            locations[i] = evidence.location;
            times[i] = evidence.time;
            officerNames[i] = evidence.officerName;
        }
        
        return (evidenceIDs, crimeDescriptions, evidenceTypes, locations, times, officerNames);
    }
}