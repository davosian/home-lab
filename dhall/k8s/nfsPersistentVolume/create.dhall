\(values: ../common.dhall //\\ ./input.dhall) ->

let PV                          = ../../dependencies/dhall-kubernetes/types/io.k8s.api.core.v1.PersistentVolume.dhall

let defaultPV                   = ../../dependencies/dhall-kubernetes/defaults/io.k8s.api.core.v1.PersistentVolume.dhall
let defaultPVSpec               = ../../dependencies/dhall-kubernetes/defaults/io.k8s.api.core.v1.PersistentVolumeSpec.dhall
let defaultNFSVolumeSource      = ../../dependencies/dhall-kubernetes/defaults/io.k8s.api.core.v1.NFSVolumeSource.dhall
let defaultMeta                 = ../../dependencies/dhall-kubernetes/defaults/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta.dhall

in defaultPV // {
  metadata = defaultMeta // {
    name = values.name
  } // {
    labels = [
      {
        mapKey = "type",
        mapValue = "local"
      }
    ]
  }
} // {
  spec = Some (defaultPVSpec // {
    accessModes = [
      "ReadWriteOnce"
    ],
    storageClassName = Some values.storageClassName,
    capacity = [
      {
        mapKey = "storage",
        mapValue = values.capacity
      }
    ],
    nfs = Some (defaultNFSVolumeSource // {
      server = values.server,
      path = values.path
    })
  })
}: PV
