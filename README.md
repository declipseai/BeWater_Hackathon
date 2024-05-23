# Eclipse AI Contracts

Solidity smart contracts for Eclipse AI.

## Dependencies

- [Foundry](https://github.com/foundry-rs/foundry) - A blazing fast, portable and modular toolkit for Ethereum application development written in Rust.
- [npm](https://docs.npmjs.com/getting-started) - A package manager for JavaScript, included with Node.js.
- [Python](https://www.python.org/downloads/) - A programming language that lets you work quickly and integrate systems more effectively.
- [IPFS](https://docs.ipfs.tech/how-to/command-line-quick-start/) - A peer-to-peer hypermedia protocol designed to make the web faster, safer, and more open.

## Documentation

For further details, see the [docs](./doc/README.md).

## Setup

The system requires the following environment variables to be set:

| Variable                    | Description                                                                                     |
|-----------------------------|-------------------------------------------------------------------------------------------------|
| `ENVIRONMENT`               | The environment of the deployment (`localnet`, `devnet`, `testnet`, or `mainnet`).              |
| `RPC_URL`                   | The RPC URL for the local network.                                                              |
| `DEBUG`                     | Enable debug mode (true or false).                                                              |
| `DEPLOYER_PRIVATE_KEY`      | The private key of the deployer.                                                                |
| `MASTER_PRIVATE_KEY`        | The master private key.                                                                         |
| `SUB1_PRIVATE_KEY`          | The first subordinate private key.                                                              |
| `SUB2_PRIVATE_KEY`          | The second subordinate private key.                                                             |
| `USER_PRIVATE_KEY`          | The user private key.                                                                           |
| `TOKEN_NAME`                | The name of the token.                                                                          |
| `TOKEN_SYMBOL`              | The symbol of the token.                                                                        |
| `PLATFORM_CONTRACT_ADDRESS` | The address of the platform contract.                                                           |

See the included `.env.example` for an example.

To set up the project, follow these steps:

```sh
# Install npm modules
npm install

# Install foundry
npm run install:foundry
npm run update:foundry

# Install Python dependency
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Install IPFS
npm run ipfs:install:ubuntu

# Update environment variables
source .env
```

## Build & Test Smart Contracts

To build, run:

```sh
npm run build
```

To run the unit tests:

```sh
npm run test:unit
```

## Run Eclipse AI in Local Environment

Run local blockchain node:

```sh
npm run start:localnet
```

Run IPFS node:

```sh
npm run ipfs:start:local
```

Run nodes:

```sh
# Deploy contract
npm run bootstrap:testnet:broadcast

# Run each node in separate terminal sessions
source .env && python3 script/python/masterNodeLoop.py
source .env && SUB_PRIVATE_KEY=$SUB1_PRIVATE_KEY python3 script/python/subNodeLoop.py 
source .env && SUB_PRIVATE_KEY=$SUB2_PRIVATE_KEY python3 script/python/subNodeLoop.py 

# Upload your own model
source .env && python3 script/python/registerNewModel.py

# Or upload the sample model we provide
source .env && python3 script/python/utils/registerSampleModel.py

# Send request
source .env && python3 script/python/registerNewRequest.py
```

## Experimental Results

| Model       | ResNet50         | ResNet101        | ResNet152        |
|-------------|------------------|------------------|------------------|
| Original Model Accuracy (ImageNet Validation) | 76.15%           | 77.37%           | 78.31%           |
| Quantized Model Accuracy (ImageNet Validation) | 75.72%           | 76.83%           | 78.00%           |
| Ensemble Accuracy (Test Images) | 76.07%           | 77.24%           | 78.22%           |
| Original Model Size (MB) | 102.592878       | 178.834164       | 241.65688        |
| Quantized Model Size (MB) | 26.147308        | 45.67879         | 61.805418        |

## Model Information on IPFS

### ResNet50
- **Original Model CID:** QmdDLcQmpYJVSXUGARBHuX9pg8NjRsGRtQ6CG3reYJ5BxG
- **Quantized Model CID:** QmWkSunYiwYHncCTfLmGCgY74Q4iYPtgySpdpSQjA4PhmR

### ResNet101
- **Original Model CID:** QmTXjamz1JifitNcSntiYwVKaDqKxMtdBz2BMkpSEEyYGP
- **Quantized Model CID:** QmTbYg2HvQbwygGsNuYuwR4ZuvyXvvGLkg47TvcVgV5Qf1

### ResNet152
- **Original Model CID:** QmQJ5TtJzWU8pfGEWcNPe9KTgvUyGjoJFnHRgZGQFCCrf4
- **Quantized Model CID:** QmfGfrucitqafzs534A1HVUggdaSpM8Kgu9tkfhVvdE1uq