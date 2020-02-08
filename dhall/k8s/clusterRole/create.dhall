\(values: ./input.dhall) ->

let ClusterRole            = ../../dependencies/dhall-kubernetes/1.15/types/io.k8s.api.rbac.v1.ClusterRole.dhall

let defaultClusterRole     = ../../dependencies/dhall-kubernetes/1.15/defaults/io.k8s.api.rbac.v1.ClusterRole.dhall
let defaultPolicyRule      = ../../dependencies/dhall-kubernetes/1.15/defaults/io.k8s.api.rbac.v1.PolicyRule.dhall
let defaultMeta            = ../../dependencies/dhall-kubernetes/1.15/defaults/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta.dhall

in defaultClusterRole // {
  metadata = defaultMeta // {
    name = values.name
  },
  rules = [ defaultPolicyRule // {
    verbs = values.verbs
  } // {
    apiGroups = values.apiGroups,
    resources = values.resources
  } ]
} : ClusterRole
