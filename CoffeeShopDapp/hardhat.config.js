require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.27",
};

require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: "0.8.0", // Use your desired Solidity version

    sepolia: {
      url: `https://eth-sepolia.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`, // Alchemy Sepolia URL
      accounts: [`${process.env.WALLET_PRIVATE_KEY}`] // Your wallet private key (from .env)
    },
};
