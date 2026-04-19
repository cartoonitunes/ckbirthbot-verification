# CKBirthBot Verification

Bytecode verification proof for the CryptoKitties birth bot at [`0x00000000a8f806c754549943b6550a2594c9a126`](https://ethereumhistory.com/contract/0x00000000a8f806c754549943b6550a2594c9a126).

## Contract Details

- **Address:** `0x00000000a8f806c754549943b6550a2594c9a126`
- **Deployer:** `0x6a05fc6615c4f2bc872901876744b81f2414f44f`
- **Deployment Block:** 6,720,524 (approximately Nov 28, 2018)
- **ETH Balance:** 138.24 ETH
- **Compiler:** solc v0.4.17+commit.bdeb9e52
- **Optimizer:** Disabled

## What It Does

CKBirthBot is a CryptoKitties birth bot that calls CK's `giveBirth()` function to earn midwife rewards. It also batch-creates self-destructing child contracts for gas refunds, similar to the GST2 pattern but with a custom, non-ERC20 implementation.

The contract's fallback function parses calldata to determine which operation to perform: calling `giveBirth()` on the CryptoKitties core contract (`0x06012c8cf97BEaD5deAe237070F9587f8E7A266d`), deploying gas token children via inline CREATE opcodes, or managing storage slots for gas refunds.

## Verification

Run the verification script to reproduce the exact on-chain bytecode:

```bash
npm install
node verify.js
```

The script compiles `CKBirthBot.sol` with solc v0.4.17 (no optimizer) and compares the output against the deployed bytecode.

## License

[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/)
