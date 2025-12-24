{{- define "eck.template.componentSpec" }}
{{- $component := index . 1}}
{{- with (index . 0 ) }}
version: {{ coalesce .Values.version .Values.global.version }}
count: {{ coalesce .Values.count .Values.global.count }}
{{- include "eck.template.http" (mergeOverwrite (coalesce .Values.global.http dict) (coalesce .Values.http dict)) }}
elasticsearchRef:
  name: {{ .Release.Name }}
{{- if .Values.config }}
config: {{ .Values.config | toYaml | nindent 2 }}
{{- end }}
podTemplate:
  spec:
    serviceAccountName: {{ include "k8s.factory.serviceAccountName" . }}
    {{- if .Values.nodeSelector }}
    nodeSelector: {{ .Values.nodeSelector | toYaml | nindent 6 }}
    {{- end }}
    {{- if .Values.tolerations }}
    tolerations: {{ .Values.tolerations | toYaml | nindent 6 }}
    {{- end }}
    containers:
      - name: {{ $component }}
        {{- if .Values.resources }}
        resources: {{ .Values.resources | toYaml | nindent 10 }}
        {{- end }}
        {{- if .Values.env }}
        env: {{ include "k8s.factory.mapAsEnvList" .Values.env | indent 12 }}
        {{- end }}
{{- end }}
{{- end }}


{{- define "eck.template.http" }}
{{- if . }}
http:
  {{- if .tls }}
  tls: {{ .tls | toYaml | nindent 4 }}
  {{- end }}
  {{- if .service }}
  service:
    {{- if .service.annotations }}
    metadata:
      annotations: {{ .service.annotations | toYaml | nindent 8 }}
    {{- end }}
    spec: {{ unset (deepCopy .service) "annotations" | toYaml | nindent 6 }}
    {{- end }}
{{- end }}
{{- end }}