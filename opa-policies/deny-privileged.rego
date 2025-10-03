package main

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  container.securityContext.privileged == true
  msg = sprintf("Container '%s' is running in privileged mode", [container.name])
}
