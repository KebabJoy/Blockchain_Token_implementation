const YoungInvestor = artifacts.require("YoungInvestor");
const DeadInsideToken = artifacts.require("DeadInsideToken");

module.exports = function(deployer) {
  deployer.deploy(DeadInsideToken)
    .then((Token) => {
      return deployer.deploy(YoungInvestor, Token.address);
    });
};
