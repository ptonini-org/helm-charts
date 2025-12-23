{{- define "k8s.factory.subResource" }}
{{- $root := deepCopy (index . 0) }}
{{- $template := index . 1 }}
{{- $values := get $root.Values (index . 2) }}
{{- if kindIs "map" $values }}
  {{ include "k8s.factory.subResource.template" (list $root $template $values) }}
{{- else if kindIs "slice" $values }}
  {{- range $values }}{{- include "k8s.factory.subResource.template" (list $root $template .) }}{{- end }}
{{- end }}
{{- end }}


{{- define "k8s.factory.subResource.template" }}
{{- $root := index . 0 }}
{{ include (index . 1) (dict "Chart" $root.Chart "Release" $root.Release "Values" (set (index . 2) "global" $root.Values.global)) }}
{{- end }}


{{- define "k8s.factory.helmLabels" }}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ $.Chart.Name }}-{{ $.Chart.Version | replace "+" "_" }}
{{- end }}

{{- define "k8s.factory.resourceName" }}
{{- coalesce .Values.resourceName .Release.Name }}
{{- end}}


{{- define "k8s.factory.resourceNamespace" }}
{{- coalesce .Values.resourceNamespace .Release.Namespace }}
{{- end}}


{{- define "k8s.factory.serviceProtocol" }}
{{- coalesce .protocol "TCP" }}
{{- end }}


{{- define "k8s.factory.mapAsMapString" }}
{{- range $k, $v := . }}
{{ $k }}: {{ $v | toString | quote }}
{{- end }}
{{- end }}


{{- define "k8s.factory.mapAsEnvList" }}
{{- range $k, $v := . }}
- name: {{ $k }}
  value: {{ ternary ($v | toYaml | indent 4) ($v | toString | quote) (kindIs "map" $v) }}
{{- end }}
{{- end }}


{{- define "k8s.factory.listAsNameList" }}
{{- range . }}
- name: {{ . }}
{{- end }}
{{- end }}


{{- define "k8s.factory.podSelectorLabelKey" }}
{{ coalesce .Values.selectorLabelKey ((.Values).pod).selectorLabelKey .Values.global.pod.selectorLabelKey }}
{{- end }}


{{- define "k8s.factory.podSelectorLabelValue" }}
{{ coalesce .Values.selectorLabelValue ((.Values).pod).selectorLabelValue (include "k8s.factory.resourceName" .) }}
{{- end }}


{{- define "k8s.factory.podSelectorLabel" }}
{{ printf "%s: %s" (include "k8s.factory.podSelectorLabelKey" .) (include "k8s.factory.podSelectorLabelValue" .) }}
{{- end }}


{{- define "k8s.factory.serviceAccountName" }}
{{- if kindIs "map" .Values.serviceAccount }}
{{ coalesce .Values.serviceAccount.resourceName .Values.resourceName .Release.Name }}
{{- else }}
{{ coalesce .Values.serviceAccountName ((.Values).pod).serviceAccountName .Values.global.pod.serviceAccountName }}
{{- end }}
{{- end }}


{{- define "k8s.factory.containerImage" }}
{{- if kindIs "string" . }}{{ . }}
{{- else }}
{{- if .registry }}{{ .registry }}/{{ end }}{{ .repository }}{{ if .tag }}:{{ .tag }}{{ else if .digest }}@{{ .digest }}{{ end }}
{{- end }}
{{- end }}


{{- define "k8s.factory.roleKind" }}
{{ ternary "Role" "ClusterRole"   }}
{{- end }}