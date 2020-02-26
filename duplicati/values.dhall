let k8s = ../dhall/dependencies/dhall-kubernetes/1.15/typesUnion.dhall

let defaultDeployment         = ../dhall/k8s/deployment/default.dhall
let defaultContainer          = ../dhall/dependencies/dhall-kubernetes/1.15/defaults/io.k8s.api.core.v1.Container.dhall
let defaultContainerPort      = ../dhall/dependencies/dhall-kubernetes/1.15/defaults/io.k8s.api.core.v1.ContainerPort.dhall
let defaultEnvVar             = ../dhall/dependencies/dhall-kubernetes/1.15/defaults/io.k8s.api.core.v1.EnvVar.dhall

let createDeployment = ../dhall/k8s/deployment/create.dhall
let createLoadBalancerService = ../dhall/k8s/loadbalancerService/create.dhall
let createNFSVolumeMapping    = ../dhall/k8s/nfsVolumeMapping/create.dhall

let mainName = "duplicati"

let configVolumeMapping = createNFSVolumeMapping {
  name = "config",
  mountPath = "/config",
  server = "192.168.0.105",
  sourcePath = "/srv/nfs/duplicati"
}

let sourceVolumeMapping = createNFSVolumeMapping {
  name = "source",
  mountPath = "/source",
  server = "192.168.0.105",
  sourcePath = "/srv/nfs"
}

let port = 80
let targetPort = 8200

in {
  apiVersion = "v1",
  kind = "List",
  items = [
    k8s.Service ( createLoadBalancerService {
      name = mainName,
      ports = [
        {
          name = mainName,
          port = port,
          targetPort = targetPort
        }
      ],
      loadBalancerIP = "192.168.0.201"
    }),
    k8s.Deployment ( createDeployment ( defaultDeployment // {
      name = mainName,
      containers = [
        defaultContainer // {
          name = mainName
        } // {
          image = Some "linuxserver/duplicati",
          ports = Some [
            defaultContainerPort // {containerPort = targetPort}
          ],
          volumeMounts = Some [
            configVolumeMapping.volumeMount,
            sourceVolumeMapping.volumeMount
          ]
        }
      ],
      volumes = [
        configVolumeMapping.volume,
        sourceVolumeMapping.volume
      ]
    }))
  ]
}
