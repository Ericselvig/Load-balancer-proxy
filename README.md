# Load Balancer Proxy [Wasserstoff: Task 2 (2024 Blockchain Interviews)]

## Description
This proeject implements a proxy contract that can be used to balance the load between multiple implementations such as Staking, Voting, etc. The proxy contract is responsible for routing the calls to the appropriate implementation contract.

## Design
The project is divided into two main components:
1. **Load Balancer contract**: This is the proxy contract that is responsible for routing the calls to the appropriate implementation contract. The proxy contract uses the registry contract to determine which implementation contract to route the call to.
2. **Implementation Contracts**: The implementation contracts are the actual contracts that implement the functionality. The implementation contracts are registered in the registry contract.

### Actors
1. **User**: The user is the external entity that interacts with the proxy contract to access the functionality provided by the implementation contracts.
2. **Owner**: The owner is the entity that deploys the proxy contract and has the ability to add/remove implementation contracts from the registry contract.

### Design Pattern
This project is inspired from the Diamond proxy pattern. It has been modified such that instead of storing the function selectors mapped to their implementation contracts, the proxy contract uses a `implementation id` to determine which implementation contract to route the call to.

## Workflow
1. **Deployment**: The owner deploys the Load Balancer contract.
2. **Registration**: The owner registers the implementation contracts in the registry and deploys and links the appropriate library contracts.
3. **Usage**: The user interacts with the proxy contract to access the functionality provided by the implementation contracts.

## Project Structure

```js
src/
└── contracts/
    ├── interfaces/
    │   └── ILoadBalancer.sol
    |
    ├── core/
    │   └── LoadBalancer.sol
    |
    ├── implementations/
    │   ├── Staking.sol
    │   └── Voting.sol
    |
    └── libraries/
        ├── LibLoadBalancer.sol
        ├── LibVoting.sol
        └── LibStaking.sol
```
**Note**: The contracts in this project are not audited and should not be used in production without proper security audits.