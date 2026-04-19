#!/usr/bin/env node
/**
 * CKBirthBot Bytecode Verification
 *
 * Compiles CKBirthBot.sol with solc v0.4.17+commit.bdeb9e52 (no optimizer)
 * and compares against on-chain deployed bytecode.
 *
 * Usage: npm install && node verify.js
 */

const solc = require("solc");
const fs = require("fs");
const https = require("https");

const CONTRACT_ADDRESS = "0x00000000a8f806c754549943b6550a2594c9a126";
const SOURCE_FILE = "CKBirthBot.sol";
const EXPECTED_COMPILER = "v0.4.17+commit.bdeb9e52";

function compile() {
  const source = fs.readFileSync(SOURCE_FILE, "utf8");
  const output = solc.compile(source, 0);

  if (output.errors) {
    const errors = output.errors.filter((e) => !e.includes("Warning"));
    if (errors.length > 0) {
      console.error("Compilation errors:", errors);
      process.exit(1);
    }
  }

  const contract = output.contracts[":CKBirthBot"];
  if (!contract) {
    console.error("Contract not found in compilation output");
    process.exit(1);
  }

  return {
    bytecode: contract.bytecode,
    abi: JSON.parse(contract.interface),
    runtimeBytecode: contract.runtimeBytecode,
  };
}

function fetchOnChainBytecode() {
  return new Promise((resolve, reject) => {
    const url = `https://api.etherscan.io/api?module=proxy&action=eth_getCode&address=${CONTRACT_ADDRESS}&tag=latest`;
    https
      .get(url, (res) => {
        let data = "";
        res.on("data", (chunk) => (data += chunk));
        res.on("end", () => {
          try {
            const json = JSON.parse(data);
            resolve(json.result.slice(2)); // remove 0x prefix
          } catch (e) {
            reject(e);
          }
        });
      })
      .on("error", reject);
  });
}

async function main() {
  console.log("CKBirthBot Bytecode Verification");
  console.log("=================================\n");
  console.log(`Contract:  ${CONTRACT_ADDRESS}`);
  console.log(`Compiler:  solc ${EXPECTED_COMPILER}`);
  console.log(`Optimizer: disabled\n`);

  // Verify compiler version
  const version = solc.version();
  console.log(`Installed solc version: ${version}`);
  if (!version.includes("0.4.17")) {
    console.error(`ERROR: Expected solc 0.4.17, got ${version}`);
    process.exit(1);
  }

  // Compile
  console.log("\nCompiling CKBirthBot.sol...");
  const { bytecode, runtimeBytecode, abi } = compile();
  console.log(`Compiled runtime bytecode: ${runtimeBytecode.length / 2} bytes`);
  console.log(`Compiled creation bytecode: ${bytecode.length / 2} bytes`);

  // Fetch on-chain bytecode
  console.log("\nFetching on-chain bytecode...");
  try {
    const onChain = await fetchOnChainBytecode();
    console.log(`On-chain bytecode: ${onChain.length / 2} bytes`);

    // Compare runtime bytecode
    if (runtimeBytecode.toLowerCase() === onChain.toLowerCase()) {
      console.log("\nRESULT: EXACT RUNTIME BYTECODE MATCH");
    } else {
      console.log("\nRESULT: MISMATCH");
      console.log(
        `Compiled: ${runtimeBytecode.substring(0, 64)}...`
      );
      console.log(`On-chain: ${onChain.substring(0, 64)}...`);
    }
  } catch (e) {
    console.log(
      `Could not fetch on-chain bytecode (${e.message}). Offline verification:`
    );
    console.log(`Runtime bytecode hash can be compared manually.`);
  }

  // Write outputs
  fs.writeFileSync("abi.json", JSON.stringify(abi, null, 2));
  fs.writeFileSync("bytecode.txt", bytecode);
  fs.writeFileSync("runtime-bytecode.txt", runtimeBytecode);
  console.log("\nWrote: abi.json, bytecode.txt, runtime-bytecode.txt");
}

main().catch(console.error);
