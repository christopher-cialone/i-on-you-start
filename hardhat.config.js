require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");

module.exports = {
  solidity: "0.8.0",
  networks: {
    hardhat: {},
    avalanche: {
      url: `https://api.avax.network/ext/bc/C/rpc`,
      accounts: [process.env.PRIVATE_KEY],
      gas: 8000000,
      gasPrice: 225000000000,
    },
  },
};

