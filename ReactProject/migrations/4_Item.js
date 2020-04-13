let Item = artifacts.require("./Item.sol");

module.exports = (deployer) => {
  deployer.deploy(Item);
};
