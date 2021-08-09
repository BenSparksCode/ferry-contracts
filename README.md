# ⛵ Ferry Contracts ⛵

Smart contracts for Ferry.

## Latest Mumbai Contracts

```
┌─────────┬──────────────────┬──────────────────────────────────────────────┐
│ (index) │       name       │                   address                    │
├─────────┼──────────────────┼──────────────────────────────────────────────┤
│    0    │     'Ferry'      │ '0xbB8C9E6c7D632a367557994ae08f558E6A8945cD' │
│    1    │ 'FerryNFTMinter' │ '0x8f009607D221C037786833270ab056c3E1769e34' │
└─────────┴──────────────────┴──────────────────────────────────────────────┘
```

## To Do List

- [x] Deploy to Mumbai to test VRF
- [ ] Add Superfluid stream for staking rewards portion of gov token, triggered on exit if needed
- [ ] Note if textile bridge is a frontend thing only - tell Ryan and plan admin dashboard
- [ ] Zora callback data for owner -> NFT must be stored in contract
- [ ] Work out NFT generation and storage with Zora
- [ ] Test all functions work on mainnet fork
- [ ] Look into paying with MATIC and DAI

## Contracts

- [x] SHIP Token
- [x] SHIP Staking
- [ ] Ferry Core
- [ ] Ferry NFT Minter

## Tests

- [ ] SHIP Token
- [ ] SHIP Staking Rewards via Superfluid
- [ ] Ferry Core
- [ ] Ferry Aave Integration
- [ ] Ferry NFT Minter
- [ ] Ferry Chainlink Integration
- [ ] Ferry Zora Integration
- [ ] Filecoin-Polygon Bridge

## Tech Integrated

- [x] IPFS
- [x] Filecoin
- [x] Polygon
- [x] Aave
- [x] Chainlink
- [ ] Superfluid
- [ ] Zora
- [ ] Textile

## Resources

Streaming Rewards:

- [Superfluid Docs](https://docs.superfluid.finance/superfluid/protocol-tutorials/super-tokens)
- [Superfluid Networks](https://docs.superfluid.finance/superfluid/networks/networks)
- [Superfluid Soda Example](https://remix.ethereum.org/#version=soljson-v0.7.6+commit.7338295f.js&optimize=false&runs=200&gist=4669f393d5b9cc199c88ab6e9c68686f&evmVersion=null)
- [SuperTokenFactory Contract](https://github.com/superfluid-finance/protocol-monorepo/blob/dev/packages/ethereum-contracts/contracts/superfluid/SuperTokenFactory.sol)

Unique NFT Minting:

- [Uniswap V3 SVG NFTs](https://github.com/Uniswap/uniswap-v3-periphery/blob/main/contracts/libraries/NFTSVG.sol)
- [Chainlink Random Numbers](https://docs.chain.link/docs/get-a-random-number/)
- [Chainlink Starter Kit](https://github.com/smartcontractkit/hardhat-starter-kit)
- [VRF Best Practices](https://docs.chain.link/docs/chainlink-vrf-best-practices/)
- [Zora Minting NFTs](https://docs.zora.co/zoraos/dev/zdk/zora-protocol#mint)

Cross-chain Filecoin Payments

- [Textile Polygon-Filecoin Bridge](https://github.com/textileio/storage-js#ethpolygon)

Decentralized User Auth and Login:

- [Login with Ethereum](https://github.com/austintgriffith/scaffold-eth/tree/serverless-auth)
- [Magic Login](https://magic.link/)

## Faucets

- [Mumbai Testnet MATIC](https://faucet.matic.network/)
- [Mumbai Testnet LINK](https://linkfaucet.protofire.io/mumbai)
