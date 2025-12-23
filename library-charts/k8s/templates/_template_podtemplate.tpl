{{- define "k8s.template.podTemplate" }}
{{- include "k8s.mutator.mergePodToValues" . }}
metadata:
  {{- if .Values.annotations }}
  annotations: {{ include "k8s.factory.mapAsMapString" .Values.annotations | indent 4 }}
  {{- end }}
  labels:
    {{- include "k8s.factory.helmLabels" . | indent 4 }}
    {{- include "k8s.factory.podSelectorLabel" . | indent 4 }}
    {{- include "k8s.factory.mapAsMapString" .Values.labels | indent 4 }}
{{- include "k8s.template.podSpec" . }}
{{- end }}