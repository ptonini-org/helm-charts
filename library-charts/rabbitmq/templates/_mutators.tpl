{{- define "rabbitmq.mutator.setGlobals" -}}
{{- $_ := set .Values "global" (mergeOverwrite .Values.rabbitmq.k8s (unset .Values.rabbitmq "k8s") (coalesce .Values.global dict)) }}
{{- end }}