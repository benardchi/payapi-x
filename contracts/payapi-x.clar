(define-constant err-not-owner (err u100))
(define-constant err-not-registered (err u101))
(define-constant err-insufficient-payment (err u102))

(define-data-var owner principal tx-sender)

(define-map apis
  {provider: principal, api-id: uint}
  {
    price: uint,
    active: bool
  }
)

(define-map access-log
  {user: principal, provider: principal, api-id: uint}
  {
    timestamp: uint
  }
)

;; Only owner can register new APIs
(define-public (register-api (api-id uint) (price uint))
  (begin
    (if (is-eq tx-sender (var-get owner))
        (begin
          (map-set apis
            {provider: tx-sender, api-id: api-id}
            {price: price, active: true}
          )
          (ok true)
        )
        err-not-owner
    )
  )
)

;; Users pay per API access
(define-public (pay-for-api (provider principal) (api-id uint) (amount uint))
  (let
    (
      (api-info (map-get? apis {provider: provider, api-id: api-id}))
    )
    (match api-info api
      (if (and (get active api) (>= amount (get price api)))
          (match (stx-transfer? (get price api) tx-sender provider)
            success (begin
              (map-set access-log
                {user: tx-sender, provider: provider, api-id: api-id}
                {timestamp: stacks-block-height}
              )
              (ok true)
            )
            error (err u103)
          )
          err-insufficient-payment
      )
      err-not-registered
    )
  )
)

;; Read-only to check access
(define-read-only (has-access (user principal) (provider principal) (api-id uint))
  (is-some (map-get? access-log {user: user, provider: provider, api-id: api-id}))
)
