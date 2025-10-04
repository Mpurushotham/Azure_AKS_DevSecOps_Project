package main

approved_registries := [
  "acrecommerceprod.azurecr.io",
  "mcr.microsoft.com"
]

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  image := container.image
  not image_from_approved_registry(image)
  msg = sprintf("Container '%s' uses unapproved registry", [container.name])
}

image_from_approved_registry(image) {
  registry := approved_registries[_]
  startswith(image, registry)
}
