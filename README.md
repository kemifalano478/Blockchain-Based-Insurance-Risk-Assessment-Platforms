# Blockchain-Based Insurance Risk Assessment Platform

A comprehensive blockchain platform built on Stacks using Clarity smart contracts for managing insurance risk assessment, pricing optimization, and portfolio management.

## 🏗️ Architecture Overview

The platform consists of five interconnected smart contracts:

### 1. Risk Assessor Verification Contract
- **Purpose**: Validates and manages certified insurance risk assessors
- **Key Features**:
    - Assessor registration and verification
    - License validation and tracking
    - Performance rating system
    - Active status management

### 2. Data Collection Contract
- **Purpose**: Collects and manages risk assessment data
- **Key Features**:
    - Risk data submission and validation
    - Client profile management
    - Data verification workflow
    - Historical data tracking

### 3. Risk Modeling Contract
- **Purpose**: Models and calculates insurance risks using various algorithms
- **Key Features**:
    - Multiple risk model support
    - Dynamic risk calculation
    - Confidence level assessment
    - Model performance tracking

### 4. Pricing Optimization Contract
- **Purpose**: Optimizes insurance pricing based on risk models and market factors
- **Key Features**:
    - Dynamic premium calculation
    - Market factor adjustments
    - Discount application system
    - Quote management

### 5. Portfolio Management Contract
- **Purpose**: Manages insurance risk portfolios and performance tracking
- **Key Features**:
    - Portfolio creation and management
    - Policy allocation and tracking
    - Claims management
    - Performance analytics

## 🚀 Getting Started

### Prerequisites
- Node.js (v16 or higher)
- Clarinet CLI
- Stacks wallet for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd blockchain-insurance-platform
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Initialize Clarinet project:
   \`\`\`bash
   clarinet new insurance-platform
   \`\`\`

### Running Tests

Execute the test suite using Vitest:

\`\`\`bash
npm test
\`\`\`

Run specific test files:
\`\`\`bash
npm test risk-assessor-verification.test.ts
npm test data-collection.test.ts
npm test risk-modeling.test.ts
npm test pricing-optimization.test.ts
npm test portfolio-management.test.ts
\`\`\`

## 📋 Contract Specifications

### Risk Assessor Verification
- **Contract**: \`risk-assessor-verification.clar\`
- **Main Functions**:
    - \`register-assessor\`: Register new risk assessors
    - \`deactivate-assessor\`: Deactivate assessors
    - \`update-assessor-rating\`: Update performance ratings
    - \`get-assessor\`: Retrieve assessor information

### Data Collection
- **Contract**: \`data-collection.clar\`
- **Main Functions**:
    - \`submit-risk-data\`: Submit risk assessment data
    - \`verify-risk-data\`: Verify submitted data
    - \`register-client\`: Register new clients
    - \`get-risk-data\`: Retrieve risk data

### Risk Modeling
- **Contract**: \`risk-modeling.clar\`
- **Main Functions**:
    - \`create-risk-model\`: Create new risk models
    - \`calculate-risk\`: Calculate risk scores
    - \`deactivate-model\`: Deactivate models
    - \`get-risk-model\`: Retrieve model information

### Pricing Optimization
- **Contract**: \`pricing-optimization.clar\`
- **Main Functions**:
    - \`create-pricing-model\`: Create pricing models
    - \`calculate-premium\`: Calculate insurance premiums
    - \`apply-discount\`: Apply discounts to quotes
    - \`get-quote\`: Retrieve quote information

### Portfolio Management
- **Contract**: \`portfolio-management.clar\`
- **Main Functions**:
    - \`create-portfolio\`: Create new portfolios
    - \`add-policy-to-portfolio\`: Add policies to portfolios
    - \`record-claim\`: Record insurance claims
    - \`rebalance-portfolio\`: Rebalance portfolio allocations

## 🔧 Configuration

### Environment Variables
Create a \`.env\` file with the following variables:
\`\`\`
STACKS_NETWORK=testnet
DEPLOYER_PRIVATE_KEY=your_private_key_here
CONTRACT_ADDRESS=your_contract_address_here
\`\`\`

### Clarinet Configuration
Update \`Clarinet.toml\` with your contract configurations:
\`\`\`toml
[contracts.risk-assessor-verification]
path = "contracts/risk-assessor-verification.clar"

[contracts.data-collection]
path = "contracts/data-collection.clar"

[contracts.risk-modeling]
path = "contracts/risk-modeling.clar"

[contracts.pricing-optimization]
path = "contracts/pricing-optimization.clar"

[contracts.portfolio-management]
path = "contracts/portfolio-management.clar"
\`\`\`

## 🧪 Testing Strategy

The platform includes comprehensive test coverage:

- **Unit Tests**: Individual contract function testing
- **Integration Tests**: Cross-contract interaction testing
- **Error Handling**: Comprehensive error scenario coverage
- **Edge Cases**: Boundary condition testing

### Test Structure
- \`tests/\`: Contains all test files
- Each contract has dedicated test file
- Tests cover both success and failure scenarios
- Mock data used for consistent testing

## 📊 Usage Examples

### Registering a Risk Assessor
\`\`\`clarity
(contract-call? .risk-assessor-verification register-assessor
'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
"John Doe"
"LIC123456"
"Property Insurance"
u10)
\`\`\`

### Submitting Risk Data
\`\`\`clarity
(contract-call? .data-collection submit-risk-data
'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
"CLIENT001"
"Property"
u75
(list u10 u20 u30 u40 u50))
\`\`\`

### Creating a Risk Model
\`\`\`clarity
(contract-call? .risk-modeling create-risk-model
"Property Risk Model"
"Property"
u50
(list u10 u15 u20 u25 u30))
\`\`\`

## 🔒 Security Considerations

- **Access Control**: Owner-only functions for critical operations
- **Input Validation**: Comprehensive parameter validation
- **Error Handling**: Proper error codes and messages
- **Data Integrity**: Immutable blockchain storage
- **Authorization**: Role-based access control

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

## 🗺️ Roadmap

- [ ] Advanced risk modeling algorithms
- [ ] Machine learning integration
- [ ] Real-time data feeds
- [ ] Mobile application interface
- [ ] Advanced analytics dashboard
- [ ] Multi-chain support

---

**Note**: This platform is designed for educational and development purposes. Ensure proper testing and auditing before production deployment.
\`\`\`
