package main

deny[msg] {
  input.kind == "Ingress"
  not input.spec.tls
  msg = "Ingress must have TLS configured"
}
