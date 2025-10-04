package main

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.securityContext.readOnlyRootFilesystem == true
  msg = sprintf("Container '%s' must have readOnlyRootFilesystem", [container.name])
}
