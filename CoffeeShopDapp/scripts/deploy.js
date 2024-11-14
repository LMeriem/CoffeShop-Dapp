async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    const CoffeeShop = await ethers.getContractFactory("CoffeeShop");
    const coffeeShop = await CoffeeShop.deploy();
  
    console.log("CoffeeShop contract deployed to:", coffeeShop.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  