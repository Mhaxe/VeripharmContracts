async function main() {
  const Veripharm = await ethers.getContractFactory("Veripharm");
  const contract = await Veripharm.deploy();
  await contract.deployed();

  console.log("Contract deployed to:", contract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
