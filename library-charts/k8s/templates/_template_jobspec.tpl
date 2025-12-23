{{- define "k8s.template.jobSpec" }}
spec:
  parallelism: {{ coalesce .Values.parallelism .Values.global.job.parallelism }}
  completions: {{ coalesce .Values.completions .Values.global.job.completions }}
  restartPolicy: {{ coalesce .Values.restartPolicy .Values.global.job.restartPolicy }}
  {{- if .Values.activeDeadlineSeconds }}
  activeDeadlineSeconds: {{ .Values.activeDeadlineSeconds  }}
  {{- end }}
  template: {{ include "k8s.template.podTemplate" . | indent 4 }}
{{- end }}