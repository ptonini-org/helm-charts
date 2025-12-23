{{- define "k8s.template.metadata" }}
metadata:
  {{- if or .Values.resourceGenerateName .Values.generateName }}
  generateName: {{ coalesce .Values.resourceGenerateName .Values.generateName }}
  {{- else }}
  name: {{ include "k8s.factory.resourceName" . }}
  {{- end }}
  {{- if .Values.namespaced }}
  namespace: {{ include "k8s.factory.resourceNamespace" . }}
  {{- end }}
  {{- if .Values.annotations }}
  annotations: {{- include "k8s.factory.mapAsMapString" .Values.annotations | indent 4 }}
  {{- end }}
  labels:
    {{- include "k8s.factory.helmLabels" . | indent 4 }}
    {{- include "k8s.factory.mapAsMapString" .Values.labels | indent 4 }}
{{- end }}