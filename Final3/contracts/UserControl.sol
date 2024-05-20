// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/access/AccessControl.sol";

contract UserControl is AccessControl {
    struct UserData {
        string name;
        address walletAddress;
        string password;
        string role;
    }

    mapping(address => UserData) public users;

    address public adminAddress;

    // Make roles
    bytes32 public constant ADMIN = keccak256("Admin");
    bytes32 public constant FORENSIC = keccak256("Forensic");
    bytes32 public constant ROOM = keccak256("Room");
    bytes32 public constant POLICE = keccak256("Police");

    constructor() {
        adminAddress = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == adminAddress, "Only admin can call this function");
        _;
    }

    function registerUser(string memory _name, address _walletAddress, string memory _password, string memory _role) public onlyAdmin {
        require(users[_walletAddress].walletAddress == address(0), "User already registered");
    
        users[_walletAddress] = UserData({
            name: _name,
            walletAddress: _walletAddress,
            password: _password,
            role: _role
        });

        if (keccak256(abi.encodePacked(_role)) == ADMIN) {
            _grantRole(ADMIN, _walletAddress);
        } else if (keccak256(abi.encodePacked(_role)) == FORENSIC) {
            _grantRole(FORENSIC, _walletAddress);
        } else if (keccak256(abi.encodePacked(_role)) == ROOM) {
            _grantRole(ROOM, _walletAddress);
        } else if (keccak256(abi.encodePacked(_role)) == POLICE) {
            _grantRole(POLICE, _walletAddress);
        } else {
            revert("Invalid role");
        }
    }

    function getUserDetails(address _walletAddress) public view returns (string memory, string memory) {
        require(users[_walletAddress].walletAddress != address(0), "User not found");
    
        UserData memory user = users[_walletAddress];
        return (user.name, user.role);
    }

    function login(address _walletAddress, string memory _password) public view returns (string memory) {
    require(users[_walletAddress].walletAddress != address(0), "User not found");
    
    UserData memory user = users[_walletAddress];
    if (keccak256(abi.encodePacked(user.password)) == keccak256(abi.encodePacked(_password))) {
        return "Login successful";
    } else {
        return "Incorrect password or Address";
    }
}

}



   

