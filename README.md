# 🎭 MoodNft - Dynamic NFT Collection

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg)](https://getfoundry.sh/)
[![Tests](https://github.com/yourusername/foundry-ntfs/workflows/test/badge.svg)](https://github.com/yourusername/foundry-ntfs/actions)

A dynamic NFT collection built with Solidity and Foundry that allows owners to flip the mood of their NFTs between happy and sad states. Each mood change updates the token's metadata and visual representation in real-time.

## 📋 Table of Contents

- [Features](#-features)
- [Contracts](#-contracts)
- [Installation](#-installation)
- [Usage](#-usage)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Interacting with Contracts](#-interacting-with-contracts)
- [Project Structure](#-project-structure)
- [Technologies Used](#-technologies-used)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### MoodNft Contract
- **Dynamic NFT**: Switch between happy and sad cat representations
- **On-chain Metadata**: All metadata and images stored on-chain using Base64 encoding
- **Access Control**: Only token owners or approved addresses can flip moods
- **SVG Graphics**: Scalable vector graphics for crisp display at any size
- **ERC721 Compliant**: Full compatibility with OpenSea and other NFT platforms

### BasicNft Contract
- **Simple NFT**: Basic ERC721 implementation for comparison
- **IPFS Integration**: Metadata stored on IPFS
- **Mintable**: Anyone can mint new tokens

## 📜 Contracts

| Contract | Description | Address |
|----------|-------------|---------|
| **MoodNft** | Dynamic NFT with mood-flipping functionality | `TBD` |
| **BasicNft** | Simple ERC721 implementation | `TBD` |

## 🚀 Installation

### Prerequisites
- [Git](https://git-scm.com/)
- [Foundry](https://getfoundry.sh/)

### Setup

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/foundry-ntfs.git
cd foundry-ntfs
```

2. **Install dependencies**
```bash
make install
```

3. **Build the project**
```bash
make build
```

4. **Run tests**
```bash
make test
```

## 🔧 Usage

### Local Development

1. **Start Anvil (local blockchain)**
```bash
make anvil
```

2. **Deploy contracts locally**
```bash
make deploy-anvil
```

3. **Mint an NFT**
```bash
make mint-anvil
```

4. **Flip NFT mood**
```bash
make flip-mood-anvil
```

### Environment Variables

Create a `.env` file in the root directory:
```bash
# Network Configuration
RPC_URL=https://eth-sepolia.g.alchemy.com/v2/your-api-key
PRIVATE_KEY=your-private-key-here
ETHERSCAN_API_KEY=your-etherscan-api-key
```

## 🧪 Testing

The project includes comprehensive test suites:

```bash
# Run all tests
make test

# Run specific test
make test-match TEST_NAME=testFunctionName

# Run tests with gas report
make test-gas

# Run integration tests
forge test --match-contract MoodNftIntegerationTest
```

### Test Coverage
- ✅ Contract deployment and initialization
- ✅ NFT minting functionality
- ✅ Mood flipping mechanics
- ✅ Access control and permissions
- ✅ Token URI generation
- ✅ ERC721 standard compliance

## 🌐 Deployment

### Sepolia Testnet
```bash
# Deploy to Sepolia
make deploy

# Interact with deployed contract
make interact
```

### Mainnet
⚠️ **Warning**: Never deploy to mainnet without thorough testing

```bash
# Set mainnet RPC URL in .env
# Deploy to mainnet (use with caution)
forge script script/DeployMoodNft.s.sol:DeployMoodNft --broadcast --rpc-url $MAINNET_RPC_URL --private-key $PRIVATE_KEY
```

## 🤝 Interacting with Contracts

### Using Cast (Command Line)
```bash
# Mint a new NFT
cast send $CONTRACT_ADDRESS "mintNft()" --private-key $PRIVATE_KEY

# Flip mood of token ID 0
cast send $CONTRACT_ADDRESS "flipMood(uint256)" 0 --private-key $PRIVATE_KEY

# Check token owner
cast call $CONTRACT_ADDRESS "ownerOf(uint256)" 0

# Get token URI
cast call $CONTRACT_ADDRESS "tokenURI(uint256)" 0
```

### Using Scripts
The project includes interaction scripts for common operations:
- `MintBasicNft`: Mint basic NFT
- `MintMoodNft`: Mint mood NFT
- `FlipMoodNft`: Flip mood of existing NFT

## 📁 Project Structure

```
foundry-ntfs/
├── src/
│   ├── MoodNft.sol          # Dynamic NFT contract
│   └── BasicNft.sol         # Simple NFT contract
├── script/
│   ├── DeployMoodNft.s.sol  # Deployment script
│   ├── DeployBasicNft.s.sol # Basic NFT deployment
│   └── Interaction.s.sol    # Interaction scripts
├── test/
│   ├── unit/                # Unit tests
│   └── integration/         # Integration tests
├── img/                     # SVG assets
│   ├── HappyCat.svg
│   └── SadCat.svg
├── Makefile                 # Build and deployment commands
└── foundry.toml            # Foundry configuration
```

## 🛠 Technologies Used

- **[Solidity ^0.8.0](https://soliditylang.org/)** - Smart contract language
- **[Foundry](https://getfoundry.sh/)** - Ethereum development toolkit
- **[OpenZeppelin](https://openzeppelin.com/contracts/)** - Security-audited contract library
- **[Base64](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Base64.sol)** - On-chain metadata encoding
- **SVG** - Scalable vector graphics for NFT images

## 🎯 Key Features Explained

### Dynamic Metadata
The MoodNft contract stores all metadata and images on-chain using Base64 encoding. This ensures:
- **Permanence**: Images will never disappear
- **Decentralization**: No dependence on external servers
- **Immutability**: Content can't be changed unexpectedly

### Mood Flipping
- Each NFT starts with a `HAPPY` mood (default)
- Owners can flip between `HAPPY` and `SAD` states
- Mood changes are reflected immediately in the token's URI
- Access control prevents unauthorized mood changes

### SVG Integration
- Images are stored as SVG strings
- Scalable graphics that look crisp at any size
- Lightweight and efficient for on-chain storage

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Solidity style guide
- Write comprehensive tests
- Update documentation for new features
- Use conventional commit messages

## 📊 Gas Optimization

The contracts are optimized for gas efficiency:
- Minimal storage operations
- Efficient string operations
- Optimized access control checks

## 🔐 Security

- **Access Control**: Only token owners can flip moods
- **Input Validation**: Proper checks for token existence
- **OpenZeppelin**: Using battle-tested contract libraries
- **Testing**: Comprehensive test coverage

## 🔄 Roadmap

- [ ] Add more mood states (excited, angry, surprised)
- [ ] Implement mood history tracking
- [ ] Add rarity system for different mood combinations
- [ ] Create web interface for easy interaction
- [ ] Deploy to multiple chains

## 📞 Support

If you have questions or need help:
- Open an issue on GitHub
- Check the [Foundry documentation](https://book.getfoundry.sh/)
- Review the test files for usage examples

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [OpenZeppelin](https://openzeppelin.com/) for secure contract libraries
- [Foundry](https://getfoundry.sh/) for the excellent development toolkit
- [Patrick Collins](https://github.com/PatrickAlphaC) for educational content

---

Made with ❤️ by [Your Name]

*Happy coding! 🎭*
