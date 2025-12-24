{{- define "certManager.mutator.setGlobals" -}}
{{- $_ := set .Values "global" (mergeOverwrite (index .Values "cert-manager" "k8s") (unset (index .Values "cert-manager") "k8s") (coalesce .Values.global dict)) }}
{{- end }}