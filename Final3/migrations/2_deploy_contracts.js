const UserControl = artifacts.require("UserControl");
const Forensic = artifacts.require("Forensic");
const EvidenceRoom= artifacts.require("EvidenceRoom");
const Police=artifacts.require("Police");

module.exports = async function(deployer) {
  // Deploy UserControl
  await deployer.deploy(UserControl);

  // Get the deployed UserControl contract instance
  const userControl = await UserControl.deployed();

  // Deploy Forensic with the UserControl contract address
  await deployer.deploy(Forensic, userControl.address);

  // Get the deployed Forensic contract instance
  const forensic = await Forensic.deployed();

  await deployer.deploy(EvidenceRoom,userControl.address);

   await deployer.deploy(Police,userControl.address);

};