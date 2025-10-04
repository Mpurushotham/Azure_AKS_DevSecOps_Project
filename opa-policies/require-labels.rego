package main

required_labels := ["app", "tier", "version"]

deny[msg] {
  input.kind == "Deployment"
  provided_labels := {label | input.metadata.labels[label]}
  required := {label | label := required_labels[_]}
  missing := required - provided_labels
  count(missing) > 0
  msg = sprintf("Deployment must have labels: %v", [missing])
}
