{{/* Inject container in values if not explicitly declared */}}
{{ define "k8s.mutator.injectContainer" -}}
{{- if and (not .Values.containers) (not ((.Values).pod).containers) }}
{{- $_ := set .Values "containers" (list (set (deepCopy .Values) "name" (include "k8s.factory.resourceName" .))) }}
{{- end }}
{{- end }}