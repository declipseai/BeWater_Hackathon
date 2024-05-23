import { keccak256 } from "@ethersproject/keccak256";
import { toUtf8Bytes } from "@ethersproject/strings";

/**
 * Prints the bytes32 string of all the roles.
 */

const roles: string[] = [
    "ADMIN_ROLE",
    "MASTER_NODE_ROLE",
    "SUB_NODE_ROLE",
];
roles.forEach((role: string) => {
    console.log(`${role}: ${keccak256(toUtf8Bytes(role))}`);
});
