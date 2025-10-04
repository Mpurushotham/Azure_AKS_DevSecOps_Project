package main

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.securityContext.capabilities.drop
  msg = sprintf("Container '%s' must drop all capabilities", [container.name])
}
