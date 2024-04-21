const PolarBearStash = require("./out/PolarBearStash.sol/PolarBearStash.json");

function returnContractAddress(network = "Berachain") {
  const addresses = {
    Berachain: "0xe60cE976cD710705fFaDD263EF6e87B403aEC8f1"
  };
  return addresses[network];
}

module.exports = {
  PolarBearStashABI: PolarBearStash.abi,
  PolarBearStashAddress: returnContractAddress(),
  returnContractAddress
};
