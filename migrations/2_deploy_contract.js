const DrugVerify = artifacts.require("DrugVerify");

module.exports = function(deployer) {
    deployer.deploy(DrugVerify);
};