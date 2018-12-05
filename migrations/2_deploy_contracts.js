var Users = artifacts.require("./Users.sol");
var Commitments = artifacts.require("./Commitments.sol");

module.exports = function(deployer) {
  deployer.deploy(Users);
  deployer.deploy(Commitments);
};
