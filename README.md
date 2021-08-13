# ⛵ Ferry Contracts ⛵

Smart contracts for Ferry.

## Latest Mumbai Contracts

```
┌─────────┬──────────────────┬──────────────────────────────────────────────┐
│ (index) │       name       │                   address                    │
├─────────┼──────────────────┼──────────────────────────────────────────────┤
│    0    │   'ShipToken'    │ '0x1EFcb17a4F5B628E82Fe8048D3B41ED0fdF375E3' │
│    1    │   'ShipHarbor'   │ '0x74972961bbC7739403cA9ceec7Bab1290E1b555d' │
│    2    │     'Ferry'      │ '0x0D3e25E6B337bdf1F6293609F59133C57522c0A8' │
│    3    │ 'FerryNFTMinter' │ '0x26205b8667286bB528f9D81af40A9415Ec30a3fa' │
└─────────┴──────────────────┴──────────────────────────────────────────────┘
```

## To Do List

- [x] Deploy to Mumbai to test VRF
- [ ] Note if textile bridge is a frontend thing only - tell Ryan and plan admin dashboard
- [ ] Zora callback data for owner -> NFT must be stored in contract
- [x] Work out NFT generation and storage with Zora
- [ ] Test all functions work on mainnet fork
- [ ] Look into paying with MATIC and DAI

## Contracts

- [x] SHIP Token
- [x] SHIP Staking
- [ ] Ferry Core
- [ ] Ferry NFT Minter

## Tests

- [ ] SHIP Token
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
- [ ] Zora
- [ ] Textile

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
