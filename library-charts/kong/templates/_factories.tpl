{{- define "kong.factory.pluginKind" }}
{{- ternary "KongClusterPlugin" "KongPlugin" (eq .Values.scope .Values.global.scopes.cluster) }}
{{- end }}