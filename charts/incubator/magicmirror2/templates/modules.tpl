{{/* Define the configmap */}}
{{- define "magicmirror.modules" -}}

{{- $configName := printf "%s-magicmirror-modules" (include "tc.common.names.fullname" .) }}
{{- $configEnvName := printf "%s-magicmirror-env" (include "tc.common.names.fullname" .) }}

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configName }}
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
data:
  modules.txt: |
    {{- range .Values.magicmirror.mm2_modules_dl }}
        {{ . | quote }}-y
        {{- end }}
---

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configEnvName }}
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
data:
  DATA_DIR: /magicmirror2
  UID: {{ .Values.security.PUID | quote }}
  GID: {{ .Values.podSecurityContext.fsGroup | quote }}
{{- end -}}
