{{- define "kong.mutator.setGlobals" -}}
{{- $_ := set .Values "global" (mergeOverwrite .Values.kong.k8s (unset .Values.kong "k8s") (coalesce .Values.global dict)) }}
{{- end }}