# ⛵ Ferry Contracts ⛵

Smart contracts for Ferry.

## Latest Mumbai Contracts

```
┌─────────┬──────────────────┬──────────────────────────────────────────────┐
│ (index) │       name       │                   address                    │
├─────────┼──────────────────┼──────────────────────────────────────────────┤
│    0    │   'ShipToken'    │ '0xDFa0D38387edad2176F6dE96ddE2833C9949606E' │
│    1    │   'ShipHarbor'   │ '0x8B910250892cc78c41FcF5889744Fb638Fead54d' │
│    2    │     'Ferry'      │ '0x1BEc7A448e663bB0c738F5384aAA5C0746Ca2f98' │
│    3    │ 'FerryNFTMinter' │ '0xB2eEa6CB978FE625755952ee03B9125345831641' │
└─────────┴──────────────────┴──────────────────────────────────────────────┘
```

## To Do List

- [x] Deploy to Mumbai to test VRF
- [x] Zora callback data for owner -> NFT must be stored in contract
- [x] Work out NFT generation and storage with Zora

## Contracts

- [x] SHIP Token
- [x] SHIP Staking
- [ ] Ferry Core
- [ ] Ferry NFT Minter

## Tech Integrated

- [x] IPFS
- [x] Filecoin
- [x] Polygon
- [x] Aave
- [x] Chainlink
- [x] Zora

## Resources

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
