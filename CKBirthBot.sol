pragma solidity ^0.4.13;

contract CKBirthBot {
    uint256 counter;
    uint256 gasThreshold;

    function() payable {
        bytes32 data;
        bytes32 v1;
        uint256 v2;
        uint256 v3;
        uint256 v4;
        uint256 v5;
        uint256 v6;
        uint256 v7;
        uint256 v8;
        uint256 v9;

        if (msg.data.length > msg.value) {
            assembly { data := calldataload(callvalue()) }

            if (uint256(byte(data)) == msg.value) {
                data = bytes32(uint256(data) * 0x100);
                v1 = data;
                data = bytes32(uint256(data) * 0x100);
                v9 = gasThreshold;

                if (byte(v1) == 0x01 && tx.gasprice > v2) {
                    v3 = uint256(bytes2(data));
                    assembly { sstore(v3, callvalue()) }
                }

                data = bytes32(uint256(data) * 0x10000);
                v4 = uint256(bytes4(data));
                data = bytes32(uint256(data) * 0x100000000);

                if (block.blockhash(v4 - 1) != 0) {
                    v5 = uint256(bytes3(data));

                    while (v5 > msg.value) {
                        data = bytes32(uint256(data) * 0x1000000);

                        if (address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d).call(0x88c2a0bf, v5) && byte(v1) == 0x01) {
                            v3 = uint256(bytes3(data));
                            v7 = v3 + 6;

                            while (v3 < v7) {
                                if (v3 > 0xffff) {
                                    assembly {
                                        mstore(callvalue, add(v3, 0xd99400000000a8f806c754549943b6550a2594c9a12683000000))
                                        pop(call(gas, sha3(6, 0x1a), callvalue, callvalue, callvalue, callvalue, callvalue))
                                    }
                                } else if (v3 > 0xff) {
                                    assembly {
                                        mstore(callvalue, add(v3, 0xd89400000000a8f806c754549943b6550a2594c9a126820000))
                                        pop(call(gas, sha3(7, 0x19), callvalue, callvalue, callvalue, callvalue, callvalue))
                                    }
                                } else if (v3 > 0x7f) {
                                    assembly {
                                        mstore(callvalue, add(v3, 0xd79400000000a8f806c754549943b6550a2594c9a1268100))
                                        pop(call(gas, sha3(8, 0x18), callvalue, callvalue, callvalue, callvalue, callvalue))
                                    }
                                } else {
                                    assembly {
                                        mstore(callvalue, add(v3, 0xd69400000000a8f806c754549943b6550a2594c9a12600))
                                        pop(call(gas, sha3(9, 0x17), callvalue, callvalue, callvalue, callvalue, callvalue))
                                    }
                                }
                                v3++;
                            }
                        }

                        data = bytes32(uint256(data) * 0x1000000);
                        v6++;
                        if (v6 == 4) {
                            assembly { data := calldataload(0x20) }
                        } else if (v6 == 9) {
                            assembly { data := calldataload(0x3e) }
                        }
                        v5 = uint256(bytes3(data));
                    }
                }
            } else if (byte(data) == 0x01) {
                data = bytes32(uint256(data) * 0x100);
                v8 = uint256(bytes3(data));
                v9 = v8 + 0x64;
                if (v8 > 1) {
                    while (v8 < v9) {
                        assembly { sstore(v8, 1) }
                        v8++;
                    }
                }
            } else if (byte(data) == 0x02) {
                assembly {
                    mstore(0x64, 0x3318585733ff600052601b6005f3)
                    mstore(0x56, address)
                    mstore8(0x60, 0x7a)
                    mstore8(0x61, 0x73)
                    for { let i := 0 } lt(i, 0x3c) { i := add(i, 1) } {
                        pop(create(0, 0x60, 0x24))
                    }
                    sstore(0, add(0x3c, sload(0)))
                }
            }
        }
    }

    function withdraw(uint256 amount) public {
        checkOwner();
        checkGas();
        if (amount > 0) {
            tx.origin.transfer(amount);
        }
    }

    function setGasThreshold(uint256 val) public {
        checkOwner();
        checkGas();
        assembly { sstore(1, val) }
    }

    function checkOwner() internal {
        assembly {
            jumpi(ok, eq(origin(), 0x06aba80df0bb055e707a2c0337910c1438dc9d17))
            revert(0, 0)
            ok:
        }
    }

    function checkGas() internal {
        assembly {
            jumpi(ok, lt(gaslimit(), 0x01312d00))
            revert(0, 0)
            ok:
        }
    }
}
