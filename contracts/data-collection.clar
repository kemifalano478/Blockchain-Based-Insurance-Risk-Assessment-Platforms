;; Data Collection Contract
;; Collects and manages risk assessment data

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_INVALID_DATA (err u201))
(define-constant ERR_DATA_NOT_FOUND (err u202))

;; Data structures
(define-map risk-data
  { data-id: uint }
  {
    assessor-id: principal,
    client-id: (string-ascii 50),
    risk-type: (string-ascii 30),
    risk-score: uint,
    data-points: (list 10 uint),
    collection-date: uint,
    is-verified: bool
  }
)

(define-map client-profiles
  { client-id: (string-ascii 50) }
  {
    name: (string-ascii 100),
    industry: (string-ascii 50),
    size: (string-ascii 20),
    location: (string-ascii 50),
    risk-history: (list 5 uint)
  }
)

(define-data-var next-data-id uint u1)

;; Public functions
(define-public (submit-risk-data
  (assessor-id principal)
  (client-id (string-ascii 50))
  (risk-type (string-ascii 30))
  (risk-score uint)
  (data-points (list 10 uint)))
  (let (
    (data-id (var-get next-data-id))
  )
    (asserts! (> risk-score u0) ERR_INVALID_DATA)
    (asserts! (<= risk-score u100) ERR_INVALID_DATA)

    (map-set risk-data
      { data-id: data-id }
      {
        assessor-id: assessor-id,
        client-id: client-id,
        risk-type: risk-type,
        risk-score: risk-score,
        data-points: data-points,
        collection-date: block-height,
        is-verified: false
      }
    )

    (var-set next-data-id (+ data-id u1))
    (ok data-id)
  )
)

(define-public (verify-risk-data (data-id uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (is-some (map-get? risk-data { data-id: data-id })) ERR_DATA_NOT_FOUND)

    (map-set risk-data
      { data-id: data-id }
      (merge
        (unwrap-panic (map-get? risk-data { data-id: data-id }))
        { is-verified: true }
      )
    )

    (ok true)
  )
)

(define-public (register-client
  (client-id (string-ascii 50))
  (name (string-ascii 100))
  (industry (string-ascii 50))
  (size (string-ascii 20))
  (location (string-ascii 50)))
  (begin
    (map-set client-profiles
      { client-id: client-id }
      {
        name: name,
        industry: industry,
        size: size,
        location: location,
        risk-history: (list)
      }
    )

    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-risk-data (data-id uint))
  (map-get? risk-data { data-id: data-id })
)

(define-read-only (get-client-profile (client-id (string-ascii 50)))
  (map-get? client-profiles { client-id: client-id })
)

(define-read-only (get-next-data-id)
  (var-get next-data-id)
)
