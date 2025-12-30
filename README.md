# T-travel 🌍✈️

> Decentralized Travel Booking Platform on Stacks Blockchain

[![Stacks](https://img.shields.io/badge/Stacks-Blockchain-5546FF)](https://www.stacks.co/)
[![Clarity](https://img.shields.io/badge/Clarity-v4.0-blue)](https://clarity-lang.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Overview

T-travel is a revolutionary decentralized travel booking platform built on the Stacks blockchain. It leverages smart contracts to provide transparent, trustless, and secure travel bookings while rewarding users for their participation in the ecosystem.

## ✨ Features

### Core Functionality
- 🔐 **Wallet Integration** - Connect with Hiro, Xverse, and other Stacks wallets
- 🏨 **Decentralized Bookings** - Book destinations with on-chain confirmation
- 💰 **STX Payments** - Secure payments using STX cryptocurrency
- ⭐ **On-chain Reviews** - Immutable, blockchain-verified reviews
- 🎁 **Rewards System** - Earn loyalty rewards for bookings and reviews
- 🔔 **Real-time Updates** - Live booking notifications via Chainhooks

### Technical Features
- 🌐 **Multi-Wallet Support** - WalletConnect integration
- 📱 **Progressive Web App** - Install as mobile app
- 🌙 **Dark Mode** - Beautiful dark theme support
- 🌍 **Internationalization** - Multi-language support
- ♿ **Accessibility** - WCAG 2.1 Level AA compliant
- 🚀 **Performance Optimized** - Code splitting, lazy loading
- 🔍 **SEO Optimized** - Server-side rendering ready

## 🛠️ Tech Stack

### Blockchain
- **Stacks Blockchain** - Layer-1 blockchain for Bitcoin
- **Clarity 4** - Smart contract language (Epoch 3.3)
- **@stacks/connect** - Wallet authentication
- **@stacks/transactions** - Transaction building
- **@hirosystems/chainhooks-client** - Real-time blockchain events

### Frontend
- **React 18** - UI library
- **TypeScript** - Type safety
- **Vite** - Build tool and dev server
- **React Router** - Client-side routing
- **CSS Modules** - Scoped styling

### Integration
- **WalletConnect** - Multi-wallet protocol
- **Hiro Platform** - Stacks API and tools

## 📦 Installation

### Prerequisites
- Node.js 18+ 
- npm or yarn
- Clarinet (for contract development)

### Quick Start

```bash
# Clone the repository
git clone https://github.com/Prettyface1/T-travel.git
cd T-travel

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env

# Update .env with your configuration
# - Add your WalletConnect Project ID
# - Configure network (testnet/mainnet)

# Start development server
npm run dev
```

The app will be available at `http://localhost:3000`

## 🔧 Development

### Project Structure

```
T-travel/
├── contracts/              # Clarity smart contracts
│   ├── t-travel-main.clar
│   ├── booking.clar
│   ├── payment.clar
│   ├── review.clar
│   └── rewards.clar
├── src/
│   ├── components/         # React components
│   ├── hooks/              # Custom React hooks
│   ├── services/           # Blockchain services
│   ├── utils/              # Utility functions
│   ├── types/              # TypeScript definitions
│   ├── pages/              # Route components
│   └── assets/             # Static assets
├── tests/                  # Test files
├── public/                 # Public assets
└── Clarinet.toml          # Clarinet configuration
```

### Available Scripts

```bash
# Development
npm run dev                 # Start dev server

# Build
npm run build              # Production build
npm run preview            # Preview production build

# Testing
npm run test               # Run tests
npm run test:ui            # Test UI

# Code Quality
npm run lint               # Lint code
npm run format             # Format code
```

### Smart Contract Development

```bash
# Check contracts
clarinet check

# Test contracts
clarinet test

# Deploy to testnet
clarinet deploy --testnet
```

## 🔐 Smart Contracts

### Main Contract (`t-travel-main.clar`)
- Platform configuration
- Admin controls
- Fee management

### Booking Contract (`booking.clar`)
- Create and manage bookings
- Booking validation
- Status tracking

### Payment Contract (`payment.clar`)
- Process STX payments
- Handle refunds
- Payment verification

### Review Contract (`review.clar`)
- Submit reviews
- Rating calculations
- Review verification

### Rewards Contract (`rewards.clar`)
- Calculate rewards
- Distribute loyalty points
- Track user balances

**Important:** All contracts use **Clarity 4** and avoid deprecated features like `as-contract`.

## 🌐 Environment Variables

Create a `.env` file with the following variables:

```env
# Network
VITE_NETWORK=testnet
VITE_STACKS_API_URL=https://api.testnet.hiro.so

# WalletConnect
VITE_WALLETCONNECT_PROJECT_ID=your_project_id

# Contracts (Update after deployment)
VITE_MAIN_CONTRACT_ADDRESS=
VITE_BOOKING_CONTRACT_ADDRESS=
VITE_PAYMENT_CONTRACT_ADDRESS=
VITE_REVIEW_CONTRACT_ADDRESS=
VITE_REWARDS_CONTRACT_ADDRESS=

# Chainhooks
VITE_CHAINHOOKS_BASE_URL=http://localhost:20456
```

## 🚀 Deployment

### Deploy Smart Contracts

1. **Configure Clarinet.toml** with deployment settings
2. **Deploy to testnet:**
   ```bash
   clarinet deploy --testnet
   ```
3. **Update .env** with deployed contract addresses

### Deploy Frontend

```bash
# Build production bundle
npm run build

# Deploy to hosting service
# (Vercel, Netlify, etc.)
```

## 🧪 Testing

### Contract Tests
```bash
clarinet test
```

### Frontend Tests
```bash
npm run test
```

### Integration Tests
```bash
npm run test:integration
```

## 📚 Documentation

- [API Documentation](docs/API.md)
- [Smart Contract Documentation](docs/CONTRACTS.md)
- [Architecture Overview](docs/ARCHITECTURE.md)
- [Deployment Guide](docs/DEPLOYMENT.md)
- [Contributing Guidelines](CONTRIBUTING.md)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- [Stacks Documentation](https://docs.stacks.co/)
- [Clarity Language Reference](https://docs.stacks.co/clarity/)
- [WalletConnect Docs](https://docs.walletconnect.network/)
- [Hiro Platform](https://www.hiro.so/)

## 👥 Team

Built with ❤️ by the T-travel Team

## 🙏 Acknowledgments

- Stacks Foundation
- Hiro Systems
- WalletConnect Team
- Open source community

---

**Happy Traveling on the Blockchain! 🚀**