{{- define "k8s.template.container" }}
- name: {{ .name }}
  image: {{ include "k8s.factory.containerImage" .image }}
  {{- if .imagePullPolicy }}
  imagePullPolicy: {{ .imagePullPolicy }}
  {{- end }}
  {{- if .command }}
  command: {{ .command | toYaml | nindent 4 }}
  {{- end }}
  {{- if .args }}
  args: {{ .args | toYaml | nindent 4 }}
  {{- end }}
  {{- if .env }}
  env: {{ include "k8s.factory.mapAsEnvList" .env | indent 4 }}
  {{- end }}
  {{- if or .envSecretRefs .envConfigMapRefs  }}
  envFrom:
    {{- range .envConfigMapRefs }}
    - configMapRef:
        name: {{ . }}
    {{- end }}
    {{- range .envSecretRefs }}
    - secretRef:
        name: {{ . }}
    {{- end }}
  {{- end }}
  {{- if .volumeMounts }}
  volumeMounts: {{ .volumeMounts | toYaml | nindent 4 }}
  {{- end }}
  {{- if .service }}
  ports:
    {{- range .service.ports }}
    - containerPort: {{ coalesce .targetPort .port }}
      protocol: {{ include "k8s.factory.serviceProtocol" . }}
    {{- end }}
  {{- end }}
  {{- if .resources }}
  resources: {{ .resources | toYaml | nindent 4 }}
  {{- end }}
  {{- if .readinessProbe }}
  readinessProbe: {{ .readinessProbe | toYaml | nindent 4 }}
  {{- end }}
  {{- if .livenessProbe }}
  livenessProbe: {{ .livenessProbe | toYaml | nindent 4 }}
  {{- end }}
  {{- if .lifecycle }}
  lifecycle: {{ .lifecycle | toYaml }}
  {{- end }}
{{- end }}