{{- define "k8s.mutator.populateIngress" }}
{{- if and (kindIs "map" .Values.ingress) (kindIs "map" .Values.service) }}
{{- $_ := set .Values.ingress "paths" (list (dict "service" (include "k8s.factory.resourceName" .) "port" (first .Values.service.ports).port)) }}
{{- end }}
{{- end }}
