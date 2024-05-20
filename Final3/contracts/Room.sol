// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./UserControl.sol";
import "./BokkyPooBahsDateTimeLibrary.sol";
contract EvidenceRoom {
    address private owner;
    uint public result;
    uint public result1;
    UserControl public accessRoom;


   constructor(address _userControlAddress) {
        accessRoom = UserControl(_userControlAddress);
    }

       modifier onlyRoom() {
        require(accessRoom.hasRole(accessRoom.ROOM(), msg.sender), "Caller is not a Room Staff  user");
        _;
    }
    struct evidenceLog {
        uint caseID;
        uint evidenceID;
        string crimeDescription;
        string evidenceType;
        string crimeTime;
        string officer;
        string department;
        address evidenceRoomOfficer;
        string purpose;
        string place;
        string entryTime;
        string exitTime;
        uint creationTime;
    }

    struct inventor {
        uint roomNumber;
        uint crimeId;
        uint evidenceCount;
    }
    
    struct exitLog {
        string name;
        address wallet;
        string time;
        string crimeID;
    }

    event EvidenceLogged(uint caseID, uint indexed evidenceId, string crimeDescription, string evidenceType, string crimeTime, string officer, string department, address evidenceRoomOfficer, string purpose, string place, string entryTime, string exitTime, uint creationTime);
    
    mapping (uint => evidenceLog) internal evidenceLogs;
    mapping (uint => inventor) internal inventories;
    mapping (uint => exitLog) internal exitLogs;
    uint public indexx = 0;
    uint public inventoIndex = 0;
    uint public exitIndex = 0;

    function addEntryLog(uint _caseID, uint _evidenceID, string memory _crimeDescription, string memory _evidenceType, string memory _crimeTime, string memory _officer, string memory _department, string memory _purpose, string memory _place, string memory _entryTime, string memory _exitTime) public onlyRoom() {
    evidenceLogs[indexx] = evidenceLog(_caseID, _evidenceID,_crimeDescription, _evidenceType, _crimeTime, _officer, _department, msg.sender, _purpose,  _place, _entryTime, _exitTime, block.timestamp);
    indexx++;
    emit EvidenceLogged(_caseID, _evidenceID, _crimeDescription, _evidenceType, _crimeTime, _officer, _department, msg.sender, _purpose, _place, _entryTime, _exitTime, block.timestamp);

   
}

    function logsDate(uint year1, uint month1, uint day1, uint year, uint month, uint day) public {
        result = BokkyPooBahsDateTimeLibrary.timestampFromDate(year1, month1, day1);
        result1 = BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, day); 
    }

    function getLogsByDate() public view returns (evidenceLog[] memory) {
        return getLogsByDate(result, result1);
    }
    
    function getLogsByDate(uint _startTimestamp, uint _endTimestamp) internal view returns (evidenceLog[] memory) {
        // Array to store logs within the specified date range
        evidenceLog[] memory logsInRange = new evidenceLog[](indexx);
        uint logsCount = 0;

        // Iterate through all logs
        for (uint i = 0; i < indexx; i++) {
            // Retrieve the log
            evidenceLog memory log = evidenceLogs[i];

            // Check if the log's timestamp is within the specified date range
            if (log.creationTime >= _startTimestamp && log.creationTime <= _endTimestamp) {
                // Add the log to the array of logs within the range
                logsInRange[logsCount] = log;
                logsCount++;
            }
        }

        return logsInRange;
    }

    function logsByCrime(uint _crimeID) public view returns (evidenceLog[] memory) {
    uint logsCount = 0;

    // Count the logs that match the specified crime ID
    for (uint i = 0; i < indexx; i++) {
        if (evidenceLogs[i].caseID == _crimeID) {
            logsCount++;
        }
    }

    // Initialize the array with the exact size needed
    evidenceLog[] memory logsForCrime = new evidenceLog[](logsCount);

    // Iterate through all logs and populate the array with logs matching the specified crime ID
    uint logsAdded = 0;
    for (uint i = 0; i < indexx; i++) {
        if (evidenceLogs[i].caseID == _crimeID) {
            logsForCrime[logsAdded] = evidenceLogs[i];
            logsAdded++;
        }
    }

    return logsForCrime;
}

    function Inventory(uint _roomNumber, uint _crimeID, uint _evidenceCount) public {
        inventories[inventoIndex] = inventor(_roomNumber, _crimeID, _evidenceCount);
        inventoIndex++;
    }

    function deleteInventory(uint _crimeId) public {
    for (uint i = 0; i < inventoIndex; i++) {
        if (inventories[i].crimeId == _crimeId) {
            // Delete the inventory by swapping it with the last inventory in the array
            inventories[i] = inventories[inventoIndex - 1];
            inventoIndex--;
            break;
        }
    }
}

    function addExitLog(string memory _name, address _wallet, string memory _time, string memory _crimeID) public  {
        exitLogs[exitIndex] = exitLog(_name, _wallet, _time, _crimeID);
        exitIndex++;
    }

    function viewLogs() public view returns (evidenceLog[] memory) {
        evidenceLog[] memory allLogs = new evidenceLog[](indexx);

        for (uint i = 0; i < indexx; i++) {
            allLogs[i] = evidenceLogs[i];
        }

        return allLogs;
    }

    function viewExitLogs() public view returns (exitLog[] memory) {
    exitLog[] memory allExitLogs = new exitLog[](exitIndex);

    for (uint i = 0; i < exitIndex; i++) {
        allExitLogs[i] = exitLogs[i];
    }

    return allExitLogs;
}

function viewInventories() public view returns (inventor[] memory) {
    inventor[] memory allInventories = new inventor[](inventoIndex);

    for (uint i = 0; i < inventoIndex; i++) {
        allInventories[i] = inventories[i];
    }

    return allInventories;
}

}