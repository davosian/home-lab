\(values: ../common.dhall //\\ ./input.dhall) ->

let map = ../../dependencies/dhall-lang/Prelude/List/map
let Secret = ../../dependencies/dhall-kubernetes/types/io.k8s.api.core.v1.Secret.dhall

let defaultSecret     = ../../dependencies/dhall-kubernetes/defaults/io.k8s.api.core.v1.Secret.dhall

let defaultMeta        = ../../dependencies/dhall-kubernetes/defaults/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta.dhall

let base = defaultSecret // {
  metadata = defaultMeta // {
    name = values.name
  }
} // {
  stringData = values.secrets
}: Secret

let addNamespaces = \(namespace: Text) ->
  base // {
    metadata = defaultMeta // {
      name = values.name
    } // {
      namespace = Some namespace
    }
  }

in map Text Secret addNamespaces values.namespaces
