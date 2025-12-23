{{/* Remove labels and annotations and merge pod context */}}
{{ define "k8s.mutator.mergePodToValues" -}}
{{- $values := unset (unset (deepCopy .Values) "annotations") "labels" }}
{{- $_ := set . "Values" (mergeOverwrite $values (coalesce .Values.pod dict)) }}
{{- end }}