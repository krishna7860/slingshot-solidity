const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Voting Contract Test", () => {
  let voting = null;

  it("Owner should the contract initiater", async () => {
    const Voting = await ethers.getContractFactory("Voting");
    voting = await Voting.deploy();

    const accounts = await hre.ethers.getSigners();
    const admin = accounts[0].address;
    await voting.deployed();

    const contractAdmin = await voting.admin();
    expect(admin).to.equal(contractAdmin);
  });

  it("Able to add voters", async () => {
    const accounts = await hre.ethers.getSigners();
    const user1 = accounts[1].address;
    const user2 = accounts[2].address;
    const user3 = accounts[3].address;

    const voters = [user1, user2, user3];

    await voting.addVoters(voters);

    expect(await voting.voters(user1)).to.equal(true);
    expect(await voting.voters(user2)).to.equal(true);
    expect(await voting.voters(user3)).to.equal(true);
  });

  it("Able to create Ballot and send votes", async () => {
    await voting.createBallot(
      "India Election",
      ["Narendra Modi", "Rahul Gandhi", "Arvind Kejriwal"],
      60
    );

    const accounts = await hre.ethers.getSigners();
    const voter1 = accounts[1].address;
    const [owner, addr1] = await ethers.getSigners();
    expect(await voting.votes(voter1, 0)).to.equal(false);
    await voting.connect(addr1).vote(0, 0);
    expect(await voting.votes(voter1, 0)).to.equal(true);
  });

  it("Able to create Ballot and send votes", async () => {
    await voting.createBallot(
      "India Election",
      ["Narendra Modi", "Rahul Gandhi", "Arvind Kejriwal"],
      5
    );

    const accounts = await hre.ethers.getSigners();
    const voter1 = accounts[1].address;
    const [owner, addr1] = await ethers.getSigners();
    await new Promise((res, rej) => {
      setTimeout(() => {
        res();
      }, 6000);
    });
    try {
      await voting.connect(addr1).vote(0, 0);
    } catch (error) {
      expect(error).to.equal("You already voted for this ballet");
    }
  });
});
