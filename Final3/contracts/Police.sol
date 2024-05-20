// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13;
import'./UserControl.sol';

contract Police {
    UserControl public access;

    struct Log {
        uint evidenceID;
        uint crimeID;
        string action;
        string source;
        string destination;
        string datetime;
    }

    Log[] public logs;

    constructor( address _userControlAddress) {
        access = UserControl(_userControlAddress);
    }

    event LogAdded(uint evidenceID, uint crimeID, string action, string source, string destination, string datetime);

    modifier onlyPolice() {
        require(access.hasRole(access.POLICE(), msg.sender), "Caller is not a police user");
        _;
    }

    function policeLog(uint _evidenceID, uint _crimeID, string memory _action, string memory _source, string memory _destination, string memory _datetime) public onlyPolice {
        logs.push(Log(_evidenceID, _crimeID, _action, _source, _destination, _datetime));
        emit LogAdded(_evidenceID, _crimeID, _action, _source, _destination, _datetime);
    }

    function viewLogs() public view returns (Log[] memory) {
        return logs;
    }
}