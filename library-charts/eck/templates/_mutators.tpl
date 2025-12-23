{{- define "eck.mutator.setGlobals" }}
{{- $_ := set .Values "global" (mergeOverwrite .Values.eck.k8s (unset .Values.eck "k8s") (coalesce .Values.global dict)) }}
{{- end }}


{{- define "eck.mutator.enrichIngress" }}
{{- $root := index . 0 }}
{{- $resourceName := printf "%s-%s" $root.Release.Name (index . 1) }}
{{- if kindIs "map" $root.Values.ingress }}
{{- $_ := set $root.Values.ingress "resourceName" $resourceName }}
{{- $_ = set $root.Values.ingress "paths" (list (dict "port" (index . 2) "service" (printf "%s-http" $resourceName ))) }}
{{- $_ = set $root.Values.ingress "certificate" (printf "%s-ingress-tls" $resourceName) }}
{{- end }}
{{- end }}
