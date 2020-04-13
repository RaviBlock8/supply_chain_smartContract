let ItemManager = artifacts.require("./ItemManager.sol");

module.exports = (deployer) => {
  deployer.deploy(ItemManager);
};
