# PayAPI-X 🧾

**PayAPI-X** is a Clarity smart contract that enables **pay-per-call API access** on the Stacks blockchain. It allows API service providers to monetize their off-chain APIs through micropayments in STX, and enables users to pay per request to gain access to these services.

## 🔍 Overview

- **Provider registration**: Service owners can register APIs and set per-call prices.
- **Per-call access**: Users pay STX to access a specific API.
- **Access verification**: A log of paid access is recorded on-chain and can be verified by external services or oracles.
- **Use case**: Works with relays or gateways that listen to contract events and grant actual access to off-chain endpoints.

---

## 📦 Features

- 🧩 API registration by providers
- 💸 Pay-per-use micropayment system
- 🔒 On-chain access log for auditing or off-chain validation
- 🧾 STX is directly transferred from users to providers

---

## 💻 Contract Structure

- `register-api(api-id, price)` – Registers an API endpoint with a price.
- `pay-for-api(provider, api-id)` – Allows users to pay and log access.
- `has-access(user, provider, api-id)` – Read-only function to check access.

---

## 🛠 Usage Example

```clarity
;; Provider registers an API with id 1 at price 10000 uSTX
(register-api u1 u10000)

;; User pays 10000 uSTX to access provider's API
(pay-for-api 'SP123... u1)

;; Off-chain service checks if user has paid
(has-access 'SP456... 'SP123... u1)
