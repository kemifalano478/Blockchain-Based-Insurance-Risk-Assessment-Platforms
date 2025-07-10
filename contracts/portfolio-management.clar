;; Portfolio Management Contract
;; Manages insurance risk portfolios

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_PORTFOLIO_NOT_FOUND (err u501))
(define-constant ERR_INVALID_ALLOCATION (err u502))
(define-constant ERR_POLICY_NOT_FOUND (err u503))

;; Data structures
(define-map portfolios
  { portfolio-id: uint }
  {
    name: (string-ascii 50),
    manager: principal,
    total-value: uint,
    risk-limit: uint,
    current-risk: uint,
    policy-count: uint,
    created-date: uint,
    is-active: bool
  }
)

(define-map portfolio-policies
  { portfolio-id: uint, policy-id: uint }
  {
    premium: uint,
    coverage: uint,
    risk-score: uint,
    allocation-percentage: uint,
    added-date: uint
  }
)

(define-map portfolio-performance
  { portfolio-id: uint }
  {
    total-premiums: uint,
    total-claims: uint,
    profit-loss: int,
    risk-adjusted-return: uint,
    last-updated: uint
  }
)

(define-data-var next-portfolio-id uint u1)

;; Public functions
(define-public (create-portfolio
  (name (string-ascii 50))
  (manager principal)
  (risk-limit uint))
  (let (
    (portfolio-id (var-get next-portfolio-id))
  )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (> risk-limit u0) ERR_INVALID_ALLOCATION)

    (map-set portfolios
      { portfolio-id: portfolio-id }
      {
        name: name,
        manager: manager,
        total-value: u0,
        risk-limit: risk-limit,
        current-risk: u0,
        policy-count: u0,
        created-date: block-height,
        is-active: true
      }
    )

    (map-set portfolio-performance
      { portfolio-id: portfolio-id }
      {
        total-premiums: u0,
        total-claims: u0,
        profit-loss: 0,
        risk-adjusted-return: u0,
        last-updated: block-height
      }
    )

    (var-set next-portfolio-id (+ portfolio-id u1))
    (ok portfolio-id)
  )
)

(define-public (add-policy-to-portfolio
  (portfolio-id uint)
  (policy-id uint)
  (premium uint)
  (coverage uint)
  (risk-score uint)
  (allocation-percentage uint))
  (let (
    (portfolio (unwrap! (map-get? portfolios { portfolio-id: portfolio-id }) ERR_PORTFOLIO_NOT_FOUND))
    (new-risk (+ (get current-risk portfolio) risk-score))
    (new-policy-count (+ (get policy-count portfolio) u1))
    (new-total-value (+ (get total-value portfolio) coverage))
  )
    (asserts! (or (is-eq tx-sender CONTRACT_OWNER) (is-eq tx-sender (get manager portfolio))) ERR_UNAUTHORIZED)
    (asserts! (<= new-risk (get risk-limit portfolio)) ERR_INVALID_ALLOCATION)
    (asserts! (<= allocation-percentage u100) ERR_INVALID_ALLOCATION)

    (map-set portfolio-policies
      { portfolio-id: portfolio-id, policy-id: policy-id }
      {
        premium: premium,
        coverage: coverage,
        risk-score: risk-score,
        allocation-percentage: allocation-percentage,
        added-date: block-height
      }
    )

    (map-set portfolios
      { portfolio-id: portfolio-id }
      (merge portfolio
        {
          total-value: new-total-value,
          current-risk: new-risk,
          policy-count: new-policy-count
        }
      )
    )

    (update-portfolio-performance portfolio-id premium u0)
  )
)

(define-public (record-claim
  (portfolio-id uint)
  (claim-amount uint))
  (let (
    (performance (unwrap! (map-get? portfolio-performance { portfolio-id: portfolio-id }) ERR_PORTFOLIO_NOT_FOUND))
    (new-claims (+ (get total-claims performance) claim-amount))
    (total-premiums (get total-premiums performance))
    (new-profit-loss (- (to-int total-premiums) (to-int new-claims)))
  )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)

    (map-set portfolio-performance
      { portfolio-id: portfolio-id }
      (merge performance
        {
          total-claims: new-claims,
          profit-loss: new-profit-loss,
          last-updated: block-height
        }
      )
    )

    (ok true)
  )
)

(define-public (rebalance-portfolio (portfolio-id uint))
  (let (
    (portfolio (unwrap! (map-get? portfolios { portfolio-id: portfolio-id }) ERR_PORTFOLIO_NOT_FOUND))
  )
    (asserts! (or (is-eq tx-sender CONTRACT_OWNER) (is-eq tx-sender (get manager portfolio))) ERR_UNAUTHORIZED)

    ;; Simplified rebalancing logic
    (ok true)
  )
)

;; Private functions
(define-private (update-portfolio-performance
  (portfolio-id uint)
  (premium-change uint)
  (claim-change uint))
  (let (
    (performance (unwrap-panic (map-get? portfolio-performance { portfolio-id: portfolio-id })))
    (new-premiums (+ (get total-premiums performance) premium-change))
    (new-claims (+ (get total-claims performance) claim-change))
    (new-profit-loss (- (to-int new-premiums) (to-int new-claims)))
    (risk-adjusted-return (if (> new-premiums u0) (/ (* u100 new-premiums) (+ new-premiums new-claims)) u0))
  )
    (map-set portfolio-performance
      { portfolio-id: portfolio-id }
      {
        total-premiums: new-premiums,
        total-claims: new-claims,
        profit-loss: new-profit-loss,
        risk-adjusted-return: risk-adjusted-return,
        last-updated: block-height
      }
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-portfolio (portfolio-id uint))
  (map-get? portfolios { portfolio-id: portfolio-id })
)

(define-read-only (get-portfolio-policy (portfolio-id uint) (policy-id uint))
  (map-get? portfolio-policies { portfolio-id: portfolio-id, policy-id: policy-id })
)

(define-read-only (get-portfolio-performance (portfolio-id uint))
  (map-get? portfolio-performance { portfolio-id: portfolio-id })
)

(define-read-only (get-next-portfolio-id)
  (var-get next-portfolio-id)
)
