.PHONY: update anvil deploy test test-zksync clean remove install build interact mint

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
PRIVATE_KEYS=ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80


# Network configuration
RPC_URL ?= https://eth-sepolia.g.alchemy.com/v2/jGwbjkbqJuLgtsN_VNZo8bMyFywYr4lz
PRIVATE_KEY ?= $(DEFAULT_ANVIL_KEY)
SEP_PRIVATE_KEY ?= $(PRIVATE_KEYS)
address ?= $(0xf6d6411245dbc296fdabcbefbac60e1f32b600a3)


all: clean remove install update build

clean :; forge clean 

remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install

update:; forge update

build :; forge build

anvil:;  anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

deploy:; forge script script/DeployBasicNFT.s.sol:DeployBasicNFT --broadcast --rpc-url $(RPC_URL) --private-key $(SEP_PRIVATE_KEY) -vvvv

interact:; forge script script/Interaction.s.sol:MintBasicNft --broadcast --rpc-url $(RPC_URL) --private-key $(SEP_PRIVATE_KEY) -vvvv

mint:; forge script script/Interaction.s.sol:MintBasicNft --sig "mintNftOnContract(address)" --broadcast --rpc-url $(RPC_URL) --private-key $(SEP_PRIVATE_KEY) -vvvv

zktest :; foundryup-zksync && forge test --zksync && foundryup

test :; forge test

test-match:; forge test --match-test $(TEST_NAME)

test-gas:; forge test --gas-report

deploy-anvil:; forge script script/DeployMoodNft.s.sol:DeployMoodNft --broadcast --rpc-url http://127.0.0.1:8545 --private-key $(DEFAULT_ANVIL_KEY) -vvvv

mint-anvil:; forge script script/Interaction.s.sol:MintMoodNft --broadcast --rpc-url http://127.0.0.1:8545 --private-key $(DEFAULT_ANVIL_KEY) -vvvv

flip-mood-anvil:; forge script script/Interaction.s.sol:FlipMoodNft --broadcast --rpc-url http://127.0.0.1:8545 --private-key $(DEFAULT_ANVIL_KEY) -vvvv

deployMoodNft-anvil:; forge script script/DeployMoodNft.s.sol:DeployMoodNft --broadcast --rpc-url http://127.0.0.1:8545 --private-key $(DEFAULT_ANVIL_KEY) -vvvv

-include .env