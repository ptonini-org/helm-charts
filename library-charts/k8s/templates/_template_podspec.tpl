{{- define "k8s.template.podSpec" }}
spec:
  serviceAccountName: {{ include "k8s.factory.serviceAccountName" . }}
  {{- if .Values.nodeSelector }}
  nodeSelector: {{ .Values.nodeSelector | toYaml | nindent 4 }}
  {{- end }}
  {{- if .Values.imagePullSecrets }}
  imagePullSecrets: {{ include "k8s.factory.listAsNameList" .Values.imagePullSecrets | indent 4 }}
  {{- end }}
  {{- if .Values.tolerations }}
  tolerations: {{ .Values.tolerations | toYaml | nindent 4 }}
  {{- end }}
  {{- if .Values.terminationGracePeriodSeconds }}
  terminationGracePeriodSeconds: {{ .Values.terminationGracePeriodSeconds }}
  {{- end }}
  {{- if .Values.hostNetwork }}
  hostNetwork: {{ .Values.hostNetwork }}
  {{- end }}
  {{- if .Values.hostPID }}
  hostPID: {{ .Values.hostPID }}
  {{- end }}
  {{- if .Values.dnsPolicy }}
  dnsPolicy: {{ .Values.dnsPolicy }}
  {{- end }}
  {{- if .Values.restartPolicy }}
  restartPolicy: {{ .Values.restartPolicy }}
  {{- end }}
  {{- if .Values.securityContext }}
  securityContext: {{ .Values.securityContext | toYaml | nindent 4 }}
  {{- end }}
  {{- if or .Values.volumes .Values.serviceAccountTokenVolume }}
  volumes: {{ .Values.volumes | toYaml | nindent 4 }}
    {{- if .Values.serviceAccountTokenVolume }}
    - name: {{ coalesce .Values.serviceAccountTokenVolume.name .Values.global.pod.serviceAccountTokenVolume.name  }}
      projected:
        sources:
          - serviceAccountToken:
              path: {{ coalesce .Values.serviceAccountTokenVolume.path .Values.serviceAccountTokenVolume.name .Values.global.pod.serviceAccountTokenVolume.name }}
              expirationSeconds: {{ coalesce .Values.serviceAccountTokenVolume.expiration .Values.global.pod.serviceAccountTokenVolume.expiration }}
              {{- if .Values.serviceAccountTokenVolume.audience }}
              audience: {{ .Values.serviceAccountTokenVolume.audience }}
              {{- end }}
    {{- end }}
  {{- end }}
  {{- if .Values.initContainers }}
  initContainers:
    {{- range .Values.initContainers }}
    {{- include "k8s.template.container" . | indent 4 }}
    {{- end }}
  {{- end }}
  containers:
    {{- range .Values.containers }}
    {{- include "k8s.template.container" (set . "service" $.Values.service) | indent 4 }}
    {{- end }}
{{- end }}