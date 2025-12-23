{{- define "k8s.mutator.setGlobals" -}}
{{- $_ := set .Values "global" (mergeOverwrite .Values.k8s (coalesce .Values.global dict)) }}
{{- end }}